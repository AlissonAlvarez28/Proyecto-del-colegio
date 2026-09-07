/**
 * Académico: carreras, secciones y horarios.
 * Reemplaza los datos quemados de oferta_academica.html y estudiantes.html.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';
import { construirUpdate, asyncHandler } from '../utils/crud.js';

const router = Router();

/* ==================== CARRERAS ==================== */

/** GET /api/carreras — PÚBLICO (con sus secciones, para el modal de inscripción) */
router.get('/carreras', asyncHandler(async (_req, res) => {
  const carreras = await query(
    `SELECT id, nombre, tipo, descripcion, icono FROM carreras
     WHERE activa = TRUE ORDER BY tipo DESC, id`
  );

  const secciones = await query(
    `SELECT id, carrera_id, nombre, jornada, modalidad, cupo_maximo
     FROM secciones_academicas WHERE activa = TRUE ORDER BY carrera_id, nombre`
  );

  // Se anidan las secciones dentro de cada carrera para que el frontend
  // pueda llenar el <select> de una sola llamada.
  const datos = carreras.map((c) => ({
    ...c,
    secciones: secciones.filter((s) => s.carrera_id === c.id),
  }));

  res.json({ datos });
}));

router.post('/carreras',
  requiereAuth, requierePermiso('gestionar_academico'), requierePin,
  asyncHandler(async (req, res) => {
    const { nombre, tipo } = req.body;
    if (!nombre || !['basica', 'tecnica'].includes(tipo)) {
      return res.status(400).json({ error: 'Nombre y tipo (basica/tecnica) son obligatorios.' });
    }
    const r = await query(
      'INSERT INTO carreras (nombre, tipo, descripcion, icono) VALUES (?, ?, ?, ?)',
      [nombre, tipo, req.body.descripcion || null, req.body.icono || null]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Carrera creada.' });
  })
);

router.patch('/carreras/:id',
  requiereAuth, requierePermiso('gestionar_academico'), requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body, ['nombre', 'tipo', 'descripcion', 'icono', 'activa']);
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE carreras SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Carrera actualizada.' });
  })
);

/**
 * DELETE /api/carreras/:id — baja lógica.
 * No se borra de verdad porque tiene secciones y horarios colgando;
 * se marca inactiva y deja de aparecer en el sitio público.
 */
router.delete('/carreras/:id',
  requiereAuth, requierePermiso('gestionar_academico'), requierePin,
  asyncHandler(async (req, res) => {
    await query('UPDATE carreras SET activa = FALSE WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Carrera desactivada (sus secciones y horarios se conservan).' });
  })
);

/* ==================== SECCIONES ==================== */

/** GET /api/secciones — PÚBLICO (lista para el selector de horarios) */
router.get('/secciones', asyncHandler(async (_req, res) => {
  const filas = await query(
    `SELECT s.id, s.nombre, s.jornada, s.modalidad, c.nombre AS carrera
     FROM secciones_academicas s
     JOIN carreras c ON c.id = s.carrera_id
     WHERE s.activa = TRUE ORDER BY c.id, s.nombre`
  );
  res.json({ datos: filas });
}));

router.post('/secciones',
  requiereAuth, requierePermiso('gestionar_academico'), requierePin,
  asyncHandler(async (req, res) => {
    const { carrera_id, nombre, jornada } = req.body;
    if (!carrera_id || !nombre || !['matutina', 'vespertina'].includes(jornada)) {
      return res.status(400).json({ error: 'Carrera, nombre y jornada son obligatorios.' });
    }
    try {
      const r = await query(
        'INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad, cupo_maximo) VALUES (?, ?, ?, ?, ?)',
        [carrera_id, nombre, jornada, req.body.modalidad || null, req.body.cupo_maximo || null]
      );
      res.status(201).json({ id: r.insertId, mensaje: 'Sección creada.' });
    } catch (e) {
      if (e.code === 'ER_DUP_ENTRY') {
        return res.status(409).json({ error: 'Ya existe esa sección con la misma jornada en esta carrera.' });
      }
      throw e;
    }
  })
);

/* ==================== HORARIOS ==================== */

/**
 * GET /api/secciones/:id/horarios — PÚBLICO
 * Devuelve el horario ya agrupado por franja, listo para pintar la tabla
 * de estudiantes.html sin que el frontend tenga que reorganizar nada.
 */
router.get('/secciones/:id/horarios', asyncHandler(async (req, res) => {
  const seccion = await query(
    `SELECT s.id, s.nombre, s.jornada, s.modalidad, c.nombre AS carrera
     FROM secciones_academicas s
     JOIN carreras c ON c.id = s.carrera_id
     WHERE s.id = ?`,
    [req.params.id]
  );
  if (seccion.length === 0) return res.status(404).json({ error: 'Sección no encontrada.' });

  const filas = await query(
    `SELECT id, dia, TIME_FORMAT(hora_inicio, '%H:%i') AS hora_inicio,
            TIME_FORMAT(hora_fin, '%H:%i') AS hora_fin, materia
     FROM horarios WHERE seccion_id = ?
     ORDER BY hora_inicio, FIELD(dia,'lunes','martes','miercoles','jueves','viernes')`,
    [req.params.id]
  );

  const franjas = {};
  for (const f of filas) {
    const clave = `${f.hora_inicio} - ${f.hora_fin}`;
    if (!franjas[clave]) franjas[clave] = { hora: clave };
    franjas[clave][f.dia] = f.materia;
  }

  res.json({ seccion: seccion[0], horario: Object.values(franjas) });
}));

router.post('/secciones/:id/horarios',
  requiereAuth, requierePermiso('gestionar_academico'), requierePin,
  asyncHandler(async (req, res) => {
    const { dia, hora_inicio, hora_fin, materia } = req.body;
    if (!dia || !hora_inicio || !hora_fin || !materia) {
      return res.status(400).json({ error: 'Día, hora de inicio, hora de fin y materia son obligatorios.' });
    }
    try {
      const r = await query(
        'INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (?, ?, ?, ?, ?)',
        [req.params.id, dia, hora_inicio, hora_fin, materia]
      );
      res.status(201).json({ id: r.insertId, mensaje: 'Franja horaria agregada.' });
    } catch (e) {
      if (e.code === 'ER_DUP_ENTRY') {
        return res.status(409).json({ error: 'Ya hay una materia registrada en esa franja para esta sección.' });
      }
      if (e.code === 'ER_CHECK_CONSTRAINT_VIOLATED') {
        return res.status(400).json({ error: 'La hora de fin debe ser posterior a la de inicio.' });
      }
      throw e;
    }
  })
);

router.patch('/horarios/:id',
  requiereAuth, requierePermiso('gestionar_academico'), requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body, ['dia', 'hora_inicio', 'hora_fin', 'materia']);
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE horarios SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Franja actualizada.' });
  })
);

router.delete('/horarios/:id',
  requiereAuth, requierePermiso('gestionar_academico'), requierePin,
  asyncHandler(async (req, res) => {
    await query('DELETE FROM horarios WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Franja eliminada.' });
  })
);

export default router;
