/**
 * MÓDULO DE REFERENCIA — Eventos deportivos.
 *
 * Este archivo es la plantilla del patrón que siguen los demás módulos
 * (publicaciones, hitos, logros, productos...). Al construir los otros,
 * copiar esta estructura y cambiar tabla, campos y claves de permiso.
 */
import { Router } from 'express';
import { query } from '../config/db.js';
import {
  requiereAuth, requierePermiso, requierePin, requierePropiedad,
} from '../middleware/auth.js';

const router = Router();

/**
 * GET /api/eventos-deportivos — PÚBLICO
 * Filtros: ?estado=proximo|jugado  ?disciplina=1  ?destacado=true
 * Paginación: ?limite=10&pagina=1
 */
router.get('/', async (req, res, next) => {
  try {
    const { estado, disciplina, destacado } = req.query;
    const limite = Math.min(Number(req.query.limite) || 20, 100);
    const pagina = Math.max(Number(req.query.pagina) || 1, 1);
    const offset = (pagina - 1) * limite;

    const condiciones = [];
    const params = [];

    if (estado)    { condiciones.push('e.estado = ?');        params.push(estado); }
    if (disciplina){ condiciones.push('e.disciplina_id = ?'); params.push(Number(disciplina)); }
    if (destacado === 'true') condiciones.push('e.destacado = TRUE');

    const where = condiciones.length ? `WHERE ${condiciones.join(' AND ')}` : '';

    const filas = await query(
      `SELECT e.id, e.titulo, e.rival, e.fecha, e.lugar, e.estado,
              e.resultado, e.destacado,
              e.disciplina_id, e.categoria_id, e.equipo_id,
              d.nombre AS disciplina, c.nombre AS categoria, eq.nombre AS equipo
       FROM eventos_deportivos e
       JOIN disciplinas d            ON d.id = e.disciplina_id
       JOIN categorias_competencia c ON c.id = e.categoria_id
       LEFT JOIN equipos eq          ON eq.id = e.equipo_id
       ${where}
       ORDER BY e.fecha ASC
       LIMIT ? OFFSET ?`,
      [...params, limite, offset]
    );

    res.json({ datos: filas, pagina, limite });
  } catch (e) { next(e); }
});

/** GET /api/eventos-deportivos/:id — PÚBLICO */
router.get('/:id', async (req, res, next) => {
  try {
    const filas = await query(
      `SELECT e.*, d.nombre AS disciplina, c.nombre AS categoria
       FROM eventos_deportivos e
       JOIN disciplinas d            ON d.id = e.disciplina_id
       JOIN categorias_competencia c ON c.id = e.categoria_id
       WHERE e.id = ?`,
      [req.params.id]
    );
    if (filas.length === 0) return res.status(404).json({ error: 'Evento no encontrado.' });
    res.json(filas[0]);
  } catch (e) { next(e); }
});

/** POST /api/eventos-deportivos — requiere sesión + permiso + PIN */
router.post('/',
  requiereAuth,
  requierePermiso('crear_evento_deportivo'),
  requierePin,
  async (req, res, next) => {
    try {
      const { titulo, rival, disciplina_id, categoria_id, equipo_id, fecha, lugar, destacado } = req.body;

      if (!titulo || !disciplina_id || !categoria_id || !fecha) {
        return res.status(400).json({
          error: 'Título, disciplina, categoría y fecha son obligatorios.',
        });
      }

      const r = await query(
        `INSERT INTO eventos_deportivos
           (titulo, rival, disciplina_id, categoria_id, equipo_id, fecha, lugar, destacado, creado_por)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
        [titulo, rival || null, disciplina_id, categoria_id, equipo_id || null,
         fecha, lugar || null, Boolean(destacado), req.usuario.id]
      );

      res.status(201).json({ id: r.insertId, mensaje: 'Evento creado.' });
    } catch (e) { next(e); }
  }
);

/** PATCH /api/eventos-deportivos/:id — edición */
router.patch('/:id',
  requiereAuth,
  requierePermiso('editar_evento_deportivo'),
  requierePin,
  async (req, res, next) => {
    try {
      const permitidos = ['titulo','rival','disciplina_id','categoria_id','equipo_id',
                          'fecha','lugar','estado','resultado','destacado'];
      const campos = [];
      const params = [];

      for (const c of permitidos) {
        if (req.body[c] !== undefined) { campos.push(`${c} = ?`); params.push(req.body[c]); }
      }
      if (campos.length === 0) {
        return res.status(400).json({ error: 'No se envió ningún campo para actualizar.' });
      }

      params.push(req.params.id);
      await query(`UPDATE eventos_deportivos SET ${campos.join(', ')} WHERE id = ?`, params);
      res.json({ mensaje: 'Evento actualizado.' });
    } catch (e) { next(e); }
  }
);

/**
 * DELETE /api/eventos-deportivos/:id
 * requierePropiedad: un Colaborador solo borra lo que él creó;
 * un Administrador puede borrar cualquiera.
 */
router.delete('/:id',
  requiereAuth,
  requierePermiso('crear_evento_deportivo'),
  requierePin,
  requierePropiedad('eventos_deportivos'),
  async (req, res, next) => {
    try {
      await query('DELETE FROM eventos_deportivos WHERE id = ?', [req.params.id]);
      res.json({ mensaje: 'Evento eliminado.' });
    } catch (e) { next(e); }
  }
);

export default router;
