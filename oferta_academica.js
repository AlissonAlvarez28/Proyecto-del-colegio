/**
 * oferta_academica.js — Recursos académicos por carrera + descarga de pensum en PDF.
 *
 * La lógica del modal de inscripción (abrir/cerrar, tipo de trámite, secciones)
 * vive en el <script> al final de oferta_academica.html. Este archivo solo se
 * encarga de las tarjetas informativas de "Conoce cada opción académica" y de
 * generar el PDF del pensum orientativo.
 */

const recursosAcademicos = [
  {
    nombre: '7mo Grado',
    tipo: 'Educación Básica',
    asignaturas: ['Español', 'Matemáticas', 'Ciencias Naturales', 'Ciencias Sociales', 'Inglés', 'Educación Física', 'Educación Artística', 'Iniciación Técnica'],
    testimonios: [
      'La iniciación técnica me ayudó a descubrir qué áreas me interesan antes de elegir una carrera.',
      'Encontré profesores que explican con paciencia y me motivan a seguir aprendiendo.'
    ]
  },
  {
    nombre: '8vo Grado',
    tipo: 'Educación Básica',
    asignaturas: ['Español', 'Matemáticas', 'Ciencias Naturales', 'Ciencias Sociales', 'Inglés', 'Educación Física', 'Educación Artística', 'Tecnología'],
    testimonios: [
      'En octavo fortalecí mis bases y aprendí a organizar mejor mi tiempo de estudio.',
      'Las actividades prácticas hacen que las clases sean más dinámicas y fáciles de recordar.'
    ]
  },
  {
    nombre: '9no Grado',
    tipo: 'Educación Básica',
    asignaturas: ['Español', 'Matemáticas', 'Ciencias Naturales', 'Ciencias Sociales', 'Inglés', 'Educación Física', 'Tecnología', 'Orientación Vocacional'],
    testimonios: [
      'La orientación vocacional me ayudó a tomar con más seguridad mi decisión de continuar estudiando.',
      'Terminé el grado con mejores hábitos y con ganas de asumir nuevos retos.'
    ]
  },
  {
    nombre: 'BTP en Informática',
    tipo: 'Bachillerato Técnico Profesional',
    asignaturas: ['Programación', 'Bases de Datos', 'Diseño Web', 'Mantenimiento de Computadoras', 'Redes', 'Ofimática', 'Emprendimiento', 'Práctica Profesional'],
    testimonios: [
      'La práctica de programación me dio confianza para crear soluciones y continuar estudiando tecnología.',
      'Los proyectos del laboratorio me prepararon para resolver problemas reales con creatividad.'
    ]
  },
  {
    nombre: 'BTP en Contaduría y Finanzas',
    tipo: 'Bachillerato Técnico Profesional',
    asignaturas: ['Contabilidad', 'Matemáticas Financieras', 'Contabilidad Bancaria', 'Tributación', 'Administración', 'Economía', 'Ofimática', 'Práctica Profesional'],
    testimonios: [
      'Aprendí a llevar registros con orden y a entender cómo las finanzas apoyan a un negocio.',
      'Las prácticas me dieron herramientas útiles para trabajar y seguir formándome.'
    ]
  },
  {
    nombre: 'BTP en Agroindustria',
    tipo: 'Bachillerato Técnico Profesional',
    asignaturas: ['Procesamiento de Lácteos', 'Procesamiento de Cárnicos', 'Conservación de Alimentos', 'Higiene y Seguridad', 'Control de Calidad', 'Producción Agropecuaria', 'Emprendimiento', 'Práctica Profesional'],
    testimonios: [
      'Aprendí a transformar productos de nuestra comunidad aplicando higiene y control de calidad.',
      'La carrera me enseñó que la producción responsable también puede convertirse en un emprendimiento.'
    ]
  }
];

function escaparHtml(texto) {
  return String(texto).replace(/[&<>'"]/g, function (caracter) {
    return { '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[caracter];
  });
}

// Deja solo caracteres ASCII imprimibles: los acentos (y sus marcas combinantes
// tras normalizar) quedan fuera del rango \x20-\x7E, así que se eliminan aquí.
function normalizarPdf(texto) {
  return String(texto).normalize('NFD').replace(/[^\x20-\x7E]/g, '');
}

function escaparPdf(texto) {
  return normalizarPdf(texto).replace(/\\/g, '\\\\').replace(/\(/g, '\\(').replace(/\)/g, '\\)');
}

function descargarPensum(indice) {
  const carrera = recursosAcademicos[indice];
  if (!carrera) return;
  const lineas = [
    'I.G.T. FRANCISCO MIRANDA',
    'PENSUM ORIENTATIVO',
    carrera.nombre,
    carrera.tipo,
    '',
    'Asignaturas:',
    ...carrera.asignaturas.map(function (asignatura, posicion) { return (posicion + 1) + '. ' + asignatura; }),
    '',
    'Documento informativo. La institucion puede actualizar la malla curricular.'
  ];
  const comandos = ['BT', '/F1 16 Tf', '50 760 Td', '(' + escaparPdf(lineas[0]) + ') Tj', '/F1 13 Tf', '0 -28 Td', '(' + escaparPdf(lineas[1]) + ') Tj', '/F1 12 Tf', '0 -24 Td', '(' + escaparPdf(lineas[2]) + ') Tj', '/F1 10 Tf', '0 -18 Td', '(' + escaparPdf(lineas[3]) + ') Tj', '0 -30 Td'];
  lineas.slice(5).forEach(function (linea) {
    comandos.push('0 -17 Td', '(' + escaparPdf(linea) + ') Tj');
  });
  comandos.push('ET');
  const contenido = comandos.join('\n');
  const objetos = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
    '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 5 0 R >> >> /Contents 4 0 R >>',
    '<< /Length ' + contenido.length + ' >>\nstream\n' + contenido + '\nendstream',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>'
  ];
  let pdf = '%PDF-1.4\n';
  const offsets = [0];
  objetos.forEach(function (objeto, indiceObjeto) {
    offsets.push(pdf.length);
    pdf += (indiceObjeto + 1) + ' 0 obj\n' + objeto + '\nendobj\n';
  });
  const inicioXref = pdf.length;
  pdf += 'xref\n0 ' + (objetos.length + 1) + '\n0000000000 65535 f \n';
  offsets.slice(1).forEach(function (offset) { pdf += String(offset).padStart(10, '0') + ' 00000 n \n'; });
  pdf += 'trailer\n<< /Size ' + (objetos.length + 1) + ' /Root 1 0 R >>\nstartxref\n' + inicioXref + '\n%%EOF';
  const enlace = document.createElement('a');
  enlace.href = URL.createObjectURL(new Blob([pdf], { type: 'application/pdf' }));
  enlace.download = 'pensum-' + normalizarPdf(carrera.nombre).toLowerCase().replace(/[^a-z0-9]+/g, '-') + '.pdf';
  enlace.click();
  URL.revokeObjectURL(enlace.href);
}

function renderizarRecursosAcademicos() {
  const contenedor = document.getElementById('recursos-carreras');
  if (!contenedor) return;
  contenedor.innerHTML = recursosAcademicos.map(function (carrera, indice) {
    return '<article class="bg-white border border-slate-200 rounded-xl p-6 shadow-sm flex flex-col">' +
      '<div class="flex items-start justify-between gap-3"><div><span class="text-xs font-bold uppercase tracking-wider text-amber-700">' + escaparHtml(carrera.tipo) + '</span>' +
      '<h3 class="text-xl font-bold text-slate-900 mt-1">' + escaparHtml(carrera.nombre) + '</h3></div><i class="fa-solid fa-graduation-cap text-xl text-primary" aria-hidden="true"></i></div>' +
      '<h4 class="text-sm font-bold text-slate-700 mt-5 mb-2">Testimonios de egresados</h4>' +
      '<blockquote class="border-l-4 border-amber-400 pl-3 text-sm text-slate-600 italic">“' + escaparHtml(carrera.testimonios[0]) + '”</blockquote>' +
      '<blockquote class="border-l-4 border-slate-300 pl-3 text-sm text-slate-600 italic mt-3">“' + escaparHtml(carrera.testimonios[1]) + '”</blockquote>' +
      '<button type="button" class="btn btn-primary btn-sm mt-5 w-full" onclick="descargarPensum(' + indice + ')"><i class="fa-solid fa-file-pdf" aria-hidden="true"></i> Descargar pensum PDF</button>' +
      '</article>';
  }).join('');
}

document.addEventListener('DOMContentLoaded', renderizarRecursosAcademicos);
