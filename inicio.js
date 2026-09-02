document.addEventListener('DOMContentLoaded', function () {
  var prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  var revealEls = document.querySelectorAll('.reveal');

  if (prefersReduced) {
    revealEls.forEach(function (el) { el.classList.add('visible'); });
    return;
  }

  var observer = new IntersectionObserver(function (entries) {
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
      observer.unobserve(el);
    });
  }, { threshold: 0.15, rootMargin: '0px 0px -40px 0px' });

  revealEls.forEach(function (el) { observer.observe(el); });
});