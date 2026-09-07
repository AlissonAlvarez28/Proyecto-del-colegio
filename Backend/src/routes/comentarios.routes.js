/**
 * MÓDULO SENSIBLE — Comentarios.
 *
 * Requieren cuenta (decisión tomada: esta es la cara de la institución,
 * no se permiten comentarios de cualquiera sin identificar).
 *
 * Mismo modelo de anonimato que testimonios:
 *  - Público: si es_anonimo = TRUE, ve `descriptor_publico`, nunca el nombre.
 *  - Administración/docentes: siempre ven la identidad real.
 * El anonimato protege al autor ante el público, no lo vuelve irrastreable.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';
import { asyncHandler } from '../utils/crud.js';

const router = Router();

/** GET /api/publicaciones/:id/comentarios — PÚBLICO (identidad protegida) */
router.get('/publicaciones/:id/comentarios', asyncHandler(async (req, res) => {
  const filas = await query(
    `SELECT c.id, c.mensaje, c.rol_mostrado, c.es_anonimo, c.created_at,
            CASE WHEN c.es_anonimo = TRUE
                 THEN c.descriptor_publico
                 ELSE u.nombre_completo
            END AS autor
     FROM comentarios c
     JOIN usuarios u ON u.id = c.usuario_id
     WHERE c.publicacion_id = ? AND c.estado = 'visible'
     ORDER BY c.created_at DESC`,
    [req.params.id]
  );
  res.json({ datos: filas });
}));

/**
 * GET /api/comentarios/admin — moderación.
 * Aquí SÍ se expone la identidad real, incluso de los anónimos.
 */
router.get('/comentarios/admin',
  requiereAuth,
  requierePermiso('moderar_comentarios'),
  asyncHandler(async (_req, res) => {
    const filas = await query(
      `SELECT c.*, u.nombre_completo AS autor_real, u.correo AS autor_correo,
              p.titulo AS publicacion
       FROM comentarios c
       JOIN usuarios u      ON u.id = c.usuario_id
       JOIN publicaciones p ON p.id = c.publicacion_id
       ORDER BY c.created_at DESC`
    );
    res.json({ datos: filas });
  })
);

/** POST /api/publicaciones/:id/comentarios — requiere sesión */
router.post('/publicaciones/:id/comentarios',
  requiereAuth,
  asyncHandler(async (req, res) => {
    const { mensaje, rol_mostrado, es_anonimo, descriptor_publico } = req.body;

    if (!mensaje || mensaje.trim().length < 3) {
      return res.status(400).json({ error: 'El comentario está vacío o es demasiado corto.' });
    }
    // Refuerza en la API la misma regla que el CHECK de la base de datos.
    if (es_anonimo && !descriptor_publico) {
      return res.status(400).json({
        error: 'Si comentas de forma anónima, indica cómo quieres aparecer (ej. "Padre de familia").',
      });
    }

    const pub = await query(
      "SELECT id FROM publicaciones WHERE id = ? AND estado = 'publicado'",
      [req.params.id]
    );
    if (pub.length === 0) {
      return res.status(404).json({ error: 'La publicación no existe o no está publicada.' });
    }

    const r = await query(
      `INSERT INTO comentarios
         (publicacion_id, usuario_id, mensaje, rol_mostrado, es_anonimo, descriptor_publico)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [req.params.id, req.usuario.id, mensaje.trim(), rol_mostrado || null,
       Boolean(es_anonimo), descriptor_publico || null]
    );

    res.status(201).json({ id: r.insertId, mensaje: 'Comentario publicado.' });
  })
);

/** PATCH /api/comentarios/:id/estado — ocultar o mostrar (moderación) */
router.patch('/comentarios/:id/estado',
  requiereAuth,
  requierePermiso('moderar_comentarios'),
  requierePin,
  asyncHandler(async (req, res) => {
    const { estado } = req.body;
    if (!['visible', 'oculto'].includes(estado)) {
      return res.status(400).json({ error: 'Estado no válido. Usa "visible" u "oculto".' });
    }
    await query(
      'UPDATE comentarios SET estado = ?, moderado_por = ? WHERE id = ?',
      [estado, req.usuario.id, req.params.id]
    );
    res.json({ mensaje: `Comentario marcado como ${estado}.` });
  })
);

/** DELETE /api/comentarios/:id — solo moderadores */
router.delete('/comentarios/:id',
  requiereAuth,
  requierePermiso('moderar_comentarios'),
  requierePin,
  asyncHandler(async (req, res) => {
    await query('DELETE FROM comentarios WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Comentario eliminado.' });
  })
);

export default router;
