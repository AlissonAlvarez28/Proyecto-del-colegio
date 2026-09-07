/**
 * Utilidades compartidas para los módulos CRUD.
 *
 * Varios recursos (hitos, logros, disciplinas, productos...) siguen
 * exactamente el mismo patrón: listar público, crear, editar y borrar
 * protegido. En vez de repetir ese código en cada archivo de rutas,
 * se centraliza aquí.
 */
import { query } from '../config/db.js';

/**
 * Construye la parte SET de un UPDATE a partir de los campos permitidos
 * que realmente vengan en el cuerpo de la petición.
 *
 * Importante: solo se aceptan los campos de la lista blanca. Nunca se
 * arma el SQL con nombres de columna que vengan del cliente, porque eso
 * abriría la puerta a inyección SQL.
 */
export function construirUpdate(cuerpo, camposPermitidos) {
  const campos = [];
  const valores = [];
  for (const campo of camposPermitidos) {
    if (cuerpo[campo] !== undefined) {
      campos.push(`${campo} = ?`);
      valores.push(cuerpo[campo]);
    }
  }
  return { campos, valores };
}

/** Envuelve un manejador async para que los errores lleguen al middleware central. */
export function asyncHandler(fn) {
  return (req, res, next) => Promise.resolve(fn(req, res, next)).catch(next);
}

/** Lee parámetros de paginación con límites sanos. */
export function paginacion(req, limitePorDefecto = 20, limiteMaximo = 100) {
  const limite = Math.min(Number(req.query.limite) || limitePorDefecto, limiteMaximo);
  const pagina = Math.max(Number(req.query.pagina) || 1, 1);
  return { limite, offset: (pagina - 1) * limite, pagina };
}

/** Comprueba que un registro exista antes de operar sobre él. */
export async function existe(tabla, id) {
  const filas = await query(`SELECT id FROM ${tabla} WHERE id = ?`, [id]);
  return filas.length > 0;
}
