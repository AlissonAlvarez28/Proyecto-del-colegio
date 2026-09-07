/**
 * MÓDULO SENSIBLE — Testimonios.
 *
 * Regla central: el anonimato es SOLO ante el público.
 *  - Endpoint público: si es_anonimo = TRUE devuelve descriptor_publico
 *    y NUNCA el nombre real ni el usuario_id.
 *  - Endpoint administrativo: devuelve siempre la identidad real, para
 *    que administración y docentes puedan rastrear quién escribió qué.
 *
 * El mismo patrón aplica a comentarios.routes.js.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';

const router = Router();

/**
 * GET /api/testimonios — PÚBLICO
 * Solo publicados. La identidad real jamás sale de esta consulta:
 * el SELECT ni siquiera trae u.nombre_completo cuando es anónimo.
 */
router.get('/', async (req, res, next) => {
  try {
    const filas = await query(
      `SELECT t.id, t.cita, t.rol_mostrado, t.es_anonimo, t.created_at,
              CASE WHEN t.es_anonimo = TRUE
                   THEN t.descriptor_publico
                   ELSE u.nombre_completo
              END AS autor,
              d.nombre AS disciplina
       FROM testimonios t
       JOIN usuarios u        ON u.id = t.usuario_id
       LEFT JOIN disciplinas d ON d.id = t.disciplina_id
       WHERE t.estado = 'publicado'
       ORDER BY t.created_at DESC`
    );
    res.json({ datos: filas });
  } catch (e) { next(e); }
});

/**
 * GET /api/testimonios/admin — solo con permiso de moderación.
 * Aquí SÍ se expone la identidad real, incluso de los anónimos.
 */
router.get('/admin',
  requiereAuth,
  requierePermiso('moderar_testimonio'),
  async (req, res, next) => {
    try {
      const filas = await query(
        `SELECT t.*, u.nombre_completo AS autor_real, u.correo AS autor_correo
         FROM testimonios t
         JOIN usuarios u ON u.id = t.usuario_id
         ORDER BY FIELD(t.estado,'pendiente','publicado','rechazado'), t.created_at DESC`
      );
      res.json({ datos: filas });
    } catch (e) { next(e); }
  }
);

/**
 * POST /api/testimonios — requiere cuenta + permiso otorgado por un admin.
 * Nace en estado 'pendiente': nada se publica sin revisión.
 */
router.post('/',
  requiereAuth,
  requierePermiso('crear_testimonio'),
  requierePin,
  async (req, res, next) => {
    try {
      const { cita, rol_mostrado, es_anonimo, descriptor_publico, disciplina_id } = req.body;

      if (!cita || cita.trim().length < 10) {
        return res.status(400).json({ error: 'El testimonio es demasiado corto.' });
      }
      // Refuerza en la API la misma regla que el CHECK de la base de datos.
      if (es_anonimo && !descriptor_publico) {
        return res.status(400).json({
          error: 'Si publicas de forma anónima, indica cómo quieres aparecer (ej. "Estudiante del equipo femenino").',
        });
      }

      const r = await query(
        `INSERT INTO testimonios
           (usuario_id, cita, rol_mostrado, es_anonimo, descriptor_publico, disciplina_id, estado)
         VALUES (?, ?, ?, ?, ?, ?, 'pendiente')`,
        [req.usuario.id, cita.trim(), rol_mostrado || null,
         Boolean(es_anonimo), descriptor_publico || null, disciplina_id || null]
      );

      res.status(201).json({
        id: r.insertId,
        mensaje: 'Testimonio enviado. Un administrador lo revisará antes de publicarlo.',
      });
    } catch (e) { next(e); }
  }
);

/** PATCH /api/testimonios/:id/estado — aprobar o rechazar (solo moderadores) */
router.patch('/:id/estado',
  requiereAuth,
  requierePermiso('moderar_testimonio'),
  requierePin,
  async (req, res, next) => {
    try {
      const { estado } = req.body;
      if (!['publicado', 'rechazado', 'pendiente'].includes(estado)) {
        return res.status(400).json({ error: 'Estado no válido.' });
      }
      await query(
        `UPDATE testimonios
         SET estado = ?, revisado_por = ?, fecha_revision = NOW()
         WHERE id = ?`,
        [estado, req.usuario.id, req.params.id]
      );
      res.json({ mensaje: `Testimonio marcado como ${estado}.` });
    } catch (e) { next(e); }
  }
);

export default router;
