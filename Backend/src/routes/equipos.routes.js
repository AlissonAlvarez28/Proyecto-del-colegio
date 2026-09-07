/**
 * MÓDULO SENSIBLE — Equipos e integrantes.
 *
 * `integrantes_equipo` contiene nombres de estudiantes, muchos menores
 * de edad. El endpoint público SOLO devuelve a quienes tienen
 * mostrar_publicamente = TRUE, y aun así el resto del roster sigue
 * siendo visible para administración.
 *
 * REGLA: nunca hacer SELECT * de esta tabla hacia una respuesta pública.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';

const router = Router();

/** GET /api/equipos — PÚBLICO */
router.get('/', async (req, res, next) => {
  try {
    const filas = await query(
      `SELECT e.id, e.nombre, e.descripcion, e.disciplina_id, e.categoria_id,
              d.nombre AS disciplina, c.nombre AS categoria,
              (SELECT COUNT(*) FROM integrantes_equipo i
               WHERE i.equipo_id = e.id AND i.activo = TRUE) AS total_integrantes
       FROM equipos e
       JOIN disciplinas d            ON d.id = e.disciplina_id
       JOIN categorias_competencia c ON c.id = e.categoria_id
       WHERE e.activo = TRUE
       ORDER BY d.orden, e.nombre`
    );
    res.json({ datos: filas });
  } catch (e) { next(e); }
});

/** POST /api/equipos — crear un equipo (solo gestión) */
router.post('/', requiereAuth, requierePermiso('gestionar_equipos'), requierePin, async (req, res, next) => {
  try {
    const { nombre, disciplina_id, categoria_id } = req.body;
    if (!nombre || !disciplina_id || !categoria_id) {
      return res.status(400).json({ error: 'Nombre, disciplina y categoría son obligatorios.' });
    }
    const r = await query(
      'INSERT INTO equipos (nombre, disciplina_id, categoria_id, descripcion) VALUES (?, ?, ?, ?)',
      [nombre, disciplina_id, categoria_id, req.body.descripcion || null]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Equipo creado.' });
  } catch (e) { next(e); }
});

/** PATCH /api/equipos/:id — editar un equipo (solo gestión) */
router.patch('/:id', requiereAuth, requierePermiso('gestionar_equipos'), requierePin, async (req, res, next) => {
  try {
    const permitidos = ['nombre', 'disciplina_id', 'categoria_id', 'descripcion', 'activo'];
    const campos = [];
    const valores = [];
    for (const c of permitidos) {
      if (req.body[c] !== undefined) { campos.push(`${c} = ?`); valores.push(req.body[c]); }
    }
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE equipos SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Equipo actualizado.' });
  } catch (e) { next(e); }
});

/**
 * DELETE /api/equipos/:id — baja lógica, no borrado real.
 * Se marca inactivo porque hay logros y eventos históricos que apuntan
 * a este equipo: borrarlo de verdad perdería esa historia.
 */
router.delete('/:id', requiereAuth, requierePermiso('gestionar_equipos'), requierePin, async (req, res, next) => {
  try {
    await query('UPDATE equipos SET activo = FALSE WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Equipo dado de baja (su historial se conserva).' });
  } catch (e) { next(e); }
});

/**
 * GET /api/equipos/:id/integrantes — PÚBLICO (filtrado)
 *
 * El conteo total sí se muestra (motiva: "12 jugadoras en plantilla"),
 * pero solo se listan nombres y fotos de quienes lo autorizaron.
 */
router.get('/:id/integrantes', async (req, res, next) => {
  try {
    const publicos = await query(
      `SELECT id, nombre_completo, numero_camisa, posicion, foto_url, grado_seccion
       FROM integrantes_equipo
       WHERE equipo_id = ? AND activo = TRUE AND mostrar_publicamente = TRUE
       ORDER BY numero_camisa IS NULL, numero_camisa`,
      [req.params.id]
    );

    const totales = await query(
      `SELECT COUNT(*) AS total FROM integrantes_equipo
       WHERE equipo_id = ? AND activo = TRUE`,
      [req.params.id]
    );

    res.json({
      datos: publicos,
      total_plantilla: totales[0].total,
      nota: 'Solo se muestran integrantes que autorizaron la publicación de sus datos.',
    });
  } catch (e) { next(e); }
});

/**
 * GET /api/equipos/:id/integrantes/admin — roster COMPLETO.
 * Requiere permiso de gestión de equipos.
 */
router.get('/:id/integrantes/admin',
  requiereAuth,
  requierePermiso('gestionar_equipos'),
  async (req, res, next) => {
    try {
      const filas = await query(
        `SELECT * FROM integrantes_equipo
         WHERE equipo_id = ?
         ORDER BY numero_camisa IS NULL, numero_camisa`,
        [req.params.id]
      );
      res.json({ datos: filas });
    } catch (e) { next(e); }
  }
);

/** POST /api/equipos/:id/integrantes — agregar al roster (solo gestión) */
router.post('/:id/integrantes',
  requiereAuth,
  requierePermiso('gestionar_equipos'),
  requierePin,
  async (req, res, next) => {
    try {
      const { nombre_completo, numero_camisa, posicion, foto_url,
              grado_seccion, mostrar_publicamente } = req.body;

      if (!nombre_completo) {
        return res.status(400).json({ error: 'El nombre del integrante es obligatorio.' });
      }

      const r = await query(
        `INSERT INTO integrantes_equipo
           (equipo_id, nombre_completo, numero_camisa, posicion, foto_url,
            grado_seccion, mostrar_publicamente)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [req.params.id, nombre_completo, numero_camisa || null, posicion || null,
         foto_url || null, grado_seccion || null,
         // Por defecto NO se publica: requiere autorización explícita.
         Boolean(mostrar_publicamente)]
      );

      res.status(201).json({ id: r.insertId, mensaje: 'Integrante agregado al equipo.' });
    } catch (e) {
      if (e.code === 'ER_DUP_ENTRY') {
        return res.status(409).json({ error: 'Ya existe un integrante con ese número en este equipo.' });
      }
      next(e);
    }
  }
);

/** PATCH /api/equipos/:equipoId/integrantes/:id — incluye el interruptor de visibilidad */
router.patch('/:equipoId/integrantes/:id',
  requiereAuth,
  requierePermiso('gestionar_equipos'),
  requierePin,
  async (req, res, next) => {
    try {
      const permitidos = ['nombre_completo','numero_camisa','posicion','foto_url',
                          'grado_seccion','mostrar_publicamente','activo'];
      const campos = [];
      const params = [];

      for (const c of permitidos) {
        if (req.body[c] !== undefined) { campos.push(`${c} = ?`); params.push(req.body[c]); }
      }
      if (campos.length === 0) {
        return res.status(400).json({ error: 'No se envió ningún campo para actualizar.' });
      }

      params.push(req.params.id, req.params.equipoId);
      await query(
        `UPDATE integrantes_equipo SET ${campos.join(', ')} WHERE id = ? AND equipo_id = ?`,
        params
      );
      res.json({ mensaje: 'Integrante actualizado.' });
    } catch (e) { next(e); }
  }
);

export default router;
