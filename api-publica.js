/**
 * api-publica.js — Conecta el sitio público con la API institucional.
 *
 * PRINCIPIO CLAVE: degradación elegante.
 * Si el backend no está corriendo (por ejemplo, durante una presentación
 * sin internet, o si alguien abre el HTML con doble clic), el sitio NO se
 * rompe: simplemente se queda con el contenido que ya está escrito en el
 * HTML. Todo lo dinámico solo REEMPLAZA contenido existente, nunca lo borra
 * antes de tener la respuesta.
 *
 * Cargar con: <script src="api-publica.js" defer></script>
 */
(function () {
  'use strict';

  var API = window.IGTFM_API_URL || 'http://localhost:3000/api';

  /* ---------------- Utilidades ---------------- */

  /** Pide datos a la API. Devuelve null si algo falla (nunca lanza error). */
  async function pedir(ruta) {
    try {
      var r = await fetch(API + ruta, { headers: { Accept: 'application/json' } });
      if (!r.ok) return null;
      return await r.json();
    } catch (e) {
      // Backend apagado o sin red: el sitio sigue con su contenido estático.
      return null;
    }
  }

  /** Escapa texto antes de insertarlo como HTML (evita inyección de scripts). */
  function esc(texto) {
    if (texto === null || texto === undefined) return '';
    return String(texto)
      .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;').replace(/'/g, '&#039;');
  }

  function formatearFecha(iso) {
    if (!iso) return '';
    var d = new Date(iso);
    if (isNaN(d)) return '';
    return d.toLocaleDateString('es-HN', { day: 'numeric', month: 'long', year: 'numeric' });
  }

  /**
   * Marca como visible cualquier .reveal / .timeline-item recién insertado.
   *
   * El observador de scroll de deportes.js solo vigila los elementos que
   * existían al cargar la página. Todo lo que la API inserta DESPUÉS nunca
   * pasa frente a ese observador, así que se queda con opacity:0 para
   * siempre (esa era la causa de que el contenido "desapareciera"). Como
   * este contenido ya llegó — no hace falta esperar a que el usuario haga
   * scroll para mostrarlo — se marca visible de una vez.
   */
  function hacerVisibleInmediato(contenedor) {
    contenedor.querySelectorAll('.reveal').forEach(function (el) {
      el.classList.add('visible');
    });
    contenedor.querySelectorAll('.timeline-item').forEach(function (el) {
      el.classList.add('visible');
    });
  }

  /**
   * Reconstruye el carrusel de testimonios después de reemplazar sus
   * slides. deportes.js configuró los botones prev/next para la cantidad
   * ORIGINAL de testimonios (4, los de ejemplo); si la base de datos real
   * tiene una cantidad distinta, esa lógica vieja queda desincronizada.
   * Se clonan los botones (así se descartan sus listeners anteriores, sin
   * arriesgarse a que ambas versiones respondan a la vez) y se arma todo
   * de nuevo con los datos reales.
   */
  function reiniciarCarrusel() {
    var track = document.getElementById('carTrack');
    var dotsWrap = document.getElementById('carDots');
    var prevBtn = document.getElementById('carPrev');
    var nextBtn = document.getElementById('carNext');
    if (!track || !dotsWrap) return;

    var prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    var total = track.children.length;
    var idx = 0;
    var autoplayTimer = null;

    dotsWrap.innerHTML = '';
    for (var i = 0; i < total; i++) {
      var dot = document.createElement('button');
      dot.type = 'button';
      dot.className = 'carousel-dot' + (i === 0 ? ' active' : '');
      dot.setAttribute('aria-label', 'Ir al testimonio ' + (i + 1));
      (function (n) { dot.addEventListener('click', function () { irA(n); reiniciar(); }); })(i);
      dotsWrap.appendChild(dot);
    }
    var dots = dotsWrap.children;

    function irA(n) {
      idx = (n + total) % total;
      track.style.transform = 'translateX(-' + (idx * 100) + '%)';
      Array.prototype.forEach.call(dots, function (d, di) { d.classList.toggle('active', di === idx); });
    }
    function siguiente() { irA(idx + 1); }
    function anterior() { irA(idx - 1); }
    function reiniciar() {
      if (autoplayTimer) clearInterval(autoplayTimer);
      if (!prefersReduced) autoplayTimer = setInterval(siguiente, 6000);
    }

    // Clonar los botones descarta cualquier listener que deportes.js ya
    // les hubiera puesto para la cantidad anterior de slides.
    if (prevBtn) {
      var prevNuevo = prevBtn.cloneNode(true);
      prevBtn.parentNode.replaceChild(prevNuevo, prevBtn);
      prevNuevo.addEventListener('click', function () { anterior(); reiniciar(); });
    }
    if (nextBtn) {
      var nextNuevo = nextBtn.cloneNode(true);
      nextBtn.parentNode.replaceChild(nextNuevo, nextBtn);
      nextNuevo.addEventListener('click', function () { siguiente(); reiniciar(); });
    }

    irA(0);
    reiniciar();
  }

  var pagina = (document.body.getAttribute('data-page') || '').toLowerCase();

  /* ============================================================
     DEPORTES
     ============================================================ */
  async function cargarDeportes() {
    // --- Estadísticas (contadores animados) ---
    var est = await pedir('/estadisticas-deportivas');
    if (est) {
      var mapa = {
        'anios_compitiendo': est.manuales.anios_compitiendo,
        'estudiantes_en_deporte': est.manuales.estudiantes_en_deporte,
        'estudiantes_en_selecciones': est.manuales.estudiantes_en_selecciones,
        'competencias_formales': est.manuales.competencias_formales,
        'disciplinas': est.calculadas.disciplinas,
        'equipos': est.calculadas.equipos
      };
      document.querySelectorAll('.stat-num[data-api]').forEach(function (el) {
        var valor = mapa[el.getAttribute('data-api')];
        if (valor === null || valor === undefined) return;
        el.setAttribute('data-count', valor);
        // El contador pudo haberse animado ya con el valor estático del HTML
        // (si esa sección ya estaba visible cuando cargó la página, antes de
        // que la API respondiera). Se escribe el valor real directamente
        // para no dejarlo pegado en el número viejo.
        var suffix = el.getAttribute('data-suffix') || '';
        el.textContent = valor + suffix;
      });
    }

    // --- Línea de tiempo ---
    var hitos = await pedir('/hitos-historicos');
    var timeline = document.getElementById('timeline');
    if (hitos && hitos.datos.length && timeline) {
      var progreso = timeline.querySelector('.timeline-progress');
      timeline.innerHTML = (progreso ? progreso.outerHTML : '') + hitos.datos.map(function (h) {
        return '<div class="timeline-item reveal reveal-up">' +
          '<span class="timeline-dot" aria-hidden="true"></span>' +
          '<span class="timeline-year">' + esc(h.anio_periodo) + '</span>' +
          '<h3 class="text-lg font-extrabold mb-1">' + esc(h.titulo) + '</h3>' +
          '<p class="text-slate-600 text-sm">' + esc(h.descripcion) + '</p>' +
          (h.imagen_url ? '<img src="' + esc(h.imagen_url) + '" alt="" loading="lazy" style="border-radius:1rem;margin-top:.9rem;box-shadow:var(--shadow-md);">' : '') +
          '</div>';
      }).join('');
      hacerVisibleInmediato(timeline);
    }

    // --- Logros ---
    var logros = await pedir('/logros');
    var vitrina = document.querySelector('.trophy-grid');
    if (logros && logros.datos.length && vitrina) {
      vitrina.innerHTML = logros.datos.map(function (l) {
        return '<div class="trophy-card reveal reveal-up">' +
          '<span class="trophy-icon"><i class="fas fa-trophy" aria-hidden="true"></i></span>' +
          '<div><h3>' + esc(l.titulo) + '</h3><p>' + esc(l.descripcion) + '</p>' +
          '<span class="trophy-tag">' + esc(l.etiqueta || l.anio) + '</span></div></div>';
      }).join('');
      hacerVisibleInmediato(vitrina);
    }

    // --- Próximas competencias ---
    var eventos = await pedir('/eventos-deportivos?estado=proximo');
    var fixture = document.querySelector('.fixture-grid');
    if (eventos && eventos.datos.length && fixture) {
      fixture.innerHTML = eventos.datos.map(function (e) {
        var destacado = e.destacado ? ' destacado' : '';
        return '<div class="fixture-card' + destacado + ' reveal reveal-up">' +
          '<div class="fixture-teams">' +
            '<div class="fixture-team"><span class="fixture-crest">FM</span><span>' + esc(e.equipo || 'I.G.T.F.M.') + '</span></div>' +
            '<span class="fixture-vs">VS</span>' +
            '<div class="fixture-team"><span class="fixture-crest rival"><i class="fas fa-shield-halved" aria-hidden="true"></i></span>' +
            '<span>' + esc(e.rival || 'Por definir') + '</span></div>' +
          '</div>' +
          '<div class="fixture-meta"><span class="fixture-badge">' + esc(e.categoria) + '</span>' +
          '<span>' + formatearFecha(e.fecha) + '</span></div>' +
          '</div>';
      }).join('');
      hacerVisibleInmediato(fixture);
    }

    // --- Disciplinas ---
    var disc = await pedir('/disciplinas');
    var grid = document.querySelector('.discipline-grid');
    if (disc && disc.datos.length && grid) {
      grid.innerHTML = disc.datos.map(function (d) {
        return '<div class="discipline-card reveal reveal-up">' +
          '<span class="discipline-icon"><i class="fas ' + esc(d.icono || 'fa-medal') + '" aria-hidden="true"></i></span>' +
          '<h3>' + esc(d.nombre) + '</h3><p>' + esc(d.descripcion || '') + '</p></div>';
      }).join('');
      hacerVisibleInmediato(grid);
    }

    // --- Testimonios (respetan el anonimato definido en el backend) ---
    var test = await pedir('/testimonios');
    var track = document.getElementById('carTrack');
    if (test && test.datos.length && track) {
      track.innerHTML = test.datos.map(function (t) {
        return '<div class="carousel-slide"><div class="testimonial-card">' +
          '<i class="fas fa-quote-left" aria-hidden="true"></i>' +
          '<p class="quote">' + esc(t.cita) + '</p>' +
          '<p class="author">' + esc(t.autor) + '</p>' +
          '<p class="role">' + esc(t.rol_mostrado || '') + '</p>' +
          '</div></div>';
      }).join('');
      hacerVisibleInmediato(track.closest('.carousel') || track);
      reiniciarCarrusel();
    }

    // --- Proyectos futuros (solo los aprobados llegan del backend) ---
    var proy = await pedir('/proyectos-futuros');
    var contProy = document.querySelector('#instalaciones .grid.sm\\:grid-cols-3');
    if (proy && proy.datos.length && contProy) {
      var etiquetaEstado = {
        aprobado: 'Proyectado', en_gestion: 'En gestión', completado: 'Completado'
      };
      contProy.innerHTML = proy.datos.map(function (p) {
        return '<div class="future-card reveal reveal-up">' +
          '<span class="estado"><i class="fas fa-gear" aria-hidden="true"></i> ' +
          esc(etiquetaEstado[p.estado] || p.estado) + '</span>' +
          '<h4 class="font-extrabold text-sm mb-1">' + esc(p.titulo) + '</h4>' +
          '<p class="text-xs text-slate-600">' + esc(p.descripcion) + '</p></div>';
      }).join('');
      hacerVisibleInmediato(contProy);
    }
  }

  /* ============================================================
     PERSONAL (directorio)
     ============================================================ */
  async function cargarPersonal() {
    var r = await pedir('/personal');
    if (!r || !r.datos.length) return;

    // El buscador y el modal de personal.html trabajan sobre la variable
    // global `personal`. Se reemplaza su contenido con los datos reales de
    // la base y se vuelve a dibujar, sin tocar esa lógica existente.
    if (typeof window.personal !== 'undefined' && Array.isArray(window.personal)) {
      window.personal.length = 0;
      r.datos.forEach(function (p) {
        window.personal.push({
          nombre: p.nombre_completo,
          cargo: p.cargo,
          titulos: p.biografia || '',
          materia: p.materia || '',
          experiencia: p.anios_experiencia ? p.anios_experiencia + ' años en la institución' : '',
          categoria: (p.departamento || '').toLowerCase(),
          foto: p.foto_url || '',
          correo: p.correo || '',
          ubicacion: p.ubicacion || '',
          horario: p.horario_atencion || ''
        });
      });
      if (typeof window.renderizarPersonal === 'function') window.renderizarPersonal();
    }
  }

  /* ============================================================
     BLOG (publicaciones)
     ============================================================ */
  async function cargarBlog() {
    var r = await pedir('/publicaciones');
    if (!r || !r.datos.length) return;

    var contenedor = document.querySelector('[data-api-publicaciones]');
    if (!contenedor) return;

    contenedor.innerHTML = r.datos.map(function (p) {
      return '<article class="card border-gray-200 p-0 overflow-hidden flex flex-col mb-6">' +
        (p.imagen_portada ? '<img src="' + esc(p.imagen_portada) + '" alt="" class="w-full h-48 object-cover" loading="lazy">' : '') +
        '<div class="p-6">' +
        '<span class="text-xs text-gray-500 font-semibold">' + formatearFecha(p.fecha_publicacion) +
        (p.autor ? ' · ' + esc(p.autor) : '') + '</span>' +
        '<h3 class="text-xl font-bold text-gray-900 mt-2 mb-3">' + esc(p.titulo) + '</h3>' +
        '<p class="text-gray-600 text-sm">' + esc(p.resumen || '') + '</p>' +
        '</div></article>';
    }).join('');
  }

  /* ============================================================
     INICIO (noticias destacadas)
     ============================================================ */
  async function cargarInicio() {
    var r = await pedir('/publicaciones?destacado=true&limite=3');
    var contenedor = document.querySelector('[data-api-noticias]');
    if (!r || !r.datos.length || !contenedor) return;

    contenedor.innerHTML = r.datos.map(function (p) {
      return '<article class="card border-gray-200 p-0 overflow-hidden flex flex-col reveal reveal-up">' +
        (p.imagen_portada
          ? '<img src="' + esc(p.imagen_portada) + '" alt="" class="h-48 w-full object-cover" loading="lazy">'
          : '<div class="h-48 flex items-center justify-center" style="background:linear-gradient(135deg,var(--color-vino),var(--color-azul-marino));">' +
            '<i class="fa-solid fa-newspaper" aria-hidden="true" style="font-size:2.75rem;color:var(--color-dorado-vivo);opacity:.9;"></i></div>') +
        '<div class="p-6 flex-grow flex flex-col">' +
        '<span class="text-xs text-gray-500 font-semibold"><i class="fa-regular fa-calendar mr-1" aria-hidden="true"></i> ' +
        formatearFecha(p.fecha_publicacion) + '</span>' +
        '<h3 class="text-xl font-bold text-gray-900 mt-2 mb-3">' + esc(p.titulo) + '</h3>' +
        '<p class="text-gray-600 text-sm flex-grow">' + esc(p.resumen || '') + '</p>' +
        '<a href="Blog.html" class="mt-4 text-xs font-bold text-primary hover:underline">Leer más en el Blog →</a>' +
        '</div></article>';
    }).join('');
    hacerVisibleInmediato(contenedor);
  }

  /* ============================================================
     TIENDA (productos)
     ============================================================ */
  async function cargarProductos() {
    var r = await pedir('/productos');
    var contenedor = document.querySelector('[data-api-productos]');
    if (!r || !r.datos.length || !contenedor) return;

    contenedor.innerHTML = r.datos.map(function (p) {
      var precio = Number(p.precio).toFixed(2);
      return '<div class="card border-gray-200 p-5 flex flex-col">' +
        (p.foto_url ? '<img src="' + esc(p.foto_url) + '" alt="" class="w-full h-36 object-cover rounded-lg mb-3" loading="lazy">' : '') +
        '<h3 class="font-bold text-gray-900">' + esc(p.nombre) + '</h3>' +
        '<p class="text-xs text-gray-600 flex-grow mt-1">' + esc(p.descripcion || '') + '</p>' +
        '<span class="block font-black text-primary text-lg mt-3">L. ' + precio + '</span>' +
        '<button class="btn btn-primary btn-sm mt-3 justify-center" ' +
        'onclick="comprarDirecto(\'' + esc(p.nombre).replace(/'/g, "\\'") + '\', ' + precio + ')">' +
        '<i class="fa-solid fa-cart-plus"></i> Comprar</button>' +
        '</div>';
    }).join('');
  }

  /* ============================================================
     OFERTA ACADÉMICA (carreras y secciones)
     ============================================================ */
  async function cargarCarreras() {
    var r = await pedir('/carreras');
    if (!r || !r.datos.length) return;

    // Rellena el <select> del modal de inscripción con las carreras reales.
    var selectCurso = document.getElementById('campo-curso-select');
    if (selectCurso) {
      selectCurso.innerHTML = r.datos.map(function (c) {
        return '<option value="' + esc(c.nombre) + '" data-id="' + c.id + '">' + esc(c.nombre) + '</option>';
      }).join('');

      // Al cambiar de carrera, se actualizan sus secciones reales.
      selectCurso.addEventListener('change', function () {
        var carrera = r.datos.find(function (c) { return c.nombre === selectCurso.value; });
        var selectSec = document.getElementById('campo-seccion-modal');
        if (carrera && selectSec && carrera.secciones.length) {
          selectSec.innerHTML = carrera.secciones.map(function (s) {
            var etiqueta = s.nombre + ' (Jornada ' + (s.jornada === 'matutina' ? 'Mañana' : 'Tarde') + ')';
            return '<option value="' + esc(etiqueta) + '">' + esc(etiqueta) + '</option>';
          }).join('');
        }
      });
    }
  }

  /* ============================================================
     ESTUDIANTES (horarios)
     ============================================================ */
  async function cargarHorarios() {
    var r = await pedir('/secciones');
    var selector = document.getElementById('selector-curso');
    if (!r || !r.datos.length || !selector) return;

    selector.innerHTML = '<option value="">— Elige tu sección —</option>' +
      r.datos.map(function (s) {
        return '<option value="' + s.id + '">' + esc(s.carrera) + ' · ' + esc(s.nombre) + '</option>';
      }).join('');

    selector.addEventListener('change', async function () {
      if (!selector.value) return;
      var h = await pedir('/secciones/' + selector.value + '/horarios');
      var cont = document.getElementById('contenedor-horario-tabla');
      if (!h || !cont) return;

      var dias = ['lunes', 'martes', 'miercoles', 'jueves', 'viernes'];
      var encabezado = '<tr><th>Hora</th>' + dias.map(function (d) {
        return '<th style="text-transform:capitalize;">' + d + '</th>';
      }).join('') + '</tr>';

      var filas = h.horario.map(function (f) {
        return '<tr><td class="font-bold">' + esc(f.hora) + '</td>' +
          dias.map(function (d) { return '<td>' + esc(f[d] || '—') + '</td>'; }).join('') + '</tr>';
      }).join('');

      cont.innerHTML = '<h3 class="text-lg font-bold mb-3">' + esc(h.seccion.carrera) + ' · ' +
        esc(h.seccion.nombre) + '</h3>' +
        '<div class="admin-table-wrap print-area"><table class="admin-table w-full">' +
        '<thead>' + encabezado + '</thead><tbody>' + filas + '</tbody></table></div>';
    });
  }

  /* ============================================================
     Arranque según la página
     ============================================================ */
  document.addEventListener('DOMContentLoaded', function () {
    if (pagina === 'deportes') cargarDeportes();
    if (pagina === 'personal') cargarPersonal();
    if (pagina === 'blog') cargarBlog();
    if (pagina === 'inicio') cargarInicio();
    if (pagina === 'compras') cargarProductos();
    if (pagina === 'oferta') cargarCarreras();
    if (pagina === 'estudiantes') cargarHorarios();
  });
})();
