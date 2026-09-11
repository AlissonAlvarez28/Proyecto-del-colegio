/**
 * Gestión de usuarios y roles — solo Administradores.
 *
 * Incluye protecciones importantes contra errores irreversibles:
 *  - Nadie puede quitarse a sí mismo el rol de Administrador.
 *  - No se puede desactivar la última cuenta de Administrador activa.
 * Sin estas reglas, un clic equivocado dejaría el sistema sin nadie que
 * pueda administrarlo, y habría que arreglarlo a mano en la base de datos.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';
import { asyncHandler } from '../utils/crud.js';

const router = Router();

/** Cuenta cuántos administradores activos quedan. */
async function contarAdminsActivos() {
  const [fila] = await query(
    `SELECT COUNT(DISTINCT u.id) AS n
     FROM usuarios u
     JOIN usuario_roles ur ON ur.usuario_id = u.id
     JOIN roles r          ON r.id = ur.rol_id
     WHERE r.nombre = 'Administrador' AND u.estado = 'activo'`
  );
  return fila.n;
}

async function esAdministrador(usuarioId) {
  const filas = await query(
    `SELECT 1 FROM usuario_roles ur
     JOIN roles r ON r.id = ur.rol_id
     WHERE ur.usuario_id = ? AND r.nombre = 'Administrador'`,
    [usuarioId]
  );
  return filas.length > 0;
}

/** GET /api/usuarios — lista de cuentas (nunca expone hashes) */
router.get('/',
  requiereAuth,
  requierePermiso('gestionar_usuarios'),
  asyncHandler(async (_req, res) => {
    const usuarios = await query(
      `SELECT u.id, u.nombre_completo, u.correo, u.estado,
              u.fecha_invitacion, u.fecha_activacion, u.ultimo_acceso,
              inv.nombre_completo AS invitado_por
       FROM usuarios u
       LEFT JOIN usuarios inv ON inv.id = u.invitado_por
       ORDER BY u.created_at DESC`
    );

    const roles = await query(
      `SELECT ur.usuario_id, r.id AS rol_id, r.nombre AS rol
       FROM usuario_roles ur JOIN roles r ON r.id = ur.rol_id`
    );

    const datos = usuarios.map((u) => ({
      ...u,
      roles: roles.filter((r) => r.usuario_id === u.id).map((r) => ({ id: r.rol_id, nombre: r.rol })),
    }));

    res.json({ datos });
  })
);

/** GET /api/usuarios/roles — catálogo de roles disponibles */
router.get('/roles',
  requiereAuth,
  requierePermiso('gestionar_usuarios'),
  asyncHandler(async (_req, res) => {
    const filas = await query('SELECT id, nombre, descripcion FROM roles ORDER BY id');
    res.json({ datos: filas });
  })
);

/**
 * POST /api/usuarios/:id/roles — asignar un rol.
 * Este es el endpoint que implementa tu regla: solo un Administrador
 * puede otorgar privilegios (como el de publicar testimonios).
 */
router.post('/:id/roles',
  requiereAuth,
  requierePermiso('gestionar_roles_permisos'),
  requierePin,
  asyncHandler(async (req, res) => {
    const { rol_id } = req.body;
    if (!rol_id) return res.status(400).json({ error: 'Falta el rol a asignar.' });

    try {
      await query(
        'INSERT INTO usuario_roles (usuario_id, rol_id, asignado_por) VALUES (?, ?, ?)',
        [req.params.id, rol_id, req.usuario.id]
      );
      res.status(201).json({ mensaje: 'Rol asignado.' });
    } catch (e) {
      if (e.code === 'ER_DUP_ENTRY') {
        return res.status(409).json({ error: 'Esa persona ya tiene ese rol.' });
      }
      throw e;
    }
  })
);

/** DELETE /api/usuarios/:id/roles/:rolId — quitar un rol */
router.delete('/:id/roles/:rolId',
  requiereAuth,
  requierePermiso('gestionar_roles_permisos'),
  requierePin,
  asyncHandler(async (req, res) => {
    const usuarioId = Number(req.params.id);

    // Protección 1: no quitarte tu propio rol de Administrador.
    if (usuarioId === req.usuario.id) {
      const rol = await query('SELECT nombre FROM roles WHERE id = ?', [req.params.rolId]);
      if (rol.length && rol[0].nombre === 'Administrador') {
        return res.status(400).json({
          error: 'No puedes quitarte a ti mismo el rol de Administrador.',
        });
      }
    }

    // Protección 2: no dejar el sistema sin ningún administrador.
    const rol = await query('SELECT nombre FROM roles WHERE id = ?', [req.params.rolId]);
    if (rol.length && rol[0].nombre === 'Administrador') {
      if ((await contarAdminsActivos()) <= 1) {
        return res.status(400).json({
          error: 'No se puede quitar el último Administrador del sistema.',
        });
      }
    }

    await query(
      'DELETE FROM usuario_roles WHERE usuario_id = ? AND rol_id = ?',
      [usuarioId, req.params.rolId]
    );
    res.json({ mensaje: 'Rol retirado.' });
  })
);

/** PATCH /api/usuarios/:id/estado — activar o desactivar una cuenta */
router.patch('/:id/estado',
  requiereAuth,
  requierePermiso('gestionar_usuarios'),
  requierePin,
  asyncHandler(async (req, res) => {
    const { estado } = req.body;
    const usuarioId = Number(req.params.id);

    if (!['activo', 'inactivo'].includes(estado)) {
      return res.status(400).json({ error: 'Estado no válido. Usa "activo" o "inactivo".' });
    }
    if (usuarioId === req.usuario.id && estado === 'inactivo') {
      return res.status(400).json({ error: 'No puedes desactivar tu propia cuenta.' });
    }
    if (estado === 'inactivo' && await esAdministrador(usuarioId)) {
      if ((await contarAdminsActivos()) <= 1) {
        return res.status(400).json({
          error: 'No se puede desactivar al último Administrador activo.',
        });
      }
    }

    await query('UPDATE usuarios SET estado = ? WHERE id = ?', [estado, usuarioId]);
    res.json({ mensaje: `Cuenta marcada como ${estado}.` });
  })
);

export default router;
