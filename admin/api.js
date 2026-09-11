/**
 * Capa de comunicación con la API — Panel administrativo IGTFM.
 *
 * Centraliza: base URL configurable, token de sesión, y el flujo de PIN
 * (cualquier escritura que reciba PIN_REQUERIDO pide el PIN una vez y
 * reintenta sola, para no repetir esa lógica en cada pantalla).
 */
const Api = (() => {
  // Cambiar aquí cuando el backend se despliegue fuera de localhost.
  const BASE_URL = window.IGTFM_API_URL || 'http://localhost:3000/api';

  let token = localStorage.getItem('igtfm_token') || null;
  let pinToken = null; // corta duración (15 min), no se persiste entre recargas

  function guardarSesion(t, usuario) {
    token = t;
    localStorage.setItem('igtfm_token', t);
    localStorage.setItem('igtfm_usuario', JSON.stringify(usuario));
  }

  function cerrarSesion() {
    token = null;
    pinToken = null;
    localStorage.removeItem('igtfm_token');
    localStorage.removeItem('igtfm_usuario');
  }

  function usuarioActual() {
    try { return JSON.parse(localStorage.getItem('igtfm_usuario') || 'null'); }
    catch { return null; }
  }

  function haySesion() { return Boolean(token); }

  /** Pide el PIN mediante el modal definido en app.js (se inyecta para evitar dependencia circular). */
  let solicitarPinUI = async () => null;
  function registrarSolicitudPin(fn) { solicitarPinUI = fn; }

  async function verificarPin(pin) {
    const r = await fetch(`${BASE_URL}/auth/verificar-pin`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ pin }),
    });
    const datos = await r.json();
    if (!r.ok || !datos.ok) throw new Error(datos.error || 'PIN incorrecto.');
    pinToken = datos.token;
    return pinToken;
  }

  /**
   * Llamada genérica a la API.
   * Si el backend responde PIN_REQUERIDO, pide el PIN (una vez) y reintenta
   * automáticamente con el token de PIN — el resto del código no necesita
   * saber que ese paso existe.
   */
  async function llamar(ruta, opciones = {}, _reintentado = false) {
    const headers = { 'Content-Type': 'application/json', ...(opciones.headers || {}) };
    if (token) headers.Authorization = `Bearer ${pinToken || token}`;

    const r = await fetch(`${BASE_URL}${ruta}`, { ...opciones, headers });
    let datos;
    try { datos = await r.json(); } catch { datos = {}; }

    if (r.status === 401 && datos.codigo !== 'PIN_REQUERIDO') {
      cerrarSesion();
      window.dispatchEvent(new CustomEvent('igtfm:sesion-expirada'));
      throw new Error(datos.error || 'Sesión inválida. Inicia sesión de nuevo.');
    }

    if (r.status === 403 && datos.codigo === 'PIN_REQUERIDO' && !_reintentado) {
      const pin = await solicitarPinUI();
      if (!pin) throw new Error('Se requiere el PIN para continuar.');
      await verificarPin(pin);
      return llamar(ruta, opciones, true);
    }

    if (!r.ok) throw new Error(datos.error || `Error ${r.status}`);
    return datos;
  }

  async function login(correo, contrasena) {
    const r = await fetch(`${BASE_URL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ correo, contrasena }),
    });
    const datos = await r.json();
    if (!r.ok || !datos.ok) throw new Error(datos.error || 'No se pudo iniciar sesión.');
    guardarSesion(datos.token, datos.usuario);
    return datos.usuario;
  }

  async function cargarPermisos() {
    const yo = await llamar('/auth/yo');
    localStorage.setItem('igtfm_permisos', JSON.stringify(yo.permisos || []));
    localStorage.setItem('igtfm_roles', JSON.stringify(yo.roles || []));
    return yo;
  }

  function tienePermiso(clave) {
    try {
      const permisos = JSON.parse(localStorage.getItem('igtfm_permisos') || '[]');
      return permisos.includes(clave);
    } catch { return false; }
  }

  return {
    llamar, login, cerrarSesion, haySesion, usuarioActual,
    cargarPermisos, tienePermiso, registrarSolicitudPin,
    get: (ruta) => llamar(ruta),
    post: (ruta, cuerpo) => llamar(ruta, { method: 'POST', body: JSON.stringify(cuerpo) }),
    patch: (ruta, cuerpo) => llamar(ruta, { method: 'PATCH', body: JSON.stringify(cuerpo) }),
    put: (ruta, cuerpo) => llamar(ruta, { method: 'PUT', body: JSON.stringify(cuerpo) }),
    del: (ruta) => llamar(ruta, { method: 'DELETE' }),
  };
})();
