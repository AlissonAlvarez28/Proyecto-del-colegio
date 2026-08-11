// Función para cambiar de sección dinámicamente sin recargar la página
function navegarA(sectionId) {
    // 1. Ocultar todas las secciones
    const secciones = document.querySelectorAll('.content-section');
    secciones.forEach(sec => sec.classList.remove('active-section'));

    // 2. Mostrar la sección seleccionada
    const seccionObjetivo = document.getElementById(`sec-${sectionId}`);
    if (seccionObjetivo) {
        seccionObjetivo.classList.add('active-section');
    }

    // 3. Actualizar la pestaña activa en la barra de navegación
    const navLinks = document.querySelectorAll('.nav-btn');
    navLinks.forEach(link => {
        if (link.getAttribute('data-section') === sectionId) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });

    // 4. Si el menú móvil está desplegado, cerrarlo automáticamente
    const navbarCollapse = document.getElementById('menuPrincipal');
    if (navbarCollapse.classList.contains('show')) {
        const bsCollapse = new bootstrap.Collapse(navbarCollapse);
        bsCollapse.hide();
    }

    // 5. Desplazar la pantalla hacia arriba suavemente
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Configurar los clicks en el menú de navegación
document.addEventListener('DOMContentLoaded', () => {
    const navButtons = document.querySelectorAll('.nav-btn');
    navButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            e.preventDefault();
            const section = btn.getAttribute('data-section');
            navegarA(section);
        });
    });
});