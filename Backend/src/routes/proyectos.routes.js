/**
 * Proyectos futuros / peticiones de mejora de instalaciones.
 *
 * Regla de negocio central (ETAPA C):
 *  - El sitio público SOLO muestra los estados aprobado / en_gestion / completado.
 *  - Las peticiones sin revisar (pendiente, en_revision) y las rechazadas
 *    son visibles únicamente en el panel administrativo.
 *
 * Es la única escritura pública sin cuenta, junto con nada más: cualquier
 * alumno o padre puede enviar una petición, pero no se publica sola.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';
import { asyncHandler } from '../utils/crud.js';

const router = Router();

const ESTADOS_PUBLICOS = ['aprobado', 'en_gestion', 'completado'];

/** GET /api/proyectos-futuros — PÚBLICO (solo lo aprobado) */
router.get('/', asyncHandler(async (_req, res) => {
  const filas = await query(
    `SELECT id, titulo, descripcion, estado, created_at
     FROM proyectos_futuros
     WHERE estado IN (?, ?, ?)
     ORDER BY FIELD(estado,'en_gestion','aprobado','completado'), id`,
    ESTADOS_PUBLICOS
  );
  res.json({ datos: filas });
}));

/** GET /api/proyectos-futuros/admin — TODAS, incluidas las peticiones sin revisar */
router.get('/admin',
  requiereAuth,
  requierePermiso('gestionar_proyectos_futuros'),
  asyncHandler(async (req, res) => {
    const condiciones = [];
    const params = [];
    if (req.query.estado) {
      condiciones.push('p.estado = ?');
      params.push(req.query.estado);
    }
    const where = condiciones.length ? `WHERE ${condiciones.join(' AND ')}` : '';

    const filas = await query(
      `SELECT p.*, u.nombre_completo AS revisor
       FROM proyectos_futuros p
       LEFT JOIN usuarios u ON u.id = p.revisado_por
       ${where}
       ORDER BY FIELD(p.estado,'pendiente','en_revision','aprobado','en_gestion','completado','rechazado'),
                p.created_at DESC`,
      params
    );
    res.json({ datos: filas });
  })
);

/**
 * POST /api/proyectos-futuros — PÚBLICO, sin cuenta.
 * Cualquiera de la comunidad puede enviar una petición de mejora.
 * Nace en estado 'pendiente': no aparece en el sitio hasta que se apruebe.
 */
router.post('/', asyncHandler(async (req, res) => {
  const { titulo, descripcion, solicitante_nombre, solicitante_rol } = req.body;

  if (!titulo || !descripcion) {
    return res.status(400).json({ error: 'Título y descripción son obligatorios.' });
  }
  if (descripcion.trim().length < 15) {
    return res.status(400).json({ error: 'Describe un poco más tu propuesta.' });
  }

  const r = await query(
    `INSERT INTO proyectos_futuros
       (titulo, descripcion, origen, solicitante_nombre, solicitante_rol, estado)
     VALUES (?, ?, 'peticion_comunidad', ?, ?, 'pendiente')`,
    [titulo.trim(), descripcion.trim(), solicitante_nombre || null, solicitante_rol || null]
  );

  res.status(201).json({
    id: r.insertId,
    mensaje: 'Tu propuesta fue enviada. La administración la revisará.',
  });
}));

/** POST /api/proyectos-futuros/admin — iniciativa institucional (ya aprobada) */
router.post('/admin',
  requiereAuth,
  requierePermiso('gestionar_proyectos_futuros'),
  requierePin,
  asyncHandler(async (req, res) => {
    const { titulo, descripcion } = req.body;
    if (!titulo || !descripcion) {
      return res.status(400).json({ error: 'Título y descripción son obligatorios.' });
    }
    const r = await query(
      `INSERT INTO proyectos_futuros (titulo, descripcion, origen, estado, revisado_por, fecha_revision)
       VALUES (?, ?, 'iniciativa_admin', ?, ?, NOW())`,
      [titulo, descripcion, req.body.estado || 'aprobado', req.usuario.id]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Proyecto institucional creado.' });
  })
);

/** PATCH /api/proyectos-futuros/:id — revisar, aprobar, rechazar o responder */
router.patch('/:id',
  requiereAuth,
  requierePermiso('gestionar_proyectos_futuros'),
  requierePin,
  asyncHandler(async (req, res) => {
    const validos = ['pendiente', 'en_revision', 'aprobado', 'en_gestion', 'completado', 'rechazado'];
    const { estado, respuesta_admin } = req.body;

    if (estado && !validos.includes(estado)) {
      return res.status(400).json({ error: 'Estado no válido.' });
    }

    const campos = [];
    const valores = [];
    if (estado) { campos.push('estado = ?'); valores.push(estado); }
    if (respuesta_admin !== undefined) { campos.push('respuesta_admin = ?'); valores.push(respuesta_admin); }
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });

    campos.push('revisado_por = ?', 'fecha_revision = NOW()');
    valores.push(req.usuario.id, req.params.id);

    await query(`UPDATE proyectos_futuros SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Propuesta actualizada.' });
  })
);

/** DELETE /api/proyectos-futuros/:id */
router.delete('/:id',
  requiereAuth,
  requierePermiso('gestionar_proyectos_futuros'),
  requierePin,
  asyncHandler(async (req, res) => {
    await query('DELETE FROM proyectos_futuros WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Propuesta eliminada.' });
  })
);

export default router;
