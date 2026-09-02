document.addEventListener('DOMContentLoaded', function () {
  var prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  /* ================= Scroll reveal (stagger + variantes) ================= */
  var revealEls = document.querySelectorAll('.reveal');
  if (prefersReduced) {
    revealEls.forEach(function (el) { el.classList.add('visible'); });
  } else {
    var revealObserver = new IntersectionObserver(function (entries) {
      entries.forEach(function (entry) {
        if (!entry.isIntersecting) return;
        var el = entry.target;
        if (!el.style.getPropertyValue('--stagger')) {
          var hermanos = Array.prototype.filter.call(el.parentElement.children, function (c) {
            return c.classList.contains('reveal');
          });
          var idx = hermanos.indexOf(el);
          el.style.setProperty('--stagger', (idx * 70) + 'ms');
        }
        el.classList.add('visible');
        revealObserver.unobserve(el);
      });
    }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });
    revealEls.forEach(function (el) { revealObserver.observe(el); });
  }

  /* ================= Contadores animados ================= */
  var counters = document.querySelectorAll('.stat-num[data-count]');
  function animarContador(el) {
    var target = parseInt(el.getAttribute('data-count'), 10);
    var suffix = el.getAttribute('data-suffix') || '';
    if (prefersReduced) { el.textContent = target + suffix; return; }
    var inicio = null;
    var duracion = 1400;
    function paso(ts) {
      if (!inicio) inicio = ts;
      var p = Math.min((ts - inicio) / duracion, 1);
      var suavizado = 1 - Math.pow(1 - p, 3);
      el.textContent = Math.floor(suavizado * target) + suffix;
      if (p < 1) requestAnimationFrame(paso);
      else el.textContent = target + suffix;
    }
    requestAnimationFrame(paso);
  }
  var counterObserver = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) { animarContador(entry.target); counterObserver.unobserve(entry.target); }
    });
  }, { threshold: 0.5 });
  counters.forEach(function (el) { counterObserver.observe(el); });

  /* ================= Línea de tiempo progresiva ================= */
  var timeline = document.getElementById('timeline');
  var timelineProgress = document.getElementById('timelineProgress');
  var timelineItems = document.querySelectorAll('.timeline-item');

  function actualizarTimeline() {
    if (!timeline || !timelineProgress) return;
    var rect = timeline.getBoundingClientRect();
    var visto = window.innerHeight * 0.7 - rect.top;
    var pct = Math.max(0, Math.min(1, visto / rect.height));
    timelineProgress.style.height = (pct * 100) + '%';
  }
  window.addEventListener('scroll', actualizarTimeline, { passive: true });
  window.addEventListener('resize', actualizarTimeline);
  actualizarTimeline();

  var itemObserver = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) entry.target.classList.add('visible');
    });
  }, { threshold: 0.4 });
  timelineItems.forEach(function (el) { itemObserver.observe(el); });

  /* ================= Carrusel de testimonios ================= */
  var track = document.getElementById('carTrack');
  var dotsWrap = document.getElementById('carDots');
  var prevBtn = document.getElementById('carPrev');
  var nextBtn = document.getElementById('carNext');

  if (track && dotsWrap) {
    var slides = track.children;
    var total = slides.length;
    var idx = 0;
    var autoplayTimer = null;
    var carouselRoot = track.closest('.carousel');

    for (var i = 0; i < total; i++) {
      var dot = document.createElement('button');
      dot.type = 'button';
      dot.className = 'carousel-dot' + (i === 0 ? ' active' : '');
      dot.setAttribute('aria-label', 'Ir al testimonio ' + (i + 1));
      (function (n) { dot.addEventListener('click', function () { irA(n); reiniciarAutoplay(); }); })(i);
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
    function reiniciarAutoplay() {
      if (autoplayTimer) clearInterval(autoplayTimer);
      if (!prefersReduced) autoplayTimer = setInterval(siguiente, 6000);
    }

    if (nextBtn) nextBtn.addEventListener('click', function () { siguiente(); reiniciarAutoplay(); });
    if (prevBtn) prevBtn.addEventListener('click', function () { anterior(); reiniciarAutoplay(); });

    if (carouselRoot) {
      carouselRoot.addEventListener('mouseenter', function () { if (autoplayTimer) clearInterval(autoplayTimer); });
      carouselRoot.addEventListener('mouseleave', reiniciarAutoplay);
      carouselRoot.setAttribute('tabindex', '0');
      carouselRoot.addEventListener('keydown', function (e) {
        if (e.key === 'ArrowLeft') { anterior(); reiniciarAutoplay(); }
        if (e.key === 'ArrowRight') { siguiente(); reiniciarAutoplay(); }
      });
    }

    var touchStartX = 0;
    track.addEventListener('touchstart', function (e) { touchStartX = e.touches[0].clientX; }, { passive: true });
    track.addEventListener('touchend', function (e) {
      var dx = e.changedTouches[0].clientX - touchStartX;
      if (Math.abs(dx) > 40) { dx > 0 ? anterior() : siguiente(); reiniciarAutoplay(); }
    }, { passive: true });

    reiniciarAutoplay();
  }

  /* ================= Cuenta regresiva — III Copa Amistad ================= */
  var cd = document.getElementById('countdown');
  if (cd) {
    var objetivo = new Date(cd.getAttribute('data-target')).getTime();
    var elDias = document.getElementById('cdDias');
    var elHoras = document.getElementById('cdHoras');
    var elMin = document.getElementById('cdMin');
    function tick() {
      var diff = Math.max(0, objetivo - Date.now());
      var dias = Math.floor(diff / 86400000);
      var horas = Math.floor((diff % 86400000) / 3600000);
      var min = Math.floor((diff % 3600000) / 60000);
      if (elDias) elDias.textContent = String(dias).padStart(2, '0');
      if (elHoras) elHoras.textContent = String(horas).padStart(2, '0');
      if (elMin) elMin.textContent = String(min).padStart(2, '0');
    }
    tick();
    setInterval(tick, 30000);
  }

  /* ================= Parallax sutil del hero ================= */
  var heroImg = document.getElementById('heroParallax');
  if (heroImg && !prefersReduced) {
    window.addEventListener('scroll', function () {
      var sc = window.scrollY;
      if (sc < window.innerHeight * 1.3) {
        heroImg.style.transform = 'translateY(' + (sc * 0.18) + 'px)';
      }
    }, { passive: true });
  }
});