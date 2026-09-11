/**
 * Muestra cuántos registros hay en las tablas principales.
 * Útil después de cargar schema.sql + datos-reales.sql + cifras-deportivas.sql.
 * Uso: node scripts/verificar.js
 */
import 'dotenv/config';
import fs from 'node:fs';
import mysql from 'mysql2/promise';

const conexion = await mysql.createConnection({
  host: process.env.DB_HOST,
  port: Number(process.env.DB_PORT),
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  ssl: { ca: fs.readFileSync(process.env.DB_SSL_CA_PATH), rejectUnauthorized: true },
});

const tablas = ['personal', 'horarios', 'secciones_academicas', 'carreras', 'disciplinas',
                'hitos_historicos', 'logros', 'eventos_deportivos', 'productos',
                'configuracion_institucional', 'roles', 'permisos', 'usuarios'];

for (const tabla of tablas) {
  const [filas] = await conexion.query(`SELECT COUNT(*) AS total FROM ${tabla}`);
  console.log(`${tabla.padEnd(24)} ${filas[0].total}`);
}

await conexion.end();
