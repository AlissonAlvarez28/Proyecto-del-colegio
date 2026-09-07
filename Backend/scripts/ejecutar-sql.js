/**
 * Ejecuta un archivo .sql contra la base de datos configurada en .env.
 * Uso: node scripts/ejecutar-sql.js schema.sql
 *      node scripts/ejecutar-sql.js datos-reales.sql
 *      node scripts/ejecutar-sql.js cifras-deportivas.sql
 */
import 'dotenv/config';
import fs from 'node:fs';
import path from 'node:path';
import mysql from 'mysql2/promise';

const archivo = process.argv[2];
if (!archivo) {
  console.error('Uso: node scripts/ejecutar-sql.js nombre-del-archivo.sql');
  process.exit(1);
}

// Permite pasar solo el nombre del archivo aunque se ejecute desde otra carpeta.
const rutaArchivo = path.isAbsolute(archivo) ? archivo : path.resolve(process.cwd(), archivo);
if (!fs.existsSync(rutaArchivo)) {
  console.error(`❌ No se encontró el archivo: ${rutaArchivo}`);
  process.exit(1);
}

const sql = fs.readFileSync(rutaArchivo, 'utf-8');

const conexion = await mysql.createConnection({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: { ca: fs.readFileSync(process.env.DB_SSL_CA_PATH), rejectUnauthorized: true },
  multipleStatements: true,
});

console.log(`Ejecutando ${path.basename(rutaArchivo)}...`);
try {
  await conexion.query(sql);
  console.log('✅ Listo, sin errores.');
} catch (e) {
  console.error('❌ Error:', e.message);
  process.exitCode = 1;
} finally {
  await conexion.end();
}
