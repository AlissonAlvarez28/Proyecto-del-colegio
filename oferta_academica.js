const seccionesPorCurso = {
  "7mo Grado": [
    "Sección 1 (Jornada Mañana)",
    "Sección 2 (Jornada Mañana)",
    "Sección 3 (Jornada Mañana)",
    "Sección 4 (Jornada Tarde)"
  ],
  "8vo Grado": [
    "Sección 1 (Jornada Mañana)",
    "Sección 2 (Jornada Mañana)",
    "Sección 3 (Jornada Mañana)"
  ],
  "9no Grado": [
    "Sección 1 (Jornada Mañana)",
    "Sección 2 (Jornada Mañana)",
    "Sección 3 (Jornada Tarde)"
  ],
  "BTP en Informática": [
    "Sección Única - Jornada Mañana",
    "Sección Única - Jornada Tarde"
  ],
  "BTP en Contaduría y Finanzas": [
    "Sección Única - Jornada Mañana",
    "Sección Única - Jornada Tarde"
  ],
  "BTP en Agroindustria": [
    "Sección Única - Jornada Mañana"
  ]
};

function abrirModalGeneral(tipo = 'nuevo') {
  const modal = document.getElementById('modal-inscripcion');
  modal.classList.remove('hidden');
  modal.classList.add('flex');

  cambiarTipoTramite(tipo);
  actualizarSeccionesPorCurso();

  document.body.style.overflow = 'hidden';
}

function abrirModalCarrera(curso) {
  abrirModalGeneral('nuevo');

  const campoCurso = document.getElementById('campo-curso-select');
  campoCurso.value = curso;
  actualizarSeccionesPorCurso();
}

function cerrarModal() {
  const modal = document.getElementById('modal-inscripcion');
  modal.classList.add('hidden');
  modal.classList.remove('flex');

  document.body.style.overflow = '';
}

function cambiarTipoTramite(tipo) {
  const inputTipo = document.getElementById('tipo-tramite');
  const campoColegio = document.getElementById('campo-colegio-procedencia');
  const inputColegio = document.getElementById('input-colegio-procedencia');

  inputTipo.value = tipo;

  const botones = ['nuevo', 'traspaso', 'reingreso'];
  botones.forEach(function (item) {
    const btn = document.getElementById('btn-' + item);
    if (!btn) return;

    if (item === tipo) {
      btn.className = 'py-2.5 px-3 rounded-xl font-bold text-xs sm:text-sm transition-all flex items-center justify-center gap-2 bg-white text-primary shadow-sm';
    } else {
      btn.className = 'py-2.5 px-3 rounded-xl font-bold text-xs sm:text-sm transition-all flex items-center justify-center gap-2 text-gray-600 hover:text-gray-900';
    }
  });

  if (tipo === 'traspaso') {
    campoColegio.classList.remove('hidden');
    inputColegio.required = true;
  } else {
    campoColegio.classList.add('hidden');
    inputColegio.required = false;
    inputColegio.value = '';
  }
}

function actualizarSeccionesPorCurso() {
  const campoCurso = document.getElementById('campo-curso-select');
  const campoSeccion = document.getElementById('campo-seccion-modal');
  const cursoSeleccionado = campoCurso.value;
  const secciones = seccionesPorCurso[cursoSeleccionado] || [];

  campoSeccion.innerHTML = '';

  secciones.forEach(function (seccion) {
    const option = document.createElement('option');
    option.value = seccion;
    option.textContent = seccion;
    campoSeccion.appendChild(option);
  });
}

document.addEventListener('DOMContentLoaded', function () {
  const campoCurso = document.getElementById('campo-curso-select');
  const form = document.getElementById('form-inscripcion');
  const modal = document.getElementById('modal-inscripcion');

  actualizarSeccionesPorCurso();

  campoCurso.addEventListener('change', actualizarSeccionesPorCurso);

  form.addEventListener('submit', function (event) {
    event.preventDefault();

    const tipo = document.getElementById('tipo-tramite').value;
    const nombre = document.getElementById('nombre-alumno').value.trim();
    const curso = document.getElementById('campo-curso-select').value;
    const seccion = document.getElementById('campo-seccion-modal').value;

    let textoTipo = 'Nuevo ingreso';
    if (tipo === 'traspaso') textoTipo = 'Traspaso';
    if (tipo === 'reingreso') textoTipo = 'Reingreso';

    alert(
      'Solicitud enviada correctamente.\n\n' +
      'Alumno: ' + nombre + '\n' +
      'Tipo de trámite: ' + textoTipo + '\n' +
      'Curso/Carrera: ' + curso + '\n' +
      'Sección: ' + seccion + '\n\n' +
      'Puedes reemplazar esta confirmación por el envío real a tu sistema.'
    );

    form.reset();
    cambiarTipoTramite('nuevo');
    actualizarSeccionesPorCurso();
    cerrarModal();
  });

  modal.addEventListener('click', function (event) {
    if (event.target === modal) {
      cerrarModal();
    }
  });

  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' && !modal.classList.contains('hidden')) {
      cerrarModal();
    }
  });
});