/**
 * Publicaciones (noticias y artículos del blog).
 * Unifica el contenido que hoy está duplicado entre inicio.html y Blog.html.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin, requierePropiedad } from '../middleware/auth.js';
import { construirUpdate, asyncHandler, paginacion } from '../utils/crud.js';

const router = Router();

const CAMPOS = ['titulo', 'resumen', 'contenido', 'imagen_portada',
                'autor_id', 'estado', 'destacado', 'fecha_publicacion'];

/**
 * GET /api/publicaciones — PÚBLICO
 * Solo devuelve publicadas. ?destacado=true para el resumen de inicio.html
 */
router.get('/', asyncHandler(async (req, res) => {
  const { limite, offset, pagina } = paginacion(req, 10);
  const condiciones = ["p.estado = 'publicado'"];
  const params = [];

  if (req.query.destacado === 'true') condiciones.push('p.destacado = TRUE');

  const filas = await query(
    `SELECT p.id, p.titulo, p.resumen, p.imagen_portada, p.fecha_publicacion,
            p.destacado, per.nombre_completo AS autor,
            (SELECT COUNT(*) FROM comentarios c
             WHERE c.publicacion_id = p.id AND c.estado = 'visible') AS total_comentarios
     FROM publicaciones p
     LEFT JOIN personal per ON per.id = p.autor_id
     WHERE ${condiciones.join(' AND ')}
     ORDER BY p.fecha_publicacion DESC, p.id DESC
     LIMIT ? OFFSET ?`,
    [...params, limite, offset]
  );

  res.json({ datos: filas, pagina, limite });
}));

/** GET /api/publicaciones/admin — incluye borradores (requiere sesión) */
router.get('/admin',
  requiereAuth,
  requierePermiso('crear_publicacion'),
  asyncHandler(async (_req, res) => {
    const filas = await query(
      `SELECT p.*, per.nombre_completo AS autor
       FROM publicaciones p
       LEFT JOIN personal per ON per.id = p.autor_id
       ORDER BY p.created_at DESC`
    );
    res.json({ datos: filas });
  })
);

/** GET /api/publicaciones/:id — PÚBLICO (solo si está publicada) */
router.get('/:id', asyncHandler(async (req, res) => {
  const filas = await query(
    `SELECT p.*, per.nombre_completo AS autor
     FROM publicaciones p
     LEFT JOIN personal per ON per.id = p.autor_id
     WHERE p.id = ? AND p.estado = 'publicado'`,
    [req.params.id]
  );
  if (filas.length === 0) return res.status(404).json({ error: 'Publicación no encontrada.' });
  res.json(filas[0]);
}));

/** POST /api/publicaciones */
router.post('/',
  requiereAuth,
  requierePermiso('crear_publicacion'),
  requierePin,
  asyncHandler(async (req, res) => {
    const { titulo, contenido } = req.body;
    if (!titulo || !contenido) {
      return res.status(400).json({ error: 'Título y contenido son obligatorios.' });
    }

    const r = await query(
      `INSERT INTO publicaciones
         (titulo, resumen, contenido, imagen_portada, autor_id, estado, destacado, fecha_publicacion, creado_por)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [titulo, req.body.resumen || null, contenido, req.body.imagen_portada || null,
       req.body.autor_id || null, req.body.estado || 'borrador',
       Boolean(req.body.destacado),
       req.body.estado === 'publicado' ? new Date() : null,
       req.usuario.id]
    );

    res.status(201).json({ id: r.insertId, mensaje: 'Publicación creada.' });
  })
);

/** PATCH /api/publicaciones/:id */
router.patch('/:id',
  requiereAuth,
  requierePermiso('editar_publicacion'),
  requierePin,
  asyncHandler(async (req, res) => {
    // Al pasar a "publicado" por primera vez, se sella la fecha de publicación.
    if (req.body.estado === 'publicado' && req.body.fecha_publicacion === undefined) {
      const actual = await query('SELECT fecha_publicacion FROM publicaciones WHERE id = ?', [req.params.id]);
      if (actual.length && !actual[0].fecha_publicacion) {
        req.body.fecha_publicacion = new Date();
      }
    }

    const { campos, valores } = construirUpdate(req.body, CAMPOS);
    if (campos.length === 0) {
      return res.status(400).json({ error: 'No se envió ningún campo para actualizar.' });
    }
    valores.push(req.params.id);
    await query(`UPDATE publicaciones SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Publicación actualizada.' });
  })
);

/** DELETE /api/publicaciones/:id — un Colaborador solo borra las propias */
router.delete('/:id',
  requiereAuth,
  requierePermiso('crear_publicacion'),
  requierePin,
  requierePropiedad('publicaciones'),
  asyncHandler(async (req, res) => {
    await query('DELETE FROM publicaciones WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Publicación eliminada.' });
  })
);

export default router;
