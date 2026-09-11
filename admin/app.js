/**
 * Panel administrativo — lógica principal.
 *
 * Un solo archivo, deliberadamente: la mayoría de los módulos (hitos,
 * logros, disciplinas, productos, carreras...) son el mismo patrón
 * (listar / crear / editar / eliminar) con otra tabla. En vez de once
 * páginas casi idénticas, hay UN renderizador genérico configurado por
 * módulo (MODULOS, abajo) y unas pocas vistas especiales para lo que de
 * verdad es distinto (usuarios, moderación, integrantes de equipo).
 */

function raiz() { return document.getElementById('admin-root'); }
let seccionActual = null;
/** Guarda la última lista cargada de cada módulo, para poder editar sin volver a pedirla. */
const itemsCargados = {};

/* ============================================================
   Utilidades de UI
   ============================================================ */
function mostrarToast(mensaje, tipo = 'info') {
  let wrap = document.querySelector('.admin-toast-wrap');
  if (!wrap) {
    wrap = document.createElement('div');
    wrap.className = 'admin-toast-wrap';
    document.body.appendChild(wrap);
  }
  const t = document.createElement('div');
  t.className = `admin-toast ${tipo}`;
  t.textContent = mensaje;
  wrap.appendChild(t);
  setTimeout(() => t.remove(), 3500);
}

function el(html) {
  const div = document.createElement('div');
  div.innerHTML = html.trim();
  return div.firstElementChild;
}

async function conFeedback(promesa, mensajeExito) {
  try {
    await promesa;
    if (mensajeExito) mostrarToast(mensajeExito, 'success');
    return true;
  } catch (e) {
    mostrarToast(e.message || 'Ocurrió un error.', 'error');
    return false;
  }
}

/* Modal genérico de confirmación de PIN, usado por Api cuando el backend lo exige. */
Api.registrarSolicitudPin(() => new Promise((resolve) => {
  const backdrop = el(`
    <div class="admin-modal-backdrop">
      <div class="admin-modal small">
        <h3><i class="fas fa-shield-halved" aria-hidden="true"></i> Confirma tu PIN</h3>
        <p style="font-size:.85rem;color:var(--color-text-secondary);margin-bottom:1rem;">
          Esta acción va a cambiar contenido del sitio.
        </p>
        <input type="password" inputmode="numeric" maxlength="8" class="admin-pin-input" id="pin-input" placeholder="••••">
        <div class="admin-modal-foot" style="justify-content:center;">
          <button class="btn btn-outline" id="pin-cancelar">Cancelar</button>
          <button class="btn btn-primary" id="pin-confirmar">Confirmar</button>
        </div>
      </div>
    </div>`);
  document.body.appendChild(backdrop);
  const input = backdrop.querySelector('#pin-input');
  input.focus();
  const cerrar = (valor) => { backdrop.remove(); resolve(valor); };
  backdrop.querySelector('#pin-cancelar').onclick = () => cerrar(null);
  backdrop.querySelector('#pin-confirmar').onclick = () => cerrar(input.value);
  input.addEventListener('keydown', (e) => { if (e.key === 'Enter') cerrar(input.value); });
}));

window.addEventListener('igtfm:sesion-expirada', () => {
  mostrarToast('Tu sesión expiró. Inicia sesión de nuevo.', 'error');
  renderLogin();
});

/* ============================================================
   Definición de módulos (motor genérico de CRUD)
   ============================================================ */
const MODULOS = {
  eventos: {
    titulo: 'Eventos deportivos', icono: 'fa-futbol', endpoint: '/eventos-deportivos',
    permisoCrear: 'crear_evento_deportivo', permisoEditar: 'editar_evento_deportivo',
    columnas: [
      { clave: 'titulo', etiqueta: 'Título' },
      { clave: 'rival', etiqueta: 'Rival' },
      { clave: 'disciplina', etiqueta: 'Disciplina' },
      { clave: 'fecha', etiqueta: 'Fecha', formato: (v) => v ? new Date(v).toLocaleString('es-HN') : '' },
      { clave: 'estado', etiqueta: 'Estado', badge: true },
    ],
    campos: [
      { clave: 'titulo', etiqueta: 'Título', tipo: 'text', requerido: true },
      { clave: 'rival', etiqueta: 'Rival (texto libre)', tipo: 'text' },
      { clave: 'disciplina_id', etiqueta: 'Disciplina', tipo: 'select', fuente: 'disciplinas', requerido: true },
      { clave: 'categoria_id', etiqueta: 'Categoría', tipo: 'select', fuente: 'categorias-competencia', requerido: true },
      { clave: 'equipo_id', etiqueta: 'Equipo (opcional)', tipo: 'select', fuente: 'equipos' },
      { clave: 'fecha', etiqueta: 'Fecha y hora', tipo: 'datetime-local', requerido: true },
      { clave: 'lugar', etiqueta: 'Lugar', tipo: 'text' },
      { clave: 'estado', etiqueta: 'Estado', tipo: 'select', opciones: ['proximo', 'jugado', 'cancelado'] },
      { clave: 'resultado', etiqueta: 'Resultado (si ya se jugó)', tipo: 'text' },
      { clave: 'destacado', etiqueta: 'Marcar como evento insignia', tipo: 'checkbox' },
    ],
  },

  hitos: {
    titulo: 'Línea de tiempo (hitos)', icono: 'fa-timeline', endpoint: '/hitos-historicos',
    permisoCrear: 'crear_hito_historico', permisoEditar: 'crear_hito_historico',
    columnas: [
      { clave: 'anio_periodo', etiqueta: 'Año / período' },
      { clave: 'titulo', etiqueta: 'Título' },
    ],
    campos: [
      { clave: 'anio_periodo', etiqueta: 'Año o período (ej. "2018-2019")', tipo: 'text', requerido: true },
      { clave: 'titulo', etiqueta: 'Título', tipo: 'text', requerido: true },
      { clave: 'descripcion', etiqueta: 'Descripción', tipo: 'textarea', requerido: true },
      { clave: 'imagen_url', etiqueta: 'URL de imagen (opcional)', tipo: 'text' },
      { clave: 'orden', etiqueta: 'Orden de aparición', tipo: 'number' },
    ],
  },

  logros: {
    titulo: 'Logros', icono: 'fa-trophy', endpoint: '/logros',
    permisoCrear: 'crear_logro', permisoEditar: 'crear_logro',
    columnas: [
      { clave: 'titulo', etiqueta: 'Título' },
      { clave: 'anio', etiqueta: 'Año' },
      { clave: 'disciplina', etiqueta: 'Disciplina' },
    ],
    campos: [
      { clave: 'titulo', etiqueta: 'Título', tipo: 'text', requerido: true },
      { clave: 'descripcion', etiqueta: 'Descripción', tipo: 'textarea', requerido: true },
      { clave: 'anio', etiqueta: 'Año', tipo: 'text', requerido: true },
      { clave: 'etiqueta', etiqueta: 'Etiqueta (ej. "Fútbol femenino")', tipo: 'text' },
      { clave: 'disciplina_id', etiqueta: 'Disciplina', tipo: 'select', fuente: 'disciplinas' },
      { clave: 'equipo_id', etiqueta: 'Equipo', tipo: 'select', fuente: 'equipos' },
    ],
  },

  disciplinas: {
    titulo: 'Disciplinas', icono: 'fa-medal', endpoint: '/disciplinas',
    permisoCrear: 'gestionar_equipos', permisoEditar: 'gestionar_equipos',
    // No se pueden eliminar: equipos, eventos y logros dependen de ellas.
    // Si una deja de practicarse, se edita su descripción en vez de borrarla.
    sinEliminar: true,
    columnas: [
      { clave: 'nombre', etiqueta: 'Nombre' },
      { clave: 'total_equipos', etiqueta: 'Equipos' },
    ],
    campos: [
      { clave: 'nombre', etiqueta: 'Nombre', tipo: 'text', requerido: true },
      { clave: 'descripcion', etiqueta: 'Descripción', tipo: 'textarea' },
      { clave: 'icono', etiqueta: 'Ícono (clase Font Awesome, ej. fa-futbol)', tipo: 'text' },
      { clave: 'orden', etiqueta: 'Orden', tipo: 'number' },
    ],
  },

  equipos: {
    titulo: 'Equipos', icono: 'fa-people-group', endpoint: '/equipos',
    permisoCrear: 'gestionar_equipos', permisoEditar: 'gestionar_equipos',
    columnas: [
      { clave: 'nombre', etiqueta: 'Nombre' },
      { clave: 'disciplina', etiqueta: 'Disciplina' },
      { clave: 'categoria', etiqueta: 'Categoría' },
      { clave: 'total_integrantes', etiqueta: 'Integrantes' },
    ],
    campos: [
      { clave: 'nombre', etiqueta: 'Nombre del equipo', tipo: 'text', requerido: true },
      { clave: 'disciplina_id', etiqueta: 'Disciplina', tipo: 'select', fuente: 'disciplinas', requerido: true },
      { clave: 'categoria_id', etiqueta: 'Categoría de competencia', tipo: 'select', fuente: 'categorias-competencia', requerido: true },
      { clave: 'descripcion', etiqueta: 'Descripción', tipo: 'textarea' },
    ],
    filaExtra: (item) => `<button class="btn btn-outline btn-sm" onclick="verIntegrantes(${item.id}, '${item.nombre.replace(/'/g, "\\'")}')"><i class="fas fa-users"></i> Roster</button>`,
  },

  publicaciones: {
    titulo: 'Publicaciones', icono: 'fa-newspaper', endpoint: '/publicaciones',
    endpointLista: '/publicaciones/admin',
    permisoCrear: 'crear_publicacion', permisoEditar: 'editar_publicacion',
    columnas: [
      { clave: 'titulo', etiqueta: 'Título' },
      { clave: 'estado', etiqueta: 'Estado', badge: true },
      { clave: 'destacado', etiqueta: 'Destacada', formato: (v) => v ? 'Sí' : 'No' },
    ],
    campos: [
      { clave: 'titulo', etiqueta: 'Título', tipo: 'text', requerido: true },
      { clave: 'resumen', etiqueta: 'Resumen corto', tipo: 'textarea' },
      { clave: 'contenido', etiqueta: 'Contenido completo', tipo: 'textarea', requerido: true },
      { clave: 'imagen_portada', etiqueta: 'URL de imagen de portada', tipo: 'text' },
      { clave: 'estado', etiqueta: 'Estado', tipo: 'select', opciones: ['borrador', 'publicado'] },
      { clave: 'destacado', etiqueta: 'Mostrar en inicio.html', tipo: 'checkbox' },
    ],
  },

  carreras: {
    titulo: 'Carreras', icono: 'fa-graduation-cap', endpoint: '/carreras',
    permisoCrear: 'gestionar_academico', permisoEditar: 'gestionar_academico',
    columnas: [
      { clave: 'nombre', etiqueta: 'Nombre' },
      { clave: 'tipo', etiqueta: 'Tipo' },
    ],
    campos: [
      { clave: 'nombre', etiqueta: 'Nombre', tipo: 'text', requerido: true },
      { clave: 'tipo', etiqueta: 'Tipo', tipo: 'select', opciones: ['basica', 'tecnica'], requerido: true },
      { clave: 'descripcion', etiqueta: 'Descripción', tipo: 'textarea' },
      { clave: 'icono', etiqueta: 'Ícono (Font Awesome)', tipo: 'text' },
    ],
  },

  productos: {
    titulo: 'Tienda escolar', icono: 'fa-bag-shopping', endpoint: '/productos',
    permisoCrear: 'gestionar_productos', permisoEditar: 'gestionar_productos',
    columnas: [
      { clave: 'nombre', etiqueta: 'Producto' },
      { clave: 'precio', etiqueta: 'Precio', formato: (v) => `L. ${Number(v).toFixed(2)}` },
      { clave: 'disponible', etiqueta: 'Disponible', formato: (v) => v ? 'Sí' : 'No' },
    ],
    campos: [
      { clave: 'nombre', etiqueta: 'Nombre', tipo: 'text', requerido: true },
      { clave: 'precio', etiqueta: 'Precio (Lempiras)', tipo: 'number', requerido: true },
      { clave: 'descripcion', etiqueta: 'Descripción', tipo: 'textarea' },
      { clave: 'foto_url', etiqueta: 'URL de foto', tipo: 'text' },
      { clave: 'disponible', etiqueta: 'Disponible', tipo: 'checkbox' },
    ],
  },
};

/* ============================================================
   Renderizador genérico de módulo (tabla + formulario)
   ============================================================ */
async function cargarOpcionesSelect(fuente) {
  const datos = await Api.get(`/${fuente}`);
  return datos.datos || [];
}

async function renderModulo(clave) {
  const mod = MODULOS[clave];
  seccionActual = clave;
  marcarNavActiva(clave);

  raiz().innerHTML = `
    <div class="admin-topbar"><h2><i class="fas ${mod.icono}"></i> ${mod.titulo}</h2></div>
    <div class="admin-content">
      <div class="admin-toolbar">
        <span></span>
        ${Api.tienePermiso(mod.permisoCrear) ? `<button class="btn btn-primary btn-sm" id="btn-nuevo"><i class="fas fa-plus"></i> Nuevo</button>` : ''}
      </div>
      <div class="admin-table-wrap"><div class="admin-empty">Cargando...</div></div>
    </div>`;

  document.getElementById('btn-nuevo')?.addEventListener('click', () => abrirFormularioModulo(clave));

  try {
    const respuesta = await Api.llamar(mod.endpointLista || mod.endpoint);
    const items = respuesta.datos || [];
    itemsCargados[clave] = items;
    pintarTablaModulo(clave, items);
  } catch (e) {
    raiz().querySelector('.admin-table-wrap').innerHTML = `<div class="admin-empty">${e.message}</div>`;
  }
}

function pintarTablaModulo(clave, items) {
  const mod = MODULOS[clave];
  const wrap = raiz().querySelector('.admin-table-wrap');

  if (items.length === 0) {
    wrap.innerHTML = `<div class="admin-empty"><i class="fas fa-inbox" style="font-size:1.4rem;display:block;margin-bottom:.5rem;"></i>Todavía no hay registros.</div>`;
    return;
  }

  const encabezados = mod.columnas.map((c) => `<th>${c.etiqueta}</th>`).join('');
  const filas = items.map((item) => {
    const celdas = mod.columnas.map((c) => {
      let valor = item[c.clave] ?? '—';
      if (c.formato) valor = c.formato(item[c.clave]);
      if (c.badge) {
        const tipo = { publicado: 'ok', proximo: 'ok', jugado: 'off', pendiente: 'warn', rechazado: 'danger', borrador: 'warn', cancelado: 'danger' }[item[c.clave]] || 'off';
        valor = `<span class="admin-badge ${tipo}">${valor}</span>`;
      }
      return `<td>${valor}</td>`;
    }).join('');

    const acciones = [];
    if (!mod.sinEditar && Api.tienePermiso(mod.permisoEditar)) {
      acciones.push(`<button class="admin-icon-btn" title="Editar" onclick="abrirFormularioModulo('${clave}', ${item.id})"><i class="fas fa-pen"></i></button>`);
    }
    if (!mod.sinEliminar && Api.tienePermiso(mod.permisoCrear)) {
      acciones.push(`<button class="admin-icon-btn danger" title="Eliminar" onclick="eliminarModulo('${clave}', ${item.id})"><i class="fas fa-trash"></i></button>`);
    }
    const extra = mod.filaExtra ? mod.filaExtra(item) : '';

    return `<tr><td colspan="0"></td>${celdas}<td><div class="admin-row-actions">${extra}${acciones.join('')}</div></td></tr>`;
  }).join('');

  wrap.innerHTML = `<table class="admin-table"><thead><tr>${encabezados}<th></th></tr></thead><tbody>${filas.replace(/<td colspan="0"><\/td>/g, '')}</tbody></table>`;
}

async function abrirFormularioModulo(clave, id = null) {
  const mod = MODULOS[clave];
  // El registro se toma de la lista que la tabla ya cargó, en lugar de
  // pedirlo otra vez al servidor: evita una llamada extra y no obliga a
  // que cada módulo tenga un endpoint GET individual.
  let registro = {};
  if (id) {
    registro = (itemsCargados[clave] || []).find((i) => String(i.id) === String(id)) || {};
  }

  // Cargar opciones de los <select> que dependen de otro endpoint.
  const opcionesCache = {};
  for (const campo of mod.campos.filter((c) => c.tipo === 'select' && c.fuente)) {
    opcionesCache[campo.fuente] = await cargarOpcionesSelect(campo.fuente).catch(() => []);
  }

  const camposHtml = mod.campos.map((c) => {
    let valor = registro[c.clave] ?? '';
    // Los <input type="datetime-local"> exigen el formato "YYYY-MM-DDTHH:MM";
    // MySQL devuelve ISO con zona horaria, así que hay que recortarlo.
    if (c.tipo === 'datetime-local' && valor) {
      const d = new Date(valor);
      if (!isNaN(d)) {
        const pad = (n) => String(n).padStart(2, '0');
        valor = `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}T${pad(d.getHours())}:${pad(d.getMinutes())}`;
      }
    }
    if (c.tipo === 'textarea') {
      return `<div class="admin-field"><label>${c.etiqueta}</label><textarea name="${c.clave}" ${c.requerido ? 'required' : ''}>${valor}</textarea></div>`;
    }
    if (c.tipo === 'checkbox') {
      return `<div class="admin-field"><label><input type="checkbox" name="${c.clave}" ${valor ? 'checked' : ''}> ${c.etiqueta}</label></div>`;
    }
    if (c.tipo === 'select') {
      const opts = c.fuente
        ? (opcionesCache[c.fuente] || []).map((o) => `<option value="${o.id}" ${String(o.id) === String(valor) ? 'selected' : ''}>${o.nombre}</option>`)
        : c.opciones.map((o) => `<option value="${o}" ${o === valor ? 'selected' : ''}>${o}</option>`);
      return `<div class="admin-field"><label>${c.etiqueta}</label><select name="${c.clave}" ${c.requerido ? 'required' : ''}><option value="">— Elegir —</option>${opts.join('')}</select></div>`;
    }
    return `<div class="admin-field"><label>${c.etiqueta}</label><input type="${c.tipo}" name="${c.clave}" value="${valor}" ${c.requerido ? 'required' : ''}></div>`;
  }).join('');

  const backdrop = el(`
    <div class="admin-modal-backdrop">
      <div class="admin-modal">
        <h3>${id ? 'Editar' : 'Nuevo'} · ${mod.titulo}</h3>
        <form id="form-modulo">${camposHtml}
          <div class="admin-modal-foot">
            <button type="button" class="btn btn-outline" id="cancelar-modulo">Cancelar</button>
            <button type="submit" class="btn btn-primary">Guardar</button>
          </div>
        </form>
      </div>
    </div>`);
  document.body.appendChild(backdrop);
  backdrop.querySelector('#cancelar-modulo').onclick = () => backdrop.remove();

  backdrop.querySelector('#form-modulo').addEventListener('submit', async (e) => {
    e.preventDefault();
    const datosForm = new FormData(e.target);
    const cuerpo = {};
    for (const c of mod.campos) {
      if (c.tipo === 'checkbox') cuerpo[c.clave] = datosForm.has(c.clave);
      else {
        const v = datosForm.get(c.clave);
        cuerpo[c.clave] = v === '' ? null : v;
      }
    }
    const ok = await conFeedback(
      id ? Api.patch(`${mod.endpoint}/${id}`, cuerpo) : Api.post(mod.endpoint, cuerpo),
      id ? 'Cambios guardados.' : 'Registro creado.'
    );
    if (ok) { backdrop.remove(); renderModulo(clave); }
  });
}

async function eliminarModulo(clave, id) {
  if (!confirm('¿Eliminar este registro? No se puede deshacer.')) return;
  const mod = MODULOS[clave];
  const ok = await conFeedback(Api.del(`${mod.endpoint}/${id}`), 'Registro eliminado.');
  if (ok) renderModulo(clave);
}
window.abrirFormularioModulo = abrirFormularioModulo;
window.eliminarModulo = eliminarModulo;

/* ============================================================
   Vistas especiales (no encajan en el patrón genérico)
   ============================================================ */
async function renderDashboard() {
  seccionActual = 'dashboard';
  marcarNavActiva('dashboard');
  raiz().innerHTML = `
    <div class="admin-topbar"><h2><i class="fas fa-gauge-high"></i> Panel principal</h2></div>
    <div class="admin-content"><div class="admin-stat-grid" id="stats-grid"><div class="admin-empty">Cargando...</div></div></div>`;

  try {
    const est = await Api.get('/estadisticas-deportivas');
    const grid = document.getElementById('stats-grid');
    const tarjetas = [
      ['Disciplinas', est.calculadas.disciplinas], ['Equipos activos', est.calculadas.equipos],
      ['Logros', est.calculadas.logros], ['Eventos registrados', est.calculadas.eventos_registrados],
      ['Años compitiendo', est.manuales.anios_compitiendo], ['Estudiantes en deporte', est.manuales.estudiantes_en_deporte],
    ];
    grid.innerHTML = tarjetas.map(([l, n]) => `<div class="admin-stat-card"><span class="n">${n ?? '—'}</span><span class="l">${l}</span></div>`).join('');
  } catch (e) {
    document.getElementById('stats-grid').innerHTML = `<div class="admin-empty">${e.message}</div>`;
  }
}

/** Roster de un equipo — incluye el interruptor sensible mostrar_publicamente. */
async function verIntegrantes(equipoId, nombreEquipo) {
  const backdrop = el(`
    <div class="admin-modal-backdrop">
      <div class="admin-modal">
        <h3><i class="fas fa-users"></i> Roster — ${nombreEquipo}</h3>
        <p style="font-size:.78rem;color:var(--color-text-secondary);margin-bottom:1rem;">
          "Mostrar públicamente" controla si el nombre sale en el sitio. Por defecto está apagado.
        </p>
        <div id="lista-integrantes" class="admin-empty">Cargando...</div>
        <button class="btn btn-outline btn-sm" id="btn-agregar-integrante" style="margin-top:1rem;"><i class="fas fa-plus"></i> Agregar integrante</button>
        <div class="admin-modal-foot"><button class="btn btn-outline" id="cerrar-roster">Cerrar</button></div>
      </div>
    </div>`);
  document.body.appendChild(backdrop);
  backdrop.querySelector('#cerrar-roster').onclick = () => backdrop.remove();

  async function refrescar() {
    const r = await Api.get(`/equipos/${equipoId}/integrantes/admin`);
    const cont = backdrop.querySelector('#lista-integrantes');
    if (r.datos.length === 0) { cont.innerHTML = '<div class="admin-empty">Sin integrantes todavía.</div>'; return; }
    cont.innerHTML = r.datos.map((i) => `
      <div style="display:flex;align-items:center;justify-content:space-between;padding:.5rem 0;border-bottom:1px solid var(--color-border);font-size:.85rem;">
        <span>#${i.numero_camisa ?? '—'} ${i.nombre_completo}</span>
        <label style="display:flex;align-items:center;gap:.4rem;font-size:.72rem;">
          <input type="checkbox" ${i.mostrar_publicamente ? 'checked' : ''}
            onchange="cambiarVisibilidadIntegrante(${equipoId}, ${i.id}, this.checked)"> Público
        </label>
      </div>`).join('');
  }
  await refrescar();

  backdrop.querySelector('#btn-agregar-integrante').onclick = () => {
    const nombre = prompt('Nombre completo del integrante:');
    if (!nombre) return;
    const numero = prompt('Número de camisa (opcional):');
    conFeedback(
      Api.post(`/equipos/${equipoId}/integrantes`, { nombre_completo: nombre, numero_camisa: numero || null }),
      'Integrante agregado.'
    ).then((ok) => ok && refrescar());
  };
  window.cambiarVisibilidadIntegrante = (eq, id, valor) => {
    conFeedback(Api.patch(`/equipos/${eq}/integrantes/${id}`, { mostrar_publicamente: valor }));
  };
}
window.verIntegrantes = verIntegrantes;

/** Testimonios: moderación (aprobar/rechazar) — no encaja en el CRUD genérico. */
async function renderTestimonios() {
  seccionActual = 'testimonios'; marcarNavActiva('testimonios');
  raiz().innerHTML = `<div class="admin-topbar"><h2><i class="fas fa-quote-left"></i> Testimonios</h2></div>
    <div class="admin-content"><div class="admin-table-wrap"><div class="admin-empty">Cargando...</div></div></div>`;
  try {
    const r = await Api.get('/testimonios/admin');
    const wrap = raiz().querySelector('.admin-table-wrap');
    if (r.datos.length === 0) { wrap.innerHTML = '<div class="admin-empty">Sin testimonios todavía.</div>'; return; }
    wrap.innerHTML = `<table class="admin-table"><thead><tr><th>Cita</th><th>Autor real</th><th>¿Anónimo al público?</th><th>Estado</th><th></th></tr></thead><tbody>
      ${r.datos.map((t) => `<tr>
        <td style="max-width:22rem;">${t.cita}</td>
        <td>${t.autor_real}</td>
        <td>${t.es_anonimo ? `Sí — se muestra como "${t.descriptor_publico || ''}"` : 'No'}</td>
        <td><span class="admin-badge ${{ publicado: 'ok', pendiente: 'warn', rechazado: 'danger' }[t.estado]}">${t.estado}</span></td>
        <td><div class="admin-row-actions">
          ${t.estado !== 'publicado' ? `<button class="admin-icon-btn" title="Aprobar" onclick="moderarTestimonio(${t.id},'publicado')"><i class="fas fa-check"></i></button>` : ''}
          ${t.estado !== 'rechazado' ? `<button class="admin-icon-btn danger" title="Rechazar" onclick="moderarTestimonio(${t.id},'rechazado')"><i class="fas fa-xmark"></i></button>` : ''}
        </div></td>
      </tr>`).join('')}</tbody></table>`;
  } catch (e) { raiz().querySelector('.admin-table-wrap').innerHTML = `<div class="admin-empty">${e.message}</div>`; }
}
window.moderarTestimonio = async (id, estado) => {
  const ok = await conFeedback(Api.patch(`/testimonios/${id}/estado`, { estado }), 'Testimonio actualizado.');
  if (ok) renderTestimonios();
};

/** Proyectos futuros / peticiones — con respuesta a quien solicitó. */
async function renderProyectos() {
  seccionActual = 'proyectos'; marcarNavActiva('proyectos');
  raiz().innerHTML = `<div class="admin-topbar"><h2><i class="fas fa-hammer"></i> Proyectos futuros / Peticiones</h2></div>
    <div class="admin-content"><div class="admin-table-wrap"><div class="admin-empty">Cargando...</div></div></div>`;
  try {
    const r = await Api.get('/proyectos-futuros/admin');
    const wrap = raiz().querySelector('.admin-table-wrap');
    if (r.datos.length === 0) { wrap.innerHTML = '<div class="admin-empty">Sin propuestas todavía.</div>'; return; }
    const badgeTipo = { pendiente: 'warn', en_revision: 'warn', aprobado: 'ok', en_gestion: 'ok', completado: 'ok', rechazado: 'danger' };
    wrap.innerHTML = `<table class="admin-table"><thead><tr><th>Título</th><th>Solicitante</th><th>Origen</th><th>Estado</th><th></th></tr></thead><tbody>
      ${r.datos.map((p) => `<tr>
        <td>${p.titulo}<br><small style="color:var(--color-muted);">${p.descripcion.slice(0, 80)}...</small></td>
        <td>${p.solicitante_nombre || '—'} <small>${p.solicitante_rol ? `(${p.solicitante_rol})` : ''}</small></td>
        <td>${p.origen === 'peticion_comunidad' ? 'Comunidad' : 'Institucional'}</td>
        <td><span class="admin-badge ${badgeTipo[p.estado]}">${p.estado}</span></td>
        <td><button class="btn btn-outline btn-sm" onclick="gestionarProyecto(${p.id})">Gestionar</button></td>
      </tr>`).join('')}</tbody></table>`;
  } catch (e) { raiz().querySelector('.admin-table-wrap').innerHTML = `<div class="admin-empty">${e.message}</div>`; }
}
window.gestionarProyecto = (id) => {
  const backdrop = el(`
    <div class="admin-modal-backdrop"><div class="admin-modal">
      <h3>Gestionar propuesta</h3>
      <div class="admin-field"><label>Nuevo estado</label>
        <select id="p-estado">
          <option value="pendiente">Pendiente</option><option value="en_revision">En revisión</option>
          <option value="aprobado">Aprobado</option><option value="en_gestion">En gestión</option>
          <option value="completado">Completado</option><option value="rechazado">Rechazado</option>
        </select></div>
      <div class="admin-field"><label>Respuesta (visible para quien lo solicitó, si se agrega en el futuro un buscador de peticiones)</label>
        <textarea id="p-respuesta"></textarea></div>
      <div class="admin-modal-foot">
        <button class="btn btn-outline" id="p-cancelar">Cancelar</button>
        <button class="btn btn-primary" id="p-guardar">Guardar</button>
      </div>
    </div></div>`);
  document.body.appendChild(backdrop);
  backdrop.querySelector('#p-cancelar').onclick = () => backdrop.remove();
  backdrop.querySelector('#p-guardar').onclick = async () => {
    const estado = backdrop.querySelector('#p-estado').value;
    const respuesta_admin = backdrop.querySelector('#p-respuesta').value;
    const ok = await conFeedback(Api.patch(`/proyectos-futuros/${id}`, { estado, respuesta_admin }), 'Propuesta actualizada.');
    if (ok) { backdrop.remove(); renderProyectos(); }
  };
};

/** Comentarios — moderación (ocultar/mostrar), con identidad real siempre visible aquí. */
async function renderComentarios() {
  seccionActual = 'comentarios'; marcarNavActiva('comentarios');
  raiz().innerHTML = `<div class="admin-topbar"><h2><i class="fas fa-comments"></i> Comentarios</h2></div>
    <div class="admin-content"><div class="admin-table-wrap"><div class="admin-empty">Cargando...</div></div></div>`;
  try {
    const r = await Api.get('/comentarios/admin');
    const wrap = raiz().querySelector('.admin-table-wrap');
    if (r.datos.length === 0) { wrap.innerHTML = '<div class="admin-empty">Sin comentarios todavía.</div>'; return; }
    wrap.innerHTML = `<table class="admin-table"><thead><tr><th>Mensaje</th><th>Autor real</th><th>Publicación</th><th>Estado</th><th></th></tr></thead><tbody>
      ${r.datos.map((c) => `<tr>
        <td style="max-width:20rem;">${c.mensaje}</td>
        <td>${c.autor_real}${c.es_anonimo ? ` <small>(anónimo al público como "${c.descriptor_publico || ''}")</small>` : ''}</td>
        <td>${c.publicacion}</td>
        <td><span class="admin-badge ${c.estado === 'visible' ? 'ok' : 'off'}">${c.estado}</span></td>
        <td><div class="admin-row-actions">
          <button class="admin-icon-btn" title="${c.estado === 'visible' ? 'Ocultar' : 'Mostrar'}"
            onclick="moderarComentario(${c.id}, '${c.estado === 'visible' ? 'oculto' : 'visible'}')">
            <i class="fas ${c.estado === 'visible' ? 'fa-eye-slash' : 'fa-eye'}"></i></button>
          <button class="admin-icon-btn danger" title="Eliminar" onclick="eliminarComentario(${c.id})"><i class="fas fa-trash"></i></button>
        </div></td>
      </tr>`).join('')}</tbody></table>`;
  } catch (e) { raiz().querySelector('.admin-table-wrap').innerHTML = `<div class="admin-empty">${e.message}</div>`; }
}
window.moderarComentario = async (id, estado) => { if (await conFeedback(Api.patch(`/comentarios/${id}/estado`, { estado }))) renderComentarios(); };
window.eliminarComentario = async (id) => { if (confirm('¿Eliminar este comentario?') && await conFeedback(Api.del(`/comentarios/${id}`))) renderComentarios(); };

/** Personal — directorio con búsqueda, más gestión de sus perfiles deportivos. */
async function renderPersonal() {
  seccionActual = 'personal'; marcarNavActiva('personal');
  raiz().innerHTML = `
    <div class="admin-topbar"><h2><i class="fas fa-user-tie"></i> Personal</h2></div>
    <div class="admin-content">
      <div class="admin-toolbar">
        <input type="text" id="buscar-personal" placeholder="Buscar por nombre, cargo o materia..." style="max-width:22rem;padding:.55rem .8rem;border:1.5px solid var(--color-border);border-radius:var(--radius-sm);">
        ${Api.tienePermiso('gestionar_personal') ? `<button class="btn btn-primary btn-sm" id="btn-nuevo-personal"><i class="fas fa-plus"></i> Nuevo</button>` : ''}
      </div>
      <div class="admin-table-wrap"><div class="admin-empty">Cargando...</div></div>
    </div>`;

  async function cargar(filtro = '') {
    const r = await Api.get(`/personal${filtro ? `?buscar=${encodeURIComponent(filtro)}` : ''}`);
    const wrap = raiz().querySelector('.admin-table-wrap');
    if (r.datos.length === 0) { wrap.innerHTML = '<div class="admin-empty">Sin resultados.</div>'; return; }
    wrap.innerHTML = `<table class="admin-table"><thead><tr><th>Nombre</th><th>Cargo</th><th>Departamento</th><th></th></tr></thead><tbody>
      ${r.datos.map((p) => `<tr>
        <td>${p.nombre_completo}</td><td>${p.cargo}</td><td>${p.departamento}</td>
        <td><div class="admin-row-actions">
          ${Api.tienePermiso('gestionar_personal') ? `<button class="admin-icon-btn" title="Editar" onclick="editarPersonal(${p.id})"><i class="fas fa-pen"></i></button>
          <button class="admin-icon-btn danger" title="Dar de baja" onclick="bajaPersonal(${p.id})"><i class="fas fa-user-xmark"></i></button>` : ''}
        </div></td>
      </tr>`).join('')}</tbody></table>`;
  }
  await cargar();
  document.getElementById('buscar-personal').addEventListener('input', (e) => cargar(e.target.value));
  document.getElementById('btn-nuevo-personal')?.addEventListener('click', () => formularioPersonal());
}

async function formularioPersonal(id = null) {
  let reg = {};
  if (id) reg = await Api.get(`/personal/${id}`);
  const departamentos = (await Api.get('/personal/departamentos')).datos;

  const backdrop = el(`
    <div class="admin-modal-backdrop"><div class="admin-modal">
      <h3>${id ? 'Editar' : 'Nuevo'} · Personal</h3>
      <form id="form-personal">
        <div class="admin-field"><label>Nombre completo</label><input name="nombre_completo" value="${reg.nombre_completo || ''}" required></div>
        <div class="admin-field"><label>Cargo</label><input name="cargo" value="${reg.cargo || ''}" required></div>
        <div class="admin-field"><label>Departamento</label>
          <select name="departamento_id" required><option value="">— Elegir —</option>
            ${departamentos.map((d) => `<option value="${d.id}" ${reg.departamento_id === d.id ? 'selected' : ''}>${d.nombre}</option>`).join('')}
          </select></div>
        <div class="admin-field"><label>Biografía</label><textarea name="biografia">${reg.biografia || ''}</textarea></div>
        <div class="admin-field"><label>Materia</label><input name="materia" value="${reg.materia || ''}"></div>
        <div class="admin-field"><label>Correo</label><input type="email" name="correo" value="${reg.correo || ''}"></div>
        <div class="admin-field"><label>Foto (URL)</label><input name="foto_url" value="${reg.foto_url || ''}"></div>
        <div class="admin-modal-foot">
          <button type="button" class="btn btn-outline" id="cancelar-personal">Cancelar</button>
          <button type="submit" class="btn btn-primary">Guardar</button>
        </div>
      </form>
    </div></div>`);
  document.body.appendChild(backdrop);
  backdrop.querySelector('#cancelar-personal').onclick = () => backdrop.remove();
  backdrop.querySelector('#form-personal').addEventListener('submit', async (e) => {
    e.preventDefault();
    const cuerpo = Object.fromEntries(new FormData(e.target).entries());
    const ok = await conFeedback(id ? Api.patch(`/personal/${id}`, cuerpo) : Api.post('/personal', cuerpo), 'Guardado.');
    if (ok) { backdrop.remove(); renderPersonal(); }
  });
}
window.editarPersonal = formularioPersonal;
window.bajaPersonal = async (id) => {
  if (confirm('¿Dar de baja a esta persona del directorio? (no se borra su historial)') && await conFeedback(Api.del(`/personal/${id}`))) renderPersonal();
};

/** Usuarios y roles — la sección más delicada, solo Administrador. */
async function renderUsuarios() {
  seccionActual = 'usuarios'; marcarNavActiva('usuarios');
  raiz().innerHTML = `
    <div class="admin-topbar"><h2><i class="fas fa-users-gear"></i> Usuarios y roles</h2></div>
    <div class="admin-content">
      <div class="admin-toolbar"><span></span><button class="btn btn-primary btn-sm" id="btn-invitar"><i class="fas fa-user-plus"></i> Invitar</button></div>
      <div class="admin-table-wrap"><div class="admin-empty">Cargando...</div></div>
    </div>`;

  const roles = (await Api.get('/usuarios/roles')).datos;

  async function cargar() {
    const r = await Api.get('/usuarios');
    const wrap = raiz().querySelector('.admin-table-wrap');
    wrap.innerHTML = `<table class="admin-table"><thead><tr><th>Nombre</th><th>Correo</th><th>Estado</th><th>Roles</th><th></th></tr></thead><tbody>
      ${r.datos.map((u) => `<tr>
        <td>${u.nombre_completo}</td><td>${u.correo}</td>
        <td><span class="admin-badge ${u.estado === 'activo' ? 'ok' : u.estado === 'invitado' ? 'warn' : 'off'}">${u.estado}</span></td>
        <td>${u.roles.map((r) => `<span class="admin-badge off">${r.nombre} <a href="#" onclick="quitarRol(${u.id},${r.id});return false;" style="color:#B3261E;margin-left:.3rem;">✕</a></span>`).join(' ') || '—'}</td>
        <td><div class="admin-row-actions">
          <select onchange="asignarRol(${u.id}, this.value); this.value=''" style="font-size:.75rem;padding:.2rem;">
            <option value="">+ Rol</option>${roles.map((r) => `<option value="${r.id}">${r.nombre}</option>`).join('')}
          </select>
          <button class="admin-icon-btn" title="${u.estado === 'activo' ? 'Desactivar' : 'Activar'}"
            onclick="cambiarEstadoUsuario(${u.id}, '${u.estado === 'activo' ? 'inactivo' : 'activo'}')">
            <i class="fas ${u.estado === 'activo' ? 'fa-user-lock' : 'fa-user-check'}"></i></button>
        </div></td>
      </tr>`).join('')}</tbody></table>`;
  }
  await cargar();
  window._refrescarUsuarios = cargar;

  document.getElementById('btn-invitar').onclick = () => {
    const backdrop = el(`
      <div class="admin-modal-backdrop"><div class="admin-modal small">
        <h3>Invitar colaborador</h3>
        <div class="admin-field" style="text-align:left;"><label>Nombre completo</label><input id="inv-nombre"></div>
        <div class="admin-field" style="text-align:left;"><label>Correo</label><input type="email" id="inv-correo"></div>
        <div class="admin-field" style="text-align:left;"><label>Rol inicial</label>
          <select id="inv-rol">${roles.map((r) => `<option value="${r.id}">${r.nombre}</option>`).join('')}</select></div>
        <div class="admin-modal-foot">
          <button class="btn btn-outline" id="inv-cancelar">Cancelar</button>
          <button class="btn btn-primary" id="inv-enviar">Invitar</button>
        </div>
      </div></div>`);
    document.body.appendChild(backdrop);
    backdrop.querySelector('#inv-cancelar').onclick = () => backdrop.remove();
    backdrop.querySelector('#inv-enviar').onclick = async () => {
      const nombreCompleto = backdrop.querySelector('#inv-nombre').value;
      const correo = backdrop.querySelector('#inv-correo').value;
      const rolId = backdrop.querySelector('#inv-rol').value;
      const ok = await conFeedback(Api.post('/auth/invitar', { nombreCompleto, correo, rolId }),
        `Invitación creada para ${correo}.`);
      if (ok) { backdrop.remove(); cargar(); }
    };
  };
}
window.asignarRol = async (usuarioId, rolId) => { if (rolId && await conFeedback(Api.post(`/usuarios/${usuarioId}/roles`, { rol_id: rolId }))) window._refrescarUsuarios(); };
window.quitarRol = async (usuarioId, rolId) => { if (await conFeedback(Api.del(`/usuarios/${usuarioId}/roles/${rolId}`))) window._refrescarUsuarios(); };
window.cambiarEstadoUsuario = async (id, estado) => { if (await conFeedback(Api.patch(`/usuarios/${id}/estado`, { estado }))) window._refrescarUsuarios(); };

/* ============================================================
   Navegación y shell
   ============================================================ */
const NAV = [
  { grupo: 'General', items: [{ clave: 'dashboard', etiqueta: 'Panel principal', icono: 'fa-gauge-high', render: renderDashboard }] },
  { grupo: 'Deportes', items: [
    { clave: 'eventos', etiqueta: 'Eventos', icono: 'fa-futbol', render: () => renderModulo('eventos') },
    { clave: 'hitos', etiqueta: 'Línea de tiempo', icono: 'fa-timeline', render: () => renderModulo('hitos') },
    { clave: 'logros', etiqueta: 'Logros', icono: 'fa-trophy', render: () => renderModulo('logros') },
    { clave: 'testimonios', etiqueta: 'Testimonios', icono: 'fa-quote-left', render: renderTestimonios },
    { clave: 'equipos', etiqueta: 'Equipos', icono: 'fa-people-group', render: () => renderModulo('equipos') },
    { clave: 'disciplinas', etiqueta: 'Disciplinas', icono: 'fa-medal', render: () => renderModulo('disciplinas') },
    { clave: 'proyectos', etiqueta: 'Proyectos futuros', icono: 'fa-hammer', render: renderProyectos },
  ]},
  { grupo: 'Institucional', items: [
    { clave: 'personal', etiqueta: 'Personal', icono: 'fa-user-tie', render: renderPersonal },
    { clave: 'publicaciones', etiqueta: 'Publicaciones', icono: 'fa-newspaper', render: () => renderModulo('publicaciones') },
    { clave: 'comentarios', etiqueta: 'Comentarios', icono: 'fa-comments', render: renderComentarios },
    { clave: 'carreras', etiqueta: 'Oferta académica', icono: 'fa-graduation-cap', render: () => renderModulo('carreras') },
    { clave: 'productos', etiqueta: 'Tienda escolar', icono: 'fa-bag-shopping', render: () => renderModulo('productos') },
  ]},
  { grupo: 'Administración', items: [
    { clave: 'usuarios', etiqueta: 'Usuarios y roles', icono: 'fa-users-gear', render: renderUsuarios, permiso: 'gestionar_usuarios' },
  ]},
];

function marcarNavActiva(clave) {
  document.querySelectorAll('.admin-nav-link').forEach((a) => a.classList.toggle('active', a.dataset.clave === clave));
}

function renderShell() {
  const usuario = Api.usuarioActual();
  const gruposHtml = NAV.map((g) => {
    const items = g.items.filter((i) => !i.permiso || Api.tienePermiso(i.permiso));
    if (items.length === 0) return '';
    return `<div class="admin-nav-group">${g.grupo}</div>` +
      items.map((i) => `<button class="admin-nav-link" data-clave="${i.clave}"><i class="fas ${i.icono}"></i> ${i.etiqueta}</button>`).join('');
  }).join('');

  document.body.className = 'admin-body';
  raiz().parentElement.innerHTML = `
    <div class="admin-shell">
      <aside class="admin-sidebar">
        <div class="brand"><img src="../imagenes/escudo-igtfm.png" alt=""><span>Panel administrativo<br>IGTFM</span></div>
        <nav>${gruposHtml}</nav>
        <div class="admin-sidebar-foot">
          <div class="admin-user-chip"><strong>${usuario?.nombre_completo || ''}</strong>${usuario?.correo || ''}</div>
          <button class="admin-nav-link" id="btn-cerrar-sesion"><i class="fas fa-right-from-bracket"></i> Cerrar sesión</button>
        </div>
      </aside>
      <main class="admin-main"><div id="admin-root"></div></main>
    </div>`;

  document.querySelectorAll('.admin-nav-link[data-clave]').forEach((btn) => {
    btn.addEventListener('click', () => {
      const item = NAV.flatMap((g) => g.items).find((i) => i.clave === btn.dataset.clave);
      item?.render();
    });
  });
  document.getElementById('btn-cerrar-sesion').addEventListener('click', () => { Api.cerrarSesion(); renderLogin(); });

  renderDashboard();
}

/* ============================================================
   Login
   ============================================================ */
function renderLogin() {
  document.body.className = 'admin-body';
  document.getElementById('app').innerHTML = `
    <div class="admin-login-wrap">
      <div class="admin-login-card">
        <img src="../imagenes/escudo-igtfm.png" alt="Escudo IGTFM">
        <h1>Panel administrativo</h1>
        <p class="subt">I.G.T. Francisco Miranda</p>
        <div id="login-error"></div>
        <form id="form-login">
          <div class="admin-field"><label>Correo</label><input type="email" id="login-correo" required autocomplete="username"></div>
          <div class="admin-field"><label>Contraseña</label><input type="password" id="login-contrasena" required autocomplete="current-password"></div>
          <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">Iniciar sesión</button>
        </form>
        <p class="admin-hint">¿Fuiste invitado recién? <a href="#" id="ir-activar">Activa tu cuenta aquí</a>.</p>
      </div>
    </div>`;

  document.getElementById('form-login').addEventListener('submit', async (e) => {
    e.preventDefault();
    const correo = document.getElementById('login-correo').value;
    const contrasena = document.getElementById('login-contrasena').value;
    try {
      await Api.login(correo, contrasena);
      await Api.cargarPermisos();
      iniciarShell();
    } catch (err) {
      document.getElementById('login-error').innerHTML = `<div class="admin-error">${err.message}</div>`;
    }
  });

  document.getElementById('ir-activar').addEventListener('click', (e) => { e.preventDefault(); renderActivar(); });
}

function renderActivar() {
  document.getElementById('app').innerHTML = `
    <div class="admin-login-wrap">
      <div class="admin-login-card">
        <h1>Activar cuenta</h1>
        <p class="subt">Configura tu contraseña y tu PIN por primera vez.</p>
        <div id="activar-error"></div>
        <form id="form-activar">
          <div class="admin-field"><label>Correo (el que te invitaron)</label><input type="email" id="act-correo" required></div>
          <div class="admin-field"><label>Nueva contraseña (mínimo 10 caracteres)</label><input type="password" id="act-contrasena" required></div>
          <div class="admin-field"><label>PIN (4 a 8 dígitos)</label><input type="password" inputmode="numeric" id="act-pin" required></div>
          <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">Activar cuenta</button>
        </form>
        <p class="admin-hint"><a href="#" id="volver-login">← Volver a iniciar sesión</a></p>
      </div>
    </div>`;
  document.getElementById('volver-login').addEventListener('click', (e) => { e.preventDefault(); renderLogin(); });
  document.getElementById('form-activar').addEventListener('submit', async (e) => {
    e.preventDefault();
    const correo = document.getElementById('act-correo').value;
    const contrasena = document.getElementById('act-contrasena').value;
    const pin = document.getElementById('act-pin').value;
    try {
      const r = await Api.llamar('/auth/activar', { method: 'POST', body: JSON.stringify({ correo, contrasena, pin }) });
      document.getElementById('activar-error').innerHTML = `<div class="admin-success">${r.mensaje}</div>`;
      setTimeout(renderLogin, 1500);
    } catch (err) {
      document.getElementById('activar-error').innerHTML = `<div class="admin-error">${err.message}</div>`;
    }
  });
}

async function iniciarShell() {
  document.getElementById('app').innerHTML = `<div id="admin-root"></div>`;
  renderShell();
}

/* ============================================================
   Arranque
   ============================================================ */
(async function iniciar() {
  if (Api.haySesion()) {
    try { await Api.cargarPermisos(); await iniciarShell(); return; }
    catch { Api.cerrarSesion(); }
  }
  renderLogin();
})();
