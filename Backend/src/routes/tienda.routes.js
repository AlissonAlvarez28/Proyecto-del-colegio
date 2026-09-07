/**
 * Tienda escolar (productos) y configuración institucional.
 *
 * Nota de alcance (ETAPA A, punto 7): no existe entidad "pedido".
 * La tienda muestra el catálogo real desde la base de datos; el proceso
 * de compra sigue siendo presencial en la institución.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';
import { construirUpdate, asyncHandler } from '../utils/crud.js';

const router = Router();

/* ==================== PRODUCTOS ==================== */

/** GET /api/productos — PÚBLICO */
router.get('/productos', asyncHandler(async (req, res) => {
  const soloDisponibles = req.query.todos !== 'true';
  const filas = await query(
    `SELECT id, nombre, precio, descripcion, foto_url, disponible
     FROM productos ${soloDisponibles ? 'WHERE disponible = TRUE' : ''}
     ORDER BY nombre`
  );
  res.json({ datos: filas });
}));

router.post('/productos',
  requiereAuth, requierePermiso('gestionar_productos'), requierePin,
  asyncHandler(async (req, res) => {
    const { nombre, precio } = req.body;
    if (!nombre || precio === undefined) {
      return res.status(400).json({ error: 'Nombre y precio son obligatorios.' });
    }
    if (Number(precio) < 0) {
      return res.status(400).json({ error: 'El precio no puede ser negativo.' });
    }
    const r = await query(
      'INSERT INTO productos (nombre, precio, descripcion, foto_url) VALUES (?, ?, ?, ?)',
      [nombre, precio, req.body.descripcion || null, req.body.foto_url || null]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Producto agregado.' });
  })
);

router.patch('/productos/:id',
  requiereAuth, requierePermiso('gestionar_productos'), requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body,
      ['nombre', 'precio', 'descripcion', 'foto_url', 'disponible']);
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE productos SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Producto actualizado.' });
  })
);

router.delete('/productos/:id',
  requiereAuth, requierePermiso('gestionar_productos'), requierePin,
  asyncHandler(async (req, res) => {
    await query('DELETE FROM productos WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Producto eliminado.' });
  })
);

/* ==================== CONFIGURACIÓN INSTITUCIONAL ==================== */

/**
 * GET /api/configuracion — PÚBLICO
 * Datos de contacto, redes sociales y cifras editables a mano.
 * Se devuelve como objeto clave-valor para que el frontend lo use directo.
 */
router.get('/configuracion', asyncHandler(async (_req, res) => {
  const filas = await query('SELECT clave, valor FROM configuracion_institucional');
  res.json(Object.fromEntries(filas.map((f) => [f.clave, f.valor])));
}));

/**
 * PUT /api/configuracion/:clave — solo Admin
 * Crea la clave si no existe, o actualiza su valor si ya está.
 */
router.put('/configuracion/:clave',
  requiereAuth, requierePermiso('gestionar_roles_permisos'), requierePin,
  asyncHandler(async (req, res) => {
    const { valor, descripcion } = req.body;
    if (valor === undefined) return res.status(400).json({ error: 'Falta el valor.' });

    await query(
      `INSERT INTO configuracion_institucional (clave, valor, descripcion)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE valor = VALUES(valor)`,
      [req.params.clave, valor, descripcion || null]
    );
    res.json({ mensaje: 'Configuración guardada.' });
  })
);

export default router;
