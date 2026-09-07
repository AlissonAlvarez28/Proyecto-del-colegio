/**
 * Contenido deportivo: disciplinas, hitos históricos, logros
 * y las estadísticas de la página de deportes.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin, requierePropiedad } from '../middleware/auth.js';
import { construirUpdate, asyncHandler } from '../utils/crud.js';

const router = Router();

/* ==================== CATEGORÍAS DE COMPETENCIA ==================== */

router.get('/categorias-competencia', asyncHandler(async (_req, res) => {
  const filas = await query('SELECT id, nombre FROM categorias_competencia ORDER BY id');
  res.json({ datos: filas });
}));

router.post('/categorias-competencia',
  requiereAuth, requierePermiso('gestionar_equipos'), requierePin,
  asyncHandler(async (req, res) => {
    if (!req.body.nombre) return res.status(400).json({ error: 'El nombre es obligatorio.' });
    const r = await query('INSERT INTO categorias_competencia (nombre) VALUES (?)', [req.body.nombre]);
    res.status(201).json({ id: r.insertId, mensaje: 'Categoría creada.' });
  })
);

/* ==================== DISCIPLINAS ==================== */

router.get('/disciplinas', asyncHandler(async (_req, res) => {
  const filas = await query(
    `SELECT d.id, d.nombre, d.descripcion, d.icono, d.orden,
            (SELECT COUNT(*) FROM equipos e WHERE e.disciplina_id = d.id AND e.activo = TRUE) AS total_equipos
     FROM disciplinas d ORDER BY d.orden, d.id`
  );
  res.json({ datos: filas });
}));

router.post('/disciplinas',
  requiereAuth, requierePermiso('gestionar_equipos'), requierePin,
  asyncHandler(async (req, res) => {
    if (!req.body.nombre) return res.status(400).json({ error: 'El nombre es obligatorio.' });
    const r = await query(
      'INSERT INTO disciplinas (nombre, descripcion, icono, orden) VALUES (?, ?, ?, ?)',
      [req.body.nombre, req.body.descripcion || null, req.body.icono || null, req.body.orden || 0]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Disciplina creada.' });
  })
);

router.patch('/disciplinas/:id',
  requiereAuth, requierePermiso('gestionar_equipos'), requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body, ['nombre', 'descripcion', 'icono', 'orden']);
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE disciplinas SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Disciplina actualizada.' });
  })
);

/* ==================== HITOS HISTÓRICOS ==================== */

router.get('/hitos-historicos', asyncHandler(async (_req, res) => {
  const filas = await query(
    `SELECT id, anio_periodo, titulo, descripcion, imagen_url, orden
     FROM hitos_historicos ORDER BY orden, id`
  );
  res.json({ datos: filas });
}));

router.post('/hitos-historicos',
  requiereAuth, requierePermiso('crear_hito_historico'), requierePin,
  asyncHandler(async (req, res) => {
    const { anio_periodo, titulo, descripcion } = req.body;
    if (!anio_periodo || !titulo || !descripcion) {
      return res.status(400).json({ error: 'Año/período, título y descripción son obligatorios.' });
    }
    const r = await query(
      `INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, imagen_url, orden, creado_por)
       VALUES (?, ?, ?, ?, ?, ?)`,
      [anio_periodo, titulo, descripcion, req.body.imagen_url || null,
       req.body.orden || 0, req.usuario.id]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Hito agregado a la línea de tiempo.' });
  })
);

router.patch('/hitos-historicos/:id',
  requiereAuth, requierePermiso('crear_hito_historico'), requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body,
      ['anio_periodo', 'titulo', 'descripcion', 'imagen_url', 'orden']);
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE hitos_historicos SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Hito actualizado.' });
  })
);

router.delete('/hitos-historicos/:id',
  requiereAuth, requierePermiso('crear_hito_historico'), requierePin,
  requierePropiedad('hitos_historicos'),
  asyncHandler(async (req, res) => {
    await query('DELETE FROM hitos_historicos WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Hito eliminado.' });
  })
);

/* ==================== LOGROS ==================== */

router.get('/logros', asyncHandler(async (req, res) => {
  const condiciones = [];
  const params = [];
  if (req.query.disciplina) {
    condiciones.push('l.disciplina_id = ?');
    params.push(Number(req.query.disciplina));
  }
  const where = condiciones.length ? `WHERE ${condiciones.join(' AND ')}` : '';

  const filas = await query(
    `SELECT l.id, l.titulo, l.descripcion, l.anio, l.etiqueta,
            l.disciplina_id, l.equipo_id,
            d.nombre AS disciplina, e.nombre AS equipo
     FROM logros l
     LEFT JOIN disciplinas d ON d.id = l.disciplina_id
     LEFT JOIN equipos e     ON e.id = l.equipo_id
     ${where}
     ORDER BY l.anio DESC, l.id DESC`,
    params
  );
  res.json({ datos: filas });
}));

router.post('/logros',
  requiereAuth, requierePermiso('crear_logro'), requierePin,
  asyncHandler(async (req, res) => {
    const { titulo, descripcion, anio } = req.body;
    if (!titulo || !descripcion || !anio) {
      return res.status(400).json({ error: 'Título, descripción y año son obligatorios.' });
    }
    const r = await query(
      `INSERT INTO logros (titulo, descripcion, anio, etiqueta, disciplina_id, equipo_id, creado_por)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [titulo, descripcion, anio, req.body.etiqueta || null,
       req.body.disciplina_id || null, req.body.equipo_id || null, req.usuario.id]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Logro registrado.' });
  })
);

router.patch('/logros/:id',
  requiereAuth, requierePermiso('crear_logro'), requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body,
      ['titulo', 'descripcion', 'anio', 'etiqueta', 'disciplina_id', 'equipo_id']);
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE logros SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Logro actualizado.' });
  })
);

router.delete('/logros/:id',
  requiereAuth, requierePermiso('crear_logro'), requierePin,
  requierePropiedad('logros'),
  asyncHandler(async (req, res) => {
    await query('DELETE FROM logros WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Logro eliminado.' });
  })
);

/* ==================== ESTADÍSTICAS ==================== */

/**
 * GET /api/estadisticas-deportivas — PÚBLICO
 *
 * Decisión de diseño (ver ETAPA A, punto 6): las cifras que SÍ corresponden
 * a registros reales se CALCULAN con COUNT en vez de guardarse, para que
 * nunca queden desactualizadas. Las que no tienen registro individual en el
 * sistema (ej. "~200 estudiantes en actividad deportiva", que no se lleva
 * persona por persona) se leen de configuracion_institucional, donde un
 * administrador puede editarlas a mano.
 */
router.get('/estadisticas-deportivas', asyncHandler(async (_req, res) => {
  const [disciplinas] = await query('SELECT COUNT(*) AS n FROM disciplinas');
  const [equipos] = await query('SELECT COUNT(*) AS n FROM equipos WHERE activo = TRUE');
  const [logros] = await query('SELECT COUNT(*) AS n FROM logros');
  const [eventos] = await query('SELECT COUNT(*) AS n FROM eventos_deportivos');

  const manuales = await query(
    `SELECT clave, valor FROM configuracion_institucional
     WHERE clave IN ('anios_compitiendo','estudiantes_en_deporte','estudiantes_en_selecciones','competencias_formales')`
  );
  const config = Object.fromEntries(manuales.map((m) => [m.clave, m.valor]));

  res.json({
    calculadas: {
      disciplinas: disciplinas.n,
      equipos: equipos.n,
      logros: logros.n,
      eventos_registrados: eventos.n,
    },
    manuales: {
      anios_compitiendo: config.anios_compitiendo ?? null,
      estudiantes_en_deporte: config.estudiantes_en_deporte ?? null,
      estudiantes_en_selecciones: config.estudiantes_en_selecciones ?? null,
      competencias_formales: config.competencias_formales ?? null,
    },
  });
}));

export default router;

