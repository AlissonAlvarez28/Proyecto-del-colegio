/**
 * nav.js — Navegación y footer compartidos, I.G.T. Francisco Miranda
 * Se inyecta en #navbar-root y #footer-root. Cada página define
 * <body data-page="deportes"> (u otro id) para marcar el enlace activo.
 * Cargar con <script src="nav.js" defer></script> en el <head>.
 */
(function () {
  'use strict';

  var LOGO = 'imagenes/escudo-igtfm.png';

  var SECCIONES = [
    { id: 'inicio', href: 'inicio.html', icon: 'fa-house', titulo: 'Inicio', desc: 'Presentación y vida institucional' },
    { id: 'oferta', href: 'oferta_academica.html', icon: 'fa-graduation-cap', titulo: 'Oferta Académica', desc: 'Carreras técnicas e inscripción en línea' },
    { id: 'personal', href: 'personal.html', icon: 'fa-user-tie', titulo: 'Personal Docente', desc: 'Autoridades y cuerpo docente' },
    { id: 'estudiantes', href: 'estudiantes.html', icon: 'fa-user-graduate', titulo: 'Estudiantes', desc: 'Horarios de clases y servicios' },
    { id: 'deportes', href: 'deportes.html', icon: 'fa-futbol', titulo: 'Deportes', desc: 'Equipos, torneos y vida deportiva' },
    { id: 'blog', href: 'Blog.html', icon: 'fa-newspaper', titulo: 'Blog', desc: 'Noticias y actualidad institucional' },
    { id: 'compras', href: 'compras.html', icon: 'fa-bag-shopping', titulo: 'Tienda Escolar', desc: 'Uniformes y útiles institucionales' }
  ];

  var FACEBOOK = 'https://www.facebook.com/share/1JbkamZUK5/';
  var INSTAGRAM = 'https://www.instagram.com/igt_franciscomiranda';
  var MAPS = 'https://maps.app.goo.gl/FMNtJXQvkgiUu7Hk7';

  var paginaActual = (document.body.getAttribute('data-page') || '').toLowerCase();

  function esActiva(id) { return id === paginaActual; }

  /* ---------------- NAVBAR ---------------- */
  function megaItemHTML(s) {
    return (
      '<a href="' + s.href + '" class="mega-item' + (esActiva(s.id) ? ' active' : '') + '"' +
      (esActiva(s.id) ? ' aria-current="page"' : '') + '>' +
      '<span class="mega-icon"><i class="fas ' + s.icon + '" aria-hidden="true"></i></span>' +
      '<span><strong>' + s.titulo + '</strong><span class="mega-desc">' + s.desc + '</span></span>' +
      '</a>'
    );
  }

  function navbarHTML() {
    var megaItems = SECCIONES.map(megaItemHTML).join('');
    var inicio = SECCIONES[0];
    var deportes = SECCIONES[4];

    return (
      '<div class="navbar-inner">' +
        '<a href="inicio.html" class="navbar-brand" aria-label="Ir al inicio — I.G.T. Francisco Miranda">' +
          '<img src="' + LOGO + '" alt="Escudo del Instituto Gubernamental Técnico Francisco Miranda" width="42" height="42">' +
          '<span>' +
            '<span class="brand-sub">I.G.T. Francisco Miranda</span>' +
            '<span class="brand-name">Aldea Zambrano, M.D.C.</span>' +
          '</span>' +
        '</a>' +
        '<nav class="navbar-links" aria-label="Navegación principal">' +
          '<a href="' + inicio.href + '" class="navbar-link' + (esActiva('inicio') ? ' active' : '') + '"' + (esActiva('inicio') ? ' aria-current="page"' : '') + '>Inicio</a>' +
          '<div class="mega-wrap" id="megaWrap">' +
            '<button type="button" class="navbar-link mega-trigger" id="megaTrigger" aria-haspopup="true" aria-expanded="false" aria-controls="megaPanel">' +
              'Explorar <i class="fas fa-chevron-down" aria-hidden="true"></i>' +
            '</button>' +
            '<div class="mega-panel" id="megaPanel" role="menu" aria-label="Secciones del sitio">' + megaItems + '</div>' +
          '</div>' +
          '<a href="' + deportes.href + '" class="navbar-link' + (esActiva('deportes') ? ' active' : '') + '"' + (esActiva('deportes') ? ' aria-current="page"' : '') + '>' +
            '<i class="fas fa-futbol" aria-hidden="true"></i> Deportes' +
          '</a>' +
        '</nav>' +
        '<a href="oferta_academica.html" class="btn btn-secondary btn-sm navbar-cta"><i class="fas fa-pen-to-square" aria-hidden="true"></i> Matrícula</a>' +
        '<button type="button" class="hamburger-btn" id="hamburgerBtn" aria-label="Abrir menú de navegación" aria-expanded="false" aria-controls="mobile-menu-root">' +
          '<span></span><span></span><span></span>' +
        '</button>' +
      '</div>'
    );
  }

  /* ---------------- MENÚ MÓVIL ---------------- */
  function mobileLinkHTML(s, i) {
    return (
      '<a href="' + s.href + '" class="mobile-menu-link' + (esActiva(s.id) ? ' active' : '') + '" style="--i:' + i + '"' +
      (esActiva(s.id) ? ' aria-current="page"' : '') + '>' +
      '<span class="mm-icon"><i class="fas ' + s.icon + '" aria-hidden="true"></i></span>' +
      '<span><span>' + s.titulo + '</span><small>' + s.desc + '</small></span>' +
      '</a>'
    );
  }

  function mobileMenuHTML() {
    var links = SECCIONES.map(mobileLinkHTML).join('');
    return (
      '<div class="mobile-menu-top">' +
        '<a href="inicio.html" style="display:flex;align-items:center;gap:.6rem;color:#fff;font-weight:800;">' +
          '<img src="' + LOGO + '" alt="" width="40" height="40">Francisco Miranda' +
        '</a>' +
        '<button type="button" class="mobile-menu-close" id="mobileMenuClose" aria-label="Cerrar menú"><i class="fas fa-xmark" aria-hidden="true"></i></button>' +
      '</div>' +
      '<nav class="mobile-menu-links" aria-label="Navegación móvil">' + links + '</nav>' +
      '<div class="mobile-menu-foot">' +
        '<a href="' + FACEBOOK + '" target="_blank" rel="noopener" aria-label="Facebook del instituto"><i class="fab fa-facebook" aria-hidden="true"></i></a>' +
        '<a href="' + INSTAGRAM + '" target="_blank" rel="noopener" aria-label="Instagram del instituto"><i class="fab fa-instagram" aria-hidden="true"></i></a>' +
      '</div>'
    );
  }

  /* ---------------- FOOTER ---------------- */
  function footerHTML() {
    var year = new Date().getFullYear();
    var enlacesRapidos = SECCIONES.slice(0, 4).map(function (s) {
      return '<li><a href="' + s.href + '">' + s.titulo + '</a></li>';
    }).join('');
    var enlacesResto = SECCIONES.slice(4).map(function (s) {
      return '<li><a href="' + s.href + '">' + s.titulo + '</a></li>';
    }).join('');

    return (
      '<div style="max-width:80rem;margin:0 auto;padding:0 1.25rem;">' +
        '<div class="footer-grid">' +
          '<div>' +
            '<div class="footer-brand">' +
              '<img src="' + LOGO + '" alt="Escudo I.G.T. Francisco Miranda" width="46" height="46">' +
              '<div><strong style="color:#fff;display:block;font-size:1rem;">I.G.T. Francisco Miranda</strong><span style="font-size:.78rem;">Instituto Gubernamental Técnico · Fundado 1988</span></div>' +
            '</div>' +
            '<p style="max-width:32ch;margin:1rem 0 1.1rem;font-size:.83rem;">Estudio, disciplina y trabajo: formando técnicos y personas de bien en Aldea Zambrano.</p>' +
            '<div class="footer-social">' +
              '<a href="' + FACEBOOK + '" target="_blank" rel="noopener" aria-label="Facebook"><i class="fab fa-facebook-f" aria-hidden="true"></i></a>' +
              '<a href="' + INSTAGRAM + '" target="_blank" rel="noopener" aria-label="Instagram"><i class="fab fa-instagram" aria-hidden="true"></i></a>' +
            '</div>' +
          '</div>' +
          '<div><div class="footer-title">Secciones</div><ul style="list-style:none;padding:0;margin:0;display:grid;gap:.55rem;">' + enlacesRapidos + '</ul></div>' +
          '<div><div class="footer-title">Comunidad</div><ul style="list-style:none;padding:0;margin:0;display:grid;gap:.55rem;">' + enlacesResto + '</ul></div>' +
          '<div><div class="footer-title">Contacto</div><ul style="list-style:none;padding:0;margin:0;display:grid;gap:.7rem;font-size:.83rem;">' +
            '<li><i class="fas fa-location-dot" aria-hidden="true" style="color:var(--color-dorado-vivo);margin-right:.4rem;"></i>Aldea Zambrano, M.D.C., Francisco Morazán</li>' +
            '<li><i class="fas fa-phone" aria-hidden="true" style="color:var(--color-dorado-vivo);margin-right:.4rem;"></i>+504 2200-0000</li>' +
            '<li><a href="' + MAPS + '" target="_blank" rel="noopener"><i class="fas fa-map" aria-hidden="true" style="color:var(--color-dorado-vivo);margin-right:.4rem;"></i>Cómo llegar</a></li>' +
          '</ul></div>' +
        '</div>' +
        '<div class="footer-bottom">&copy; ' + year + ' <strong>Instituto Gubernamental Técnico Francisco Miranda</strong> · Aldea Zambrano, M.D.C., Honduras</div>' +
      '</div>'
    );
  }

  /* ---------------- Montaje ----------------
     Las páginas declaran los contenedores semánticos ya con su clase:
     <header id="navbar-root" class="navbar"></header>
     <div id="mobile-menu-root" class="mobile-menu"></div>
     <footer id="footer-root" class="footer"></footer>
     nav.js solo inyecta el contenido interno. */
  var navRoot = document.getElementById('navbar-root');
  var footerRoot = document.getElementById('footer-root');
  var mobileRoot = document.getElementById('mobile-menu-root');

  if (navRoot) navRoot.innerHTML = navbarHTML();
  if (footerRoot) footerRoot.innerHTML = footerHTML();
  if (mobileRoot) mobileRoot.innerHTML = mobileMenuHTML();

  /* ---------------- Interacción: mega-menú ---------------- */
  var megaWrap = document.getElementById('megaWrap');
  var megaTrigger = document.getElementById('megaTrigger');
  var megaPanel = document.getElementById('megaPanel');

  function abrirMega() {
    megaWrap.classList.add('open');
    megaTrigger.setAttribute('aria-expanded', 'true');
  }
  function cerrarMega() {
    megaWrap.classList.remove('open');
    megaTrigger.setAttribute('aria-expanded', 'false');
  }
  if (megaTrigger) {
    megaTrigger.addEventListener('click', function (e) {
      e.stopPropagation();
      megaWrap.classList.contains('open') ? cerrarMega() : abrirMega();
    });
    document.addEventListener('click', function (e) {
      if (megaWrap && !megaWrap.contains(e.target)) cerrarMega();
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape') { cerrarMega(); megaTrigger.blur(); }
    });
  }

  /* ---------------- Interacción: menú móvil ---------------- */
  var hamburgerBtn = document.getElementById('hamburgerBtn');
  var mobileMenu = document.getElementById('mobile-menu-root');
  var mobileMenuClose = document.getElementById('mobileMenuClose');

  function abrirMobile() {
    mobileMenu.classList.add('open');
    hamburgerBtn.classList.add('open');
    hamburgerBtn.setAttribute('aria-expanded', 'true');
    document.body.style.overflow = 'hidden';
  }
  function cerrarMobile() {
    mobileMenu.classList.remove('open');
    hamburgerBtn.classList.remove('open');
    hamburgerBtn.setAttribute('aria-expanded', 'false');
    document.body.style.overflow = '';
  }
  if (hamburgerBtn && mobileMenu) {
    hamburgerBtn.addEventListener('click', function () {
      mobileMenu.classList.contains('open') ? cerrarMobile() : abrirMobile();
    });
    if (mobileMenuClose) mobileMenuClose.addEventListener('click', cerrarMobile);
    mobileMenu.querySelectorAll('.mobile-menu-link').forEach(function (a) {
      a.addEventListener('click', cerrarMobile);
    });
    document.addEventListener('keydown', function (e) {
      if (e.key === 'Escape' && mobileMenu.classList.contains('open')) {
        cerrarMobile();
        hamburgerBtn.focus();
      }
    });
  }

  /* ---------------- Revelado universal al hacer scroll ----------------
     Disponible en TODAS las páginas para cualquier elemento con clase
     .reveal (variantes: reveal-up, reveal-left, reveal-right, reveal-zoom).
     Páginas con animaciones propias (deportes.js, inicio.js) implementan
     su propia copia de esta lógica junto a sus otras interacciones. */
  var prefersReducedGlobal = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var revealElsGlobales = document.querySelectorAll('.reveal:not([data-reveal-managed])');
  if (revealElsGlobales.length) {
    if (prefersReducedGlobal) {
      revealElsGlobales.forEach(function (el) { el.classList.add('visible'); });
    } else {
      var globalRevealObserver = new IntersectionObserver(function (entries) {
        entries.forEach(function (entry) {
          if (!entry.isIntersecting) return;
          var el = entry.target;
          if (!el.style.getPropertyValue('--stagger')) {
            var hermanos = Array.prototype.filter.call(el.parentElement.children, function (c) {
              return c.classList.contains('reveal');
            });
            el.style.setProperty('--stagger', (hermanos.indexOf(el) * 70) + 'ms');
          }
          el.classList.add('visible');
          globalRevealObserver.unobserve(el);
        });
      }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });
      revealElsGlobales.forEach(function (el) { globalRevealObserver.observe(el); });
    }
  }

  /* ---------------- Barra de progreso de scroll ---------------- */
  var barra = document.getElementById('progresoScroll');
  function actualizarProgreso() {
    if (!barra) return;
    var alto = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    var pct = alto > 0 ? (window.scrollY / alto) * 100 : 0;
    barra.style.width = pct + '%';
  }
  window.addEventListener('scroll', actualizarProgreso, { passive: true });
  window.addEventListener('resize', actualizarProgreso);
  actualizarProgreso();
})();