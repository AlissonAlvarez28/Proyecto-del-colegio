/**
 * Conexión a MySQL mediante pool.
 * Compatible con Aiven (requiere SSL) y con MySQL local para desarrollo.
 */
import mysql from 'mysql2/promise';
import fs from 'node:fs';

const {
  DB_HOST,
  DB_PORT = 3306,
  DB_USER,
  DB_PASSWORD,
  DB_NAME,
  DB_SSL_CA_PATH, // Desarrollo local: ruta al archivo ca.pem
  DB_SSL_CA,      // Producción (Render, etc.): el contenido del certificado
                   // pegado directo como variable de entorno, porque en la
                   // nube no existe una carpeta certs/ local para leer.
} = process.env;

var certificado;
if (DB_SSL_CA) {
  certificado = DB_SSL_CA;
} else if (DB_SSL_CA_PATH) {
  certificado = fs.readFileSync(DB_SSL_CA_PATH);
}
const ssl = certificado ? { ca: certificado, rejectUnauthorized: true } : undefined;

export const pool = mysql.createPool({
  host: DB_HOST,
  port: Number(DB_PORT),
  user: DB_USER,
  password: DB_PASSWORD,
  database: DB_NAME,
  ssl,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  timezone: 'Z',
  charset: 'utf8mb4',
});

/**
 * Ejecuta una consulta parametrizada.
 * SIEMPRE usar placeholders (?) — nunca concatenar valores en el SQL.
 * Esta es la defensa principal contra inyección SQL.
 */
export async function query(sql, params = []) {
  const [rows] = await pool.execute(sql, params);
  return rows;
}

export async function verificarConexion() {
  const conn = await pool.getConnection();
  await conn.ping();
  conn.release();
}
