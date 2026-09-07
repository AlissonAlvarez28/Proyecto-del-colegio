/**
 * Servidor principal — API institucional I.G.T. Francisco Miranda
 */
import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';

import { verificarConexion } from './config/db.js';

import authRoutes from './routes/auth.routes.js';
import usuariosRoutes from './routes/usuarios.routes.js';
import personalRoutes from './routes/personal.routes.js';
import publicacionesRoutes from './routes/publicaciones.routes.js';
import comentariosRoutes from './routes/comentarios.routes.js';
import academicoRoutes from './routes/academico.routes.js';
import eventosRoutes from './routes/eventos.routes.js';
import testimoniosRoutes from './routes/testimonios.routes.js';
import equiposRoutes from './routes/equipos.routes.js';
import deportesContenidoRoutes from './routes/deportes-contenido.routes.js';
import proyectosRoutes from './routes/proyectos.routes.js';
import tiendaRoutes from './routes/tienda.routes.js';

const app = express();
const PORT = process.env.PORT || 3000;

app.use(helmet());
app.use(express.json({ limit: '1mb' }));

// Solo el frontend del instituto puede consumir la API desde el navegador.
app.use(cors({
  origin: (process.env.CORS_ORIGINS || '').split(',').filter(Boolean),
  credentials: true,
}));

// Límite general
app.use('/api', rateLimit({ windowMs: 15 * 60 * 1000, max: 300 }));

// Límite estricto en login: frena intentos de adivinar contraseñas por fuerza bruta.
app.use('/api/auth/login', rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 8,
  message: { error: 'Demasiados intentos. Espera unos minutos antes de volver a intentar.' },
}));
app.use('/api/auth/verificar-pin', rateLimit({ windowMs: 15 * 60 * 1000, max: 10 }));

app.get('/api/salud', async (_req, res) => {
  try {
    await verificarConexion();
    res.json({ estado: 'ok', bd: 'conectada' });
  } catch {
    res.status(503).json({ estado: 'error', bd: 'sin conexión' });
  }
});

/* ---------- Seguridad y cuentas ---------- */
app.use('/api/auth', authRoutes);
app.use('/api/usuarios', usuariosRoutes);

/* ---------- Contenido institucional ---------- */
app.use('/api/personal', personalRoutes);
app.use('/api/publicaciones', publicacionesRoutes);
app.use('/api', comentariosRoutes);   // define sus rutas completas internamente
app.use('/api', academicoRoutes);     // carreras, secciones y horarios

/* ---------- Módulo de deportes ---------- */
app.use('/api/eventos-deportivos', eventosRoutes);
app.use('/api/testimonios', testimoniosRoutes);
app.use('/api/equipos', equiposRoutes);
app.use('/api', deportesContenidoRoutes);  // disciplinas, hitos, logros, estadísticas

/* ---------- Infraestructura y tienda ---------- */
app.use('/api/proyectos-futuros', proyectosRoutes);
app.use('/api', tiendaRoutes);        // productos y configuración

app.use((req, res) => {
  res.status(404).json({ error: `Ruta no encontrada: ${req.method} ${req.originalUrl}` });
});

/**
 * Manejo central de errores.
 * Nunca devolvemos el detalle técnico al cliente: eso ayudaría a un
 * atacante a mapear la base de datos. El detalle va al log del servidor.
 */
app.use((err, _req, res, _next) => {
  console.error('[ERROR]', err);
  res.status(500).json({ error: 'Ocurrió un error en el servidor.' });
});

app.listen(PORT, () => {
  console.log(`API escuchando en el puerto ${PORT}`);
});
