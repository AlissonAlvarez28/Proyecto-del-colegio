/**
 * Middlewares de autenticación y autorización.
 *
 * Capas de seguridad, en orden:
 *   1. requiereAuth      → ¿hay sesión válida?
 *   2. requierePermiso   → ¿el rol tiene este permiso?
 *   3. requierePin       → ¿confirmó su PIN hace poco? (solo escrituras)
 *   4. requierePropiedad → si es Colaborador, ¿el registro es suyo?
 */
import jwt from 'jsonwebtoken';
import { query } from '../config/db.js';

const { JWT_SECRET } = process.env;

/** 1. Verifica el token de sesión y carga el usuario con sus permisos. */
export async function requiereAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;

  if (!token) {
    return res.status(401).json({ error: 'Se requiere iniciar sesión.' });
  }

  try {
    const payload = jwt.verify(token, JWT_SECRET);

    const filas = await query(
      `SELECT u.id, u.nombre_completo, u.correo, u.estado
       FROM usuarios u
       WHERE u.id = ? AND u.estado = 'activo'`,
      [payload.sub]
    );

    if (filas.length === 0) {
      return res.status(401).json({ error: 'La cuenta no está activa.' });
    }

    const permisos = await query(
      `SELECT DISTINCT p.clave
       FROM usuario_roles ur
       JOIN rol_permisos rp ON rp.rol_id = ur.rol_id
       JOIN permisos p      ON p.id = rp.permiso_id
       WHERE ur.usuario_id = ?`,
      [payload.sub]
    );

    const roles = await query(
      `SELECT r.nombre FROM usuario_roles ur
       JOIN roles r ON r.id = ur.rol_id
       WHERE ur.usuario_id = ?`,
      [payload.sub]
    );

    req.usuario = {
      ...filas[0],
      permisos: permisos.map((p) => p.clave),
      roles: roles.map((r) => r.nombre),
      esAdmin: roles.some((r) => r.nombre === 'Administrador'),
      pinVerificado: payload.pin === true,
    };

    next();
  } catch {
    return res.status(401).json({ error: 'Sesión inválida o expirada.' });
  }
}

/** 2. Exige un permiso concreto. */
export function requierePermiso(clave) {
  return (req, res, next) => {
    if (!req.usuario?.permisos.includes(clave)) {
      return res.status(403).json({ error: 'No tienes permiso para esta acción.' });
    }
    next();
  };
}

/**
 * 3. Exige que el PIN haya sido confirmado recientemente.
 * El token de sesión normal NO incluye pin=true; solo el que devuelve
 * /api/auth/verificar-pin lo incluye, y con vigencia corta.
 */
export function requierePin(req, res, next) {
  if (!req.usuario?.pinVerificado) {
    return res.status(403).json({
      error: 'Confirma tu PIN para realizar cambios.',
      codigo: 'PIN_REQUERIDO',
    });
  }
  next();
}

/**
 * 4. Regla de propiedad: un Colaborador solo puede modificar/eliminar
 * lo que él mismo creó. Un Administrador no tiene esta restricción.
 */
export function requierePropiedad(tabla, columna = 'creado_por') {
  return async (req, res, next) => {
    if (req.usuario.esAdmin) return next();

    const filas = await query(
      `SELECT ${columna} AS propietario FROM ${tabla} WHERE id = ?`,
      [req.params.id]
    );

    if (filas.length === 0) {
      return res.status(404).json({ error: 'Registro no encontrado.' });
    }
    if (filas[0].propietario !== req.usuario.id) {
      return res.status(403).json({ error: 'Solo puedes modificar contenido que tú creaste.' });
    }
    next();
  };
}

/**
 * Middleware opcional: identifica al usuario si hay token, pero no
 * bloquea si no lo hay. Útil en endpoints públicos que muestran más
 * información a quien sí tiene sesión (ej. identidad tras un anónimo).
 */
export async function authOpcional(req, _res, next) {
  const header = req.headers.authorization || '';
  if (!header.startsWith('Bearer ')) return next();
  try {
    await requiereAuth(req, { status: () => ({ json: () => {} }) }, () => {});
  } catch {
    // sin sesión válida: continúa como visitante
  }
  next();
}
