import { Router } from 'express';
import * as authService from '../services/authService.js';
import { requiereAuth, requierePermiso } from '../middleware/auth.js';

const router = Router();

/** POST /api/auth/login — público */
router.post('/login', async (req, res, next) => {
  try {
    const { correo, contrasena } = req.body;
    if (!correo || !contrasena) {
      return res.status(400).json({ error: 'Correo y contraseña son obligatorios.' });
    }
    const r = await authService.login(correo, contrasena);
    if (!r.ok) return res.status(401).json(r);
    res.json(r);
  } catch (e) { next(e); }
});

/** POST /api/auth/activar — primer ingreso de una cuenta invitada */
router.post('/activar', async (req, res, next) => {
  try {
    const { correo, contrasena, pin } = req.body;
    const r = await authService.activarCuenta(correo, contrasena, pin);
    if (!r.ok) return res.status(400).json(r);
    res.json(r);
  } catch (e) { next(e); }
});

/** POST /api/auth/verificar-pin — confirma el PIN antes de escribir */
router.post('/verificar-pin', requiereAuth, async (req, res, next) => {
  try {
    const r = await authService.verificarPin(req.usuario.id, req.body.pin);
    if (!r.ok) return res.status(401).json(r);
    res.json(r);
  } catch (e) { next(e); }
});

/** GET /api/auth/yo — datos de la sesión actual */
router.get('/yo', requiereAuth, (req, res) => {
  res.json({
    id: req.usuario.id,
    nombre_completo: req.usuario.nombre_completo,
    correo: req.usuario.correo,
    roles: req.usuario.roles,
    permisos: req.usuario.permisos,
  });
});

/** POST /api/auth/invitar — solo administradores */
router.post('/invitar', requiereAuth, requierePermiso('gestionar_usuarios'), async (req, res, next) => {
  try {
    const { nombreCompleto, correo, rolId } = req.body;
    if (!nombreCompleto || !correo || !rolId) {
      return res.status(400).json({ error: 'Nombre, correo y rol son obligatorios.' });
    }
    const r = await authService.invitarUsuario({
      nombreCompleto, correo, rolId, invitadoPor: req.usuario.id,
    });
    if (!r.ok) return res.status(400).json(r);
    res.status(201).json(r);
  } catch (e) { next(e); }
});

export default router;
