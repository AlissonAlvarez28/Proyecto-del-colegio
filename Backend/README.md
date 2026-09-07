# API institucional — I.G.T. Francisco Miranda

Backend en Node.js + Express + MySQL que permite a las autoridades del instituto administrar el contenido del sitio sin editar código.

## Estado

| Módulo | Estado |
|---|---|
| Base de datos (25 tablas) | ✅ |
| Autenticación (login, activación, PIN, invitaciones) | ✅ |
| Gestión de usuarios y roles | ✅ |
| Personal (directorio) | ✅ |
| Publicaciones y comentarios | ✅ |
| Académico (carreras, secciones, horarios) | ✅ |
| Deportes (eventos, equipos, testimonios, hitos, logros, disciplinas, estadísticas) | ✅ |
| Proyectos futuros / peticiones | ✅ |
| Tienda y configuración institucional | ✅ |
| Panel administrativo (frontend) | ⏳ Pendiente |
| Conexión del sitio público a la API | ⏳ Pendiente |

**74 endpoints.** El backend está completo; falta la interfaz que lo consuma.

## Instalación

```bash
npm install
cp .env.example .env      # rellenar con los datos reales de Aiven
```

Generar el secreto para los tokens:
```bash
node -e "console.log(require('crypto').randomBytes(48).toString('hex'))"
```

## Base de datos

1. Crear el servicio MySQL en Aiven y descargar `ca.pem` a `certs/`.
2. Aplicar los scripts **en este orden**:
```bash
node ejecutar-sql.js schema.sql            # estructura (25 tablas)
node ejecutar-sql.js datos-reales.sql      # contenido real (885 registros)
node ejecutar-sql.js cifras-deportivas.sql # cifras editables del área deportiva
```
3. Crear el primer administrador (pide los datos por consola, no se escriben en ningún archivo):
```bash
npm run crear-admin
```

## Ejecutar

```bash
npm run dev     # desarrollo
npm start       # producción
```
Verificar: `GET http://localhost:3000/api/salud`

## Seguridad

**Nadie se registra solo.** Un administrador invita por correo → la persona entra por primera vez → configura contraseña y PIN → queda activa.

**Dos capas:** la **contraseña** abre la sesión; el **PIN** se pide otra vez ante cada cambio de contenido. Ambos con bcrypt, nunca legibles.

**Roles:**
- `Administrador`: todo, incluido invitar personas y moderar.
- `Colaborador`: crea y edita contenido; **solo borra lo que él mismo creó**.
- Visitante: sin cuenta, solo lectura pública.

**Protecciones contra errores irreversibles:** no puedes quitarte tu propio rol de Administrador, ni desactivar al último Administrador activo.

## Las dos reglas de privacidad que no se deben romper

**1. Nombres de estudiantes (`integrantes_equipo`)**
`mostrar_publicamente` es `FALSE` por defecto. La API pública solo lista a quienes lo tienen en `TRUE`. **Nunca hacer `SELECT *` de esa tabla hacia una respuesta pública.**

**2. Anonimato trazable (testimonios y comentarios)**
Si `es_anonimo = TRUE`, el público ve `descriptor_publico` en lugar del nombre. Pero `usuario_id` nunca queda vacío: administración y docentes siempre pueden ver quién escribió qué. Es privacidad ante el público, con responsabilidad detrás.

## Limitación conocida (decidida a propósito)

La activación de cuenta **no verifica** que quien configura la contraseña controle realmente ese correo. Aceptable porque el grupo de invitados es reducido y de confianza. **Mejora futura:** enlace de activación con token enviado por correo.

## Estadísticas: calculadas vs. guardadas

`GET /api/estadisticas-deportivas` devuelve dos bloques:
- **`calculadas`** — disciplinas, equipos, logros y eventos se cuentan en vivo con `COUNT`, así nunca quedan desactualizados.
- **`manuales`** — cifras como "~200 estudiantes en actividad deportiva" no corresponden a ningún registro individual del sistema, así que se editan a mano en `configuracion_institucional`.

## Endpoints

### Autenticación
| Método | Ruta | Acceso |
|---|---|---|
| POST | `/api/auth/login` | Público |
| POST | `/api/auth/activar` | Público (solo correos invitados) |
| POST | `/api/auth/verificar-pin` | Sesión |
| GET | `/api/auth/yo` | Sesión |
| POST | `/api/auth/invitar` | Admin |

### Usuarios
`GET /api/usuarios` · `GET /api/usuarios/roles` · `POST /api/usuarios/:id/roles` · `DELETE /api/usuarios/:id/roles/:rolId` · `PATCH /api/usuarios/:id/estado` — todos solo Admin

### Personal
| Método | Ruta | Acceso |
|---|---|---|
| GET | `/api/personal` (`?departamento=` `?buscar=` `?deportivo=true`) | Público |
| GET | `/api/personal/departamentos` | Público |
| GET | `/api/personal/:id` | Público |
| POST/PATCH/DELETE | `/api/personal/:id` | Admin + PIN |

### Publicaciones y comentarios
| Método | Ruta | Acceso |
|---|---|---|
| GET | `/api/publicaciones` (`?destacado=true`) | Público |
| GET | `/api/publicaciones/admin` | Sesión |
| GET | `/api/publicaciones/:id` | Público |
| POST/PATCH/DELETE | `/api/publicaciones/:id` | Sesión + PIN |
| GET | `/api/publicaciones/:id/comentarios` | Público |
| POST | `/api/publicaciones/:id/comentarios` | **Sesión** |
| GET | `/api/comentarios/admin` | Moderador |
| PATCH | `/api/comentarios/:id/estado` | Moderador + PIN |

### Académico
`GET /api/carreras` (con secciones anidadas) · `GET /api/secciones` · `GET /api/secciones/:id/horarios` (agrupado, listo para pintar) — públicos.
Escrituras: `gestionar_academico` + PIN.

### Deportes
| Método | Ruta | Acceso |
|---|---|---|
| GET | `/api/eventos-deportivos` (`?estado=` `?disciplina=` `?destacado=`) | Público |
| GET | `/api/disciplinas` · `/api/hitos-historicos` · `/api/logros` | Público |
| GET | `/api/estadisticas-deportivas` | Público |
| GET | `/api/testimonios` | Público (respeta anonimato) |
| GET | `/api/testimonios/admin` | Moderador (identidad real) |
| GET | `/api/equipos` · `/api/equipos/:id/integrantes` | Público (roster filtrado) |
| GET | `/api/equipos/:id/integrantes/admin` | Gestión (roster completo) |

### Proyectos futuros
| Método | Ruta | Acceso |
|---|---|---|
| GET | `/api/proyectos-futuros` | Público (solo aprobados) |
| POST | `/api/proyectos-futuros` | **Público** (peticiones de la comunidad) |
| GET | `/api/proyectos-futuros/admin` | Admin (todas) |
| PATCH | `/api/proyectos-futuros/:id` | Admin + PIN |

### Tienda y configuración
`GET /api/productos` · `GET /api/configuracion` — públicos. Escrituras solo Admin + PIN.

## Cómo agregar un módulo nuevo

1. Copiar `src/routes/eventos.routes.js` (es la plantilla del patrón).
2. Cambiar tabla, campos permitidos y claves de permiso.
3. Registrar la ruta en `src/server.js`.
4. Si Colaboradores pueden crearlo, la tabla necesita `creado_por` y el DELETE debe usar `requierePropiedad()`.

## Estructura

```
src/
  config/db.js              Pool MySQL (SSL para Aiven)
  middleware/auth.js        Sesión, permisos, PIN, regla de propiedad
  services/authService.js   Login, activación, PIN, invitaciones
  utils/crud.js             Helpers compartidos
  routes/                   12 módulos de endpoints
  server.js                 Arranque, CORS, rate limiting, errores
scripts/crear-admin.js      Alta del primer administrador
schema.sql                  Estructura
datos-reales.sql            Contenido real del instituto
cifras-deportivas.sql       Cifras editables del área deportiva
```
