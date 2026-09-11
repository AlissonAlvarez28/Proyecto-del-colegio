/**
 * Prueba la conexión a Aiven usando los datos del .env.
 * Uso: node scripts/probar-conexion.js
 */
import 'dotenv/config';

console.log('Host:', process.env.DB_HOST);
console.log('Usuario:', process.env.DB_USER);
console.log('Puerto:', process.env.DB_PORT);
console.log('Base de datos:', process.env.DB_NAME);
console.log('Ruta del certificado:', process.env.DB_SSL_CA_PATH);
console.log('');

import { verificarConexion } from '../src/config/db.js';

try {
  await verificarConexion();
  console.log('✅ Conexión exitosa a Aiven');
} catch (e) {
  console.error('❌ Error de conexión');
  console.error('Mensaje:', e.message);
  console.error('Código:', e.code);
}
process.exit();
