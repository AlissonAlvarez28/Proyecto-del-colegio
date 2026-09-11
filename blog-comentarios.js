/**
 * blog-comentarios.js — Integra los comentarios del Blog con la API.
 *
 * REGLA DEFINIDA EN EL PROYECTO: comentar exige cuenta.
 * Esta es la cara pública de la institución, así que no se permiten
 * comentarios anónimos sin identificar. Quien no tenga sesión ve una
 * invitación a iniciarla en lugar del formulario.
 *
 * El anonimato SÍ existe, pero es solo ante el público: quien comenta
 * puede pedir que su nombre no aparezca, y en su lugar se muestra un
 * descriptor ("Padre de familia"). La administración siempre puede ver
 * quién escribió qué.
 *
 * Si el backend no responde, se conserva el comportamiento anterior
 * (comentarios guardados en el navegador), para que el sitio nunca
 * quede roto durante una demostración sin conexión.
 */
(function () {
  'use strict';

  var API = window.IGTFM_API_URL || 'http://localhost:3000/api';
  // Publicación a la que se asocian los comentarios generales del blog.
  var PUBLICACION_ID = null;
  var apiDisponible = false;

  function esc(t) {
    return String(t == null ? '' : t).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' }[c];
    });
  }

  /** Reemplaza el formulario según haya o no sesión iniciada. */
  function actualizarFormulario() {
    var form = document.getElementById('form-comentario');
    var contenedor = form ? form.parentElement : null;
    if (!contenedor) return;

    var sesion = window.IGTFMSesion;
    var hayCuenta = sesion && sesion.activa();

    var aviso = document.getElementById('aviso-sesion-comentarios');
    if (aviso) aviso.remove();

    if (!hayCuenta && apiDisponible) {
      // Sin sesión: se oculta el formulario y se invita a entrar.
      form.style.display = 'none';
      var bloque = document.createElement('div');
      bloque.id = 'aviso-sesion-comentarios';
      bloque.className = 'bg-slate-50 p-6 rounded-2xl border border-slate-200 text-center';
      bloque.innerHTML =
        '<i class="fa-solid fa-comments text-3xl text-primary mb-2" aria-hidden="true"></i>' +
        '<p class="font-bold text-slate-900 mb-1">Inicia sesión para comentar</p>' +
        '<p class="text-xs text-slate-600 mb-4">Las cuentas se crean por invitación de la administración del instituto.</p>' +
        '<button type="button" class="btn btn-primary btn-sm" id="btn-login-comentario">' +
        '<i class="fa-solid fa-right-to-bracket" aria-hidden="true"></i> Iniciar sesión</button>';
      form.parentElement.insertBefore(bloque, form);
      var btn = document.getElementById('btn-login-comentario');
      if (btn) btn.onclick = function () {
        var abrir = document.getElementById('btn-abrir-sesion') || document.querySelector('.js-abrir-sesion');
        if (abrir) abrir.click();
      };
      return;
    }

    // Con sesión: el nombre se toma de la cuenta, no se escribe a mano.
    form.style.display = '';
    var campoNombre = document.getElementById('nombre-usuario');
    if (campoNombre && hayCuenta) {
      var u = sesion.usuario();
      campoNombre.value = u ? u.nombre_completo : '';
      campoNombre.readOnly = true;
      campoNombre.classList.add('bg-slate-100');
    }

    // Casilla de anonimato ante el público (solo si hay API).
    if (apiDisponible && !document.getElementById('comentario-anonimo')) {
      var wrap = document.createElement('label');
      wrap.className = 'flex items-center gap-2 text-xs text-slate-600 font-semibold';
      wrap.innerHTML =
        '<input type="checkbox" id="comentario-anonimo"> ' +
        'Publicar sin mostrar mi nombre (la administración igual podrá verlo)';
      form.insertBefore(wrap, form.querySelector('button[type="submit"]') || form.lastElementChild);
    }
  }

  /** Dibuja los comentarios que vienen de la API. */
  function pintarComentarios(datos) {
    var lista = document.getElementById('lista-comentarios');
    if (!lista) return;

    if (!datos.length) {
      lista.innerHTML = '<p class="text-sm text-slate-500 text-center py-6">Todavía no hay comentarios. ¡Sé el primero!</p>';
      return;
    }

    lista.innerHTML = datos.map(function (c) {
      var iniciales = (c.autor || '?').split(' ').map(function (p) { return p[0]; }).slice(0, 2).join('');
      return '<div class="bg-white p-4 rounded-2xl border border-slate-200 flex gap-3">' +
        '<div class="w-10 h-10 rounded-full bg-primary text-white flex items-center justify-center font-black text-sm shrink-0">' +
        esc(iniciales.toUpperCase()) + '</div>' +
        '<div class="min-w-0">' +
        '<div class="flex items-center gap-2 flex-wrap">' +
        '<span class="font-bold text-sm text-slate-900">' + esc(c.autor) + '</span>' +
        (c.rol_mostrado ? '<span class="text-[10px] font-bold px-2 py-0.5 rounded-full bg-slate-200 text-slate-800">' + esc(c.rol_mostrado) + '</span>' : '') +
        '</div>' +
        '<p class="text-sm text-slate-600 mt-1">' + esc(c.mensaje) + '</p>' +
        '</div></div>';
    }).join('');
  }

  /** Envía el comentario a la API. Devuelve true si lo logró. */
  async function enviarAComentariosApi(mensaje, rol) {
    var sesion = window.IGTFMSesion;
    if (!sesion || !sesion.activa() || !PUBLICACION_ID) return false;

    var anonimo = document.getElementById('comentario-anonimo');
    var esAnonimo = anonimo ? anonimo.checked : false;

    try {
      var r = await fetch(API + '/publicaciones/' + PUBLICACION_ID + '/comentarios', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: 'Bearer ' + sesion.token()
        },
        body: JSON.stringify({
          mensaje: mensaje,
          rol_mostrado: rol,
          es_anonimo: esAnonimo,
          descriptor_publico: esAnonimo ? rol : null
        })
      });
      if (!r.ok) {
        var err = await r.json().catch(function () { return {}; });
        alert(err.error || 'No se pudo publicar el comentario.');
        return false;
      }
      await cargar();
      return true;
    } catch (e) {
      return false;
    }
  }
  window.IGTFMEnviarComentario = enviarAComentariosApi;

  /** Carga publicación y comentarios desde la API. */
  async function cargar() {
    try {
      var rp = await fetch(API + '/publicaciones?limite=1');
      if (!rp.ok) return;
      var pubs = await rp.json();
      if (!pubs.datos || !pubs.datos.length) return;

      PUBLICACION_ID = pubs.datos[0].id;
      apiDisponible = true;

      var rc = await fetch(API + '/publicaciones/' + PUBLICACION_ID + '/comentarios');
      if (rc.ok) {
        var datos = await rc.json();
        pintarComentarios(datos.datos || []);
      }
      actualizarFormulario();
    } catch (e) {
      // Sin API: el blog sigue funcionando con localStorage, como antes.
      apiDisponible = false;
    }
  }

  document.addEventListener('DOMContentLoaded', function () {
    setTimeout(cargar, 300);
  });
  window.addEventListener('igtfm:sesion-cambio', function () {
    actualizarFormulario();
    cargar();
  });
})();
