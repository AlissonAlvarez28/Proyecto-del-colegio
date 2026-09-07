/**
 * sesion.js — Inicio de sesión para el sitio público.
 *
 * REGLA DE ACCESO (definida en el diseño del proyecto):
 *  - Cualquiera puede ABRIR el formulario e intentar iniciar sesión.
 *  - Solo puede CREAR su contraseña quien ya fue invitado por un
 *    administrador (su correo debe existir en la base con estado
 *    'invitado'). No hay registro abierto al público.
 *
 * Sirve para que docentes, padres y estudiantes autorizados puedan
 * comentar y enviar testimonios con identidad trazable.
 */
(function () {
  'use strict';

  var API = window.IGTFM_API_URL || 'http://localhost:3000/api';
  // Mismas claves que usa admin/api.js: iniciar sesión aquí también deja
  // lista la sesión para entrar directo al panel, sin pedirla dos veces.
  var TOKEN_KEY = 'igtfm_token';
  var USER_KEY = 'igtfm_usuario';
  var PERMISOS_KEY = 'igtfm_permisos';
  var ROLES_KEY = 'igtfm_roles';

  /* ---------------- Estado de sesión ---------------- */
  var Sesion = {
    token: function () { return localStorage.getItem(TOKEN_KEY); },
    usuario: function () {
      try { return JSON.parse(localStorage.getItem(USER_KEY) || 'null'); } catch (e) { return null; }
    },
    activa: function () { return Boolean(localStorage.getItem(TOKEN_KEY)); },
    permisos: function () {
      try { return JSON.parse(localStorage.getItem(PERMISOS_KEY) || '[]'); } catch (e) { return []; }
    },
    esColaboradorOAdmin: function () { return Sesion.permisos().length > 0; },
    guardar: function (token, usuario) {
      localStorage.setItem(TOKEN_KEY, token);
      localStorage.setItem(USER_KEY, JSON.stringify(usuario));
    },
    cerrar: function () {
      localStorage.removeItem(TOKEN_KEY);
      localStorage.removeItem(USER_KEY);
      localStorage.removeItem(PERMISOS_KEY);
      localStorage.removeItem(ROLES_KEY);
      dibujarBoton();
      window.dispatchEvent(new CustomEvent('igtfm:sesion-cambio'));
    }
  };
  window.IGTFMSesion = Sesion;

  /**
   * Consulta los permisos reales del usuario contra la API (los mismos
   * que usa el panel para decidir qué secciones mostrar). Solo quien
   * tiene al menos un permiso (es decir, cualquier cuenta invitada —
   * Administrador o Colaborador) ve el enlace al panel administrativo;
   * las cuentas solo existen por invitación, así que no hace falta
   * distinguir más roles que ese.
   */
  async function cargarPermisos() {
    try {
      var r = await fetch(API + '/auth/yo', {
        headers: { Authorization: 'Bearer ' + Sesion.token() }
      });
      if (!r.ok) return;
      var yo = await r.json();
      localStorage.setItem(PERMISOS_KEY, JSON.stringify(yo.permisos || []));
      localStorage.setItem(ROLES_KEY, JSON.stringify(yo.roles || []));
    } catch (e) { /* sin conexión: el botón de panel simplemente no aparece */ }
  }

  function esc(t) {
    return String(t == null ? '' : t).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' }[c];
    });
  }

  /* ---------------- Modal ---------------- */
  function cerrarModal() {
    var m = document.getElementById('modal-sesion');
    if (m) m.remove();
  }

  function abrirModal(vista) {
    cerrarModal();
    var contenido = vista === 'activar' ? vistaActivar() : vistaLogin();
    var modal = document.createElement('div');
    modal.id = 'modal-sesion';
    modal.className = 'admin-modal-backdrop';
    modal.innerHTML = '<div class="admin-modal small">' + contenido + '</div>';
    document.body.appendChild(modal);

    modal.addEventListener('click', function (e) { if (e.target === modal) cerrarModal(); });
    document.getElementById('sesion-cerrar').onclick = cerrarModal;

    if (vista === 'activar') {
      document.getElementById('form-activar-publico').addEventListener('submit', enviarActivacion);
      document.getElementById('ir-a-login').onclick = function (e) { e.preventDefault(); abrirModal('login'); };
    } else {
      document.getElementById('form-login-publico').addEventListener('submit', enviarLogin);
      document.getElementById('ir-a-activar').onclick = function (e) { e.preventDefault(); abrirModal('activar'); };
    }
  }

  function vistaLogin() {
    return '' +
      '<h3 style="margin-bottom:.3rem;">Iniciar sesión</h3>' +
      '<p style="font-size:.82rem;color:var(--color-text-secondary);margin-bottom:1.1rem;">' +
      'Para comentar y participar en el sitio.</p>' +
      '<div id="sesion-mensaje"></div>' +
      '<form id="form-login-publico">' +
        '<div class="admin-field"><label>Correo</label><input type="email" id="sp-correo" required autocomplete="username"></div>' +
        '<div class="admin-field"><label>Contraseña</label><input type="password" id="sp-contrasena" required autocomplete="current-password"></div>' +
        '<button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">Entrar</button>' +
      '</form>' +
      '<p style="font-size:.75rem;color:var(--color-muted);margin-top:.9rem;">' +
        '¿Te invitaron y es tu primera vez? <a href="#" id="ir-a-activar">Crea tu contraseña</a>.' +
      '</p>' +
      '<p style="font-size:.7rem;color:var(--color-muted);margin-top:.6rem;line-height:1.4;">' +
        'Las cuentas se crean solo por invitación de la administración del instituto.</p>' +
      '<button class="btn btn-outline btn-sm" id="sesion-cerrar" style="margin-top:1rem;">Cancelar</button>';
  }

  function vistaActivar() {
    return '' +
      '<h3 style="margin-bottom:.3rem;">Crear mi contraseña</h3>' +
      '<p style="font-size:.82rem;color:var(--color-text-secondary);margin-bottom:1.1rem;">' +
      'Solo funciona si un administrador ya registró tu correo.</p>' +
      '<div id="sesion-mensaje"></div>' +
      '<form id="form-activar-publico">' +
        '<div class="admin-field"><label>Correo con el que te invitaron</label><input type="email" id="sp-act-correo" required></div>' +
        '<div class="admin-field"><label>Nueva contraseña (mínimo 10 caracteres)</label><input type="password" id="sp-act-contrasena" required minlength="10"></div>' +
        '<div class="admin-field"><label>PIN de 4 a 8 dígitos</label><input type="password" inputmode="numeric" id="sp-act-pin" required pattern="\\d{4,8}"></div>' +
        '<button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">Activar mi cuenta</button>' +
      '</form>' +
      '<p style="font-size:.75rem;color:var(--color-muted);margin-top:.9rem;">' +
        '¿Ya tienes contraseña? <a href="#" id="ir-a-login">Inicia sesión</a>.</p>' +
      '<button class="btn btn-outline btn-sm" id="sesion-cerrar" style="margin-top:1rem;">Cancelar</button>';
  }

  function mensaje(texto, tipo) {
    var cont = document.getElementById('sesion-mensaje');
    if (cont) cont.innerHTML = '<div class="admin-' + (tipo || 'error') + '">' + esc(texto) + '</div>';
  }

  /* ---------------- Acciones ---------------- */
  async function enviarLogin(e) {
    e.preventDefault();
    var correo = document.getElementById('sp-correo').value;
    var contrasena = document.getElementById('sp-contrasena').value;
    try {
      var r = await fetch(API + '/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ correo: correo, contrasena: contrasena })
      });
      var datos = await r.json();

      if (datos.requiereActivacion) {
        abrirModal('activar');
        setTimeout(function () { mensaje(datos.error, 'success'); }, 50);
        return;
      }
      if (!r.ok || !datos.ok) { mensaje(datos.error || 'No se pudo iniciar sesión.'); return; }

      Sesion.guardar(datos.token, datos.usuario);
      await cargarPermisos();
      cerrarModal();
      dibujarBoton();
      window.dispatchEvent(new CustomEvent('igtfm:sesion-cambio'));
    } catch (err) {
      mensaje('No se pudo conectar con el servidor. Intenta más tarde.');
    }
  }

  async function enviarActivacion(e) {
    e.preventDefault();
    var correo = document.getElementById('sp-act-correo').value;
    var contrasena = document.getElementById('sp-act-contrasena').value;
    var pin = document.getElementById('sp-act-pin').value;
    try {
      var r = await fetch(API + '/auth/activar', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ correo: correo, contrasena: contrasena, pin: pin })
      });
      var datos = await r.json();
      if (!r.ok || !datos.ok) { mensaje(datos.error || 'No se pudo activar la cuenta.'); return; }
      mensaje('Cuenta activada. Ya puedes iniciar sesión.', 'success');
      setTimeout(function () { abrirModal('login'); }, 1400);
    } catch (err) {
      mensaje('No se pudo conectar con el servidor. Intenta más tarde.');
    }
  }

  /* ---------------- Botón en la barra de navegación ---------------- */
  function dibujarBoton() {
    // Puede haber más de un contenedor: el de la barra (escritorio) y el del
    // menú móvil de pantalla completa. Se dibujan todos.
    var contenedores = document.querySelectorAll('.sesion-widget');
    if (!contenedores.length) return;
    var u = Sesion.usuario();
    var activa = Sesion.activa() && Boolean(u);

    var enlacePanel = (activa && Sesion.esColaboradorOAdmin())
      ? '<a href="admin/index.html" class="btn btn-secondary btn-sm" title="Solo visible para cuentas invitadas por la administración">' +
        '<i class="fas fa-gauge-high" aria-hidden="true"></i> Panel</a>'
      : '';

    Array.prototype.forEach.call(contenedores, function (cont, indice) {
      var idAbrir = indice === 0 ? ' id="btn-abrir-sesion"' : '';
      if (activa) {
        cont.innerHTML =
          '<span class="sesion-nombre" title="' + esc(u.correo) + '">' +
          '<i class="fas fa-circle-user" aria-hidden="true"></i> ' + esc((u.nombre_completo || '').split(' ')[0]) + '</span>' +
          enlacePanel +
          '<button type="button" class="btn btn-outline-light btn-sm js-cerrar-sesion-publico">Salir</button>';
        cont.querySelector('.js-cerrar-sesion-publico').onclick = Sesion.cerrar;
      } else {
        cont.innerHTML = '<button type="button" class="btn btn-outline-light btn-sm js-abrir-sesion"' + idAbrir + '>' +
          '<i class="fas fa-right-to-bracket" aria-hidden="true"></i> Iniciar sesión</button>';
        cont.querySelector('.js-abrir-sesion').onclick = function () { abrirModal('login'); };
      }
    });
  }

  // nav.js inyecta la barra de forma asíncrona: se espera a que exista.
  document.addEventListener('DOMContentLoaded', function () {
    var intentos = 0;
    var t = setInterval(function () {
      if (document.getElementById('sesion-widget') || ++intentos > 20) {
        clearInterval(t);
        if (Sesion.activa()) { cargarPermisos().then(dibujarBoton); }
        dibujarBoton();
      }
    }, 100);
  });
})();
