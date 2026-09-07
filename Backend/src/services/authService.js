/**
 * Lógica de autenticación.
 *
 * Reglas fundamentales de este archivo:
 *  - Las contraseñas y los PIN se guardan SIEMPRE hasheados (bcrypt).
 *  - Nunca se devuelve contrasena_hash ni pin_hash al cliente.
 *  - No existe registro público: solo activación de cuentas invitadas.
 */
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { query } from '../config/db.js';

const { JWT_SECRET, JWT_EXPIRES = '8h' } = process.env;
const ROUNDS = 12;

/** Inicia sesión. Devuelve token + datos públicos del usuario. */
export async function login(correo, contrasena) {
  const filas = await query(
    `SELECT id, nombre_completo, correo, contrasena_hash, estado
     FROM usuarios WHERE correo = ?`,
    [correo]
  );

  // Mensaje genérico a propósito: no revelamos si el correo existe o no.
  const generico = { ok: false, error: 'Correo o contraseña incorrectos.' };
  if (filas.length === 0) return generico;

  const u = filas[0];

  if (u.estado === 'invitado') {
    return { ok: false, requiereActivacion: true,
             error: 'Tu cuenta fue creada por un administrador. Configura tu contraseña y PIN para continuar.' };
  }
  if (u.estado === 'inactivo') {
    return { ok: false, error: 'Esta cuenta está desactivada.' };
  }

  const coincide = await bcrypt.compare(contrasena, u.contrasena_hash);
  if (!coincide) return generico;

  await query('UPDATE usuarios SET ultimo_acceso = NOW() WHERE id = ?', [u.id]);

  const token = jwt.sign({ sub: u.id }, JWT_SECRET, { expiresIn: JWT_EXPIRES });
  return {
    ok: true,
    token,
    usuario: { id: u.id, nombre_completo: u.nombre_completo, correo: u.correo },
  };
}

/**
 * Activa una cuenta invitada: define contraseña y PIN por primera vez.
 *
 * LIMITACIÓN CONOCIDA (decisión de alcance, documentada en ETAPA D):
 * no se verifica que quien activa controle realmente ese correo, porque
 * no hay envío de correo de confirmación. Aceptable solo porque el grupo
 * de invitados es reducido y de confianza. Mejora pendiente: enlace de
 * activación con token enviado por correo.
 */
export async function activarCuenta(correo, contrasena, pin) {
  if (!contrasena || contrasena.length < 10) {
    return { ok: false, error: 'La contraseña debe tener al menos 10 caracteres.' };
  }
  if (!/^\d{4,8}$/.test(pin)) {
    return { ok: false, error: 'El PIN debe ser numérico, de 4 a 8 dígitos.' };
  }

  const filas = await query(
    `SELECT id, estado FROM usuarios WHERE correo = ?`,
    [correo]
  );
  if (filas.length === 0 || filas[0].estado !== 'invitado') {
    return { ok: false, error: 'No hay ninguna invitación pendiente para este correo.' };
  }

  const contrasenaHash = await bcrypt.hash(contrasena, ROUNDS);
  const pinHash = await bcrypt.hash(pin, ROUNDS);

  await query(
    `UPDATE usuarios
     SET contrasena_hash = ?, pin_hash = ?, estado = 'activo', fecha_activacion = NOW()
     WHERE id = ?`,
    [contrasenaHash, pinHash, filas[0].id]
  );

  return { ok: true, mensaje: 'Cuenta activada. Ya puedes iniciar sesión.' };
}

/**
 * Verifica el PIN y devuelve un token de corta duración que habilita
 * operaciones de escritura. Este token es el que satisface requierePin().
 */
export async function verificarPin(usuarioId, pin) {
  const filas = await query('SELECT pin_hash FROM usuarios WHERE id = ?', [usuarioId]);
  if (filas.length === 0 || !filas[0].pin_hash) {
    return { ok: false, error: 'No tienes un PIN configurado.' };
  }

  const coincide = await bcrypt.compare(pin, filas[0].pin_hash);
  if (!coincide) return { ok: false, error: 'PIN incorrecto.' };

  // Vigencia corta: la confirmación caduca en 15 minutos.
  const token = jwt.sign({ sub: usuarioId, pin: true }, JWT_SECRET, { expiresIn: '15m' });
  return { ok: true, token };
}

/** Un administrador invita a alguien nuevo. */
export async function invitarUsuario({ nombreCompleto, correo, rolId, invitadoPor }) {
  const existe = await query('SELECT id FROM usuarios WHERE correo = ?', [correo]);
  if (existe.length > 0) {
    return { ok: false, error: 'Ya existe una cuenta con ese correo.' };
  }

  const resultado = await query(
    `INSERT INTO usuarios (nombre_completo, correo, estado, invitado_por, fecha_invitacion)
     VALUES (?, ?, 'invitado', ?, NOW())`,
    [nombreCompleto, correo, invitadoPor]
  );

  await query(
    `INSERT INTO usuario_roles (usuario_id, rol_id, asignado_por) VALUES (?, ?, ?)`,
    [resultado.insertId, rolId, invitadoPor]
  );

  return {
    ok: true,
    mensaje: `Invitación creada. ${correo} podrá configurar su contraseña y PIN al ingresar por primera vez.`,
  };
}
