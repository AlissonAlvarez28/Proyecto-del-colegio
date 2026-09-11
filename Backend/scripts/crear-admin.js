/**
 * Crea el PRIMER usuario administrador del sistema.
 *
 * Se ejecuta una sola vez, desde la terminal, después de aplicar schema.sql:
 *     node scripts/crear-admin.js
 *
 * Pide correo y contraseña por consola y guarda SOLO el hash.
 * Nunca escribas una contraseña real dentro de un archivo del proyecto:
 * los archivos se suben a Git y quedan en el historial para siempre.
 */
import 'dotenv/config';
import readline from 'node:readline/promises';
import { stdin, stdout } from 'node:process';
import bcrypt from 'bcrypt';
import { query, pool } from '../src/config/db.js';

const ROUNDS = 12;

async function main() {
  const rl = readline.createInterface({ input: stdin, output: stdout });

  console.log('\n=== Alta del primer administrador ===\n');

  const nombre = await rl.question('Nombre completo: ');
  const correo = (await rl.question('Correo: ')).trim().toLowerCase();
  const contrasena = await rl.question('Contraseña (mínimo 10 caracteres): ');
  const pin = await rl.question('PIN numérico (4 a 8 dígitos): ');

  rl.close();

  if (!nombre || !correo) {
    console.error('\nNombre y correo son obligatorios.');
    process.exit(1);
  }
  if (contrasena.length < 10) {
    console.error('\nLa contraseña debe tener al menos 10 caracteres.');
    process.exit(1);
  }
  if (!/^\d{4,8}$/.test(pin)) {
    console.error('\nEl PIN debe ser numérico, de 4 a 8 dígitos.');
    process.exit(1);
  }

  const existe = await query('SELECT id FROM usuarios WHERE correo = ?', [correo]);
  if (existe.length > 0) {
    console.error('\nYa existe un usuario con ese correo.');
    process.exit(1);
  }

  const contrasenaHash = await bcrypt.hash(contrasena, ROUNDS);
  const pinHash = await bcrypt.hash(pin, ROUNDS);

  const r = await query(
    `INSERT INTO usuarios
       (nombre_completo, correo, contrasena_hash, pin_hash, estado, fecha_activacion)
     VALUES (?, ?, ?, ?, 'activo', NOW())`,
    [nombre, correo, contrasenaHash, pinHash]
  );

  const rol = await query("SELECT id FROM roles WHERE nombre = 'Administrador'");
  if (rol.length === 0) {
    console.error('\nNo se encontró el rol Administrador. ¿Aplicaste schema.sql completo?');
    process.exit(1);
  }

  await query(
    'INSERT INTO usuario_roles (usuario_id, rol_id) VALUES (?, ?)',
    [r.insertId, rol[0].id]
  );

  console.log(`\nAdministrador creado correctamente: ${correo}`);
  console.log('Desde el panel ya puedes invitar a los demás colaboradores.\n');

  await pool.end();
}

main().catch(async (e) => {
  console.error('Error:', e.message);
  await pool.end();
  process.exit(1);
});
