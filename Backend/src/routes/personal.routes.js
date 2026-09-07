/**
 * Personal (directorio de autoridades y docentes).
 * Reemplaza el array quemado en personal.html.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import { requiereAuth, requierePermiso, requierePin } from '../middleware/auth.js';
import { construirUpdate, asyncHandler } from '../utils/crud.js';

const router = Router();

const CAMPOS = ['nombre_completo', 'cargo', 'departamento_id', 'biografia', 'materia',
                'anios_experiencia', 'foto_url', 'correo', 'ubicacion', 'horario_atencion', 'activo'];

/**
 * GET /api/personal — PÚBLICO
 * ?departamento=Docentes   filtra por departamento
 * ?buscar=texto            busca por nombre, cargo o materia
 * ?deportivo=true          solo quienes tienen rol en el área deportiva
 */
router.get('/', asyncHandler(async (req, res) => {
  const condiciones = ['p.activo = TRUE'];
  const params = [];

  if (req.query.departamento) {
    condiciones.push('d.nombre = ?');
    params.push(req.query.departamento);
  }
  if (req.query.buscar) {
    condiciones.push('(p.nombre_completo LIKE ? OR p.cargo LIKE ? OR p.materia LIKE ?)');
    const patron = `%${req.query.buscar}%`;
    params.push(patron, patron, patron);
  }

  const soloDeportivo = req.query.deportivo === 'true';
  const join = soloDeportivo ? 'JOIN personal_deportivo pd ON pd.personal_id = p.id' : '';

  const filas = await query(
    `SELECT DISTINCT p.id, p.nombre_completo, p.cargo, p.biografia, p.materia,
            p.anios_experiencia, p.foto_url, p.correo, p.ubicacion, p.horario_atencion,
            d.nombre AS departamento
     FROM personal p
     JOIN departamentos d ON d.id = p.departamento_id
     ${join}
     WHERE ${condiciones.join(' AND ')}
     ORDER BY d.id, p.nombre_completo`,
    params
  );

  res.json({ datos: filas, total: filas.length });
}));

/** GET /api/personal/departamentos — para llenar el filtro del sitio */
router.get('/departamentos', asyncHandler(async (_req, res) => {
  const filas = await query(
    `SELECT d.id, d.nombre,
            (SELECT COUNT(*) FROM personal p
             WHERE p.departamento_id = d.id AND p.activo = TRUE) AS total
     FROM departamentos d ORDER BY d.id`
  );
  res.json({ datos: filas });
}));

/** GET /api/personal/:id — PÚBLICO (incluye rol deportivo si lo tiene) */
router.get('/:id', asyncHandler(async (req, res) => {
  const filas = await query(
    `SELECT p.*, d.nombre AS departamento
     FROM personal p
     JOIN departamentos d ON d.id = p.departamento_id
     WHERE p.id = ? AND p.activo = TRUE`,
    [req.params.id]
  );
  if (filas.length === 0) return res.status(404).json({ error: 'Persona no encontrada.' });

  const deportivo = await query(
    `SELECT pd.rol_deportivo, pd.cita_destacada, di.nombre AS disciplina
     FROM personal_deportivo pd
     LEFT JOIN disciplinas di ON di.id = pd.disciplina_id
     WHERE pd.personal_id = ?`,
    [req.params.id]
  );

  res.json({ ...filas[0], roles_deportivos: deportivo });
}));

/** POST /api/personal — solo Admin */
router.post('/',
  requiereAuth,
  requierePermiso('gestionar_personal'),
  requierePin,
  asyncHandler(async (req, res) => {
    const { nombre_completo, cargo, departamento_id } = req.body;
    if (!nombre_completo || !cargo || !departamento_id) {
      return res.status(400).json({ error: 'Nombre, cargo y departamento son obligatorios.' });
    }

    try {
      const r = await query(
        `INSERT INTO personal
           (nombre_completo, cargo, departamento_id, biografia, materia,
            anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [nombre_completo, cargo, departamento_id, req.body.biografia || null,
         req.body.materia || null, req.body.anios_experiencia || null,
         req.body.foto_url || null, req.body.correo || null,
         req.body.ubicacion || null, req.body.horario_atencion || null]
      );
      res.status(201).json({ id: r.insertId, mensaje: 'Persona agregada al directorio.' });
    } catch (e) {
      if (e.code === 'ER_DUP_ENTRY') {
        return res.status(409).json({ error: 'Ya existe una persona con ese correo.' });
      }
      throw e;
    }
  })
);

/** PATCH /api/personal/:id — solo Admin */
router.patch('/:id',
  requiereAuth,
  requierePermiso('gestionar_personal'),
  requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body, CAMPOS);
    if (campos.length === 0) {
      return res.status(400).json({ error: 'No se envió ningún campo para actualizar.' });
    }
    valores.push(req.params.id);
    await query(`UPDATE personal SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Datos actualizados.' });
  })
);

/**
 * DELETE /api/personal/:id — baja lógica, no borrado real.
 * Se marca inactivo en lugar de eliminar: así se conserva la autoría de
 * publicaciones antiguas y el historial del área deportiva.
 */
router.delete('/:id',
  requiereAuth,
  requierePermiso('gestionar_personal'),
  requierePin,
  asyncHandler(async (req, res) => {
    await query('UPDATE personal SET activo = FALSE WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Persona dada de baja del directorio (no se borró su historial).' });
  })
);

/* ==================== PERFILES DEPORTIVOS DEL PERSONAL ====================
   Extiende una ficha de `personal` con su rol en el área deportiva
   (Acto 5 de deportes.html). No duplica a la persona, solo la complementa. */

/** GET /api/personal-deportivo — PÚBLICO, listado completo para deportes.html */
router.get('/deportivo/todos', asyncHandler(async (_req, res) => {
  const filas = await query(
    `SELECT pd.id, pd.personal_id, pd.rol_deportivo, pd.cita_destacada, pd.orden,
            p.nombre_completo, p.foto_url, di.nombre AS disciplina
     FROM personal_deportivo pd
     JOIN personal p ON p.id = pd.personal_id
     LEFT JOIN disciplinas di ON di.id = pd.disciplina_id
     WHERE p.activo = TRUE
     ORDER BY pd.orden, pd.id`
  );
  res.json({ datos: filas });
}));

/** POST /api/personal/:id/deportivo — agrega rol deportivo a una persona ya existente */
router.post('/:id/deportivo',
  requiereAuth, requierePermiso('gestionar_personal'), requierePin,
  asyncHandler(async (req, res) => {
    if (!req.body.rol_deportivo) {
      return res.status(400).json({ error: 'El rol deportivo es obligatorio.' });
    }
    const r = await query(
      `INSERT INTO personal_deportivo (personal_id, disciplina_id, rol_deportivo, cita_destacada, orden)
       VALUES (?, ?, ?, ?, ?)`,
      [req.params.id, req.body.disciplina_id || null, req.body.rol_deportivo,
       req.body.cita_destacada || null, req.body.orden || 0]
    );
    res.status(201).json({ id: r.insertId, mensaje: 'Rol deportivo agregado.' });
  })
);

router.patch('/deportivo/:id',
  requiereAuth, requierePermiso('gestionar_personal'), requierePin,
  asyncHandler(async (req, res) => {
    const { campos, valores } = construirUpdate(req.body,
      ['disciplina_id', 'rol_deportivo', 'cita_destacada', 'orden']);
    if (campos.length === 0) return res.status(400).json({ error: 'Nada que actualizar.' });
    valores.push(req.params.id);
    await query(`UPDATE personal_deportivo SET ${campos.join(', ')} WHERE id = ?`, valores);
    res.json({ mensaje: 'Perfil deportivo actualizado.' });
  })
);

router.delete('/deportivo/:id',
  requiereAuth, requierePermiso('gestionar_personal'), requierePin,
  asyncHandler(async (req, res) => {
    await query('DELETE FROM personal_deportivo WHERE id = ?', [req.params.id]);
    res.json({ mensaje: 'Rol deportivo retirado (la persona sigue en el directorio).' });
  })
);

export default router;

