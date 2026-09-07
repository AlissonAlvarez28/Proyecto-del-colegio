-- =====================================================================
-- ESQUEMA DE BASE DE DATOS
-- Sitio institucional — I.G.T. Francisco Miranda, Aldea Zambrano, M.D.C.
--
-- Motor: MySQL 8.x  (compatible con Aiven MySQL)
-- Generado a partir de las ETAPAS A-D del diseño de arquitectura.
--
-- ORDEN DE CREACIÓN: las tablas sin dependencias van primero; cada tabla
-- se crea solo después de aquellas a las que hace referencia por FK.
--
-- NOTA: este archivo NO inserta datos de contenido real. Solo crea la
-- estructura + los catálogos mínimos indispensables (roles y permisos),
-- que son estructura, no contenido editorial.
-- =====================================================================

-- En Aiven la base de datos normalmente ya viene creada; descomenta solo
-- si trabajas en un MySQL local.
-- CREATE DATABASE IF NOT EXISTS igtfm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- USE igtfm;


-- =====================================================================
-- BLOQUE 1 — CATÁLOGOS SIN DEPENDENCIAS
-- =====================================================================

CREATE TABLE departamentos (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(80)  NOT NULL UNIQUE,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE disciplinas (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(100) NOT NULL UNIQUE,
  descripcion     VARCHAR(255) NULL,
  icono           VARCHAR(50)  NULL,
  orden           INT          NOT NULL DEFAULT 0,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categorias_competencia (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(50)  NOT NULL UNIQUE,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE carreras (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(120) NOT NULL UNIQUE,
  tipo            ENUM('basica','tecnica') NOT NULL,
  descripcion     VARCHAR(255) NULL,
  icono           VARCHAR(50)  NULL,
  activa          BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE roles (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(50)  NOT NULL UNIQUE,
  descripcion     VARCHAR(255) NULL,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE permisos (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  clave           VARCHAR(80)  NOT NULL UNIQUE,
  descripcion     VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE productos (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(150)   NOT NULL,
  precio          DECIMAL(10,2)  NOT NULL,
  descripcion     TEXT           NULL,
  foto_url        VARCHAR(255)   NULL,
  disponible      BOOLEAN        NOT NULL DEFAULT TRUE,
  created_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_producto_precio CHECK (precio >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================================
-- BLOQUE 2 — PERSONAL  (depende de: departamentos)
-- =====================================================================

CREATE TABLE personal (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  nombre_completo    VARCHAR(150) NOT NULL,
  cargo              VARCHAR(150) NOT NULL,
  departamento_id    INT          NOT NULL,
  biografia          TEXT         NULL,
  materia            VARCHAR(150) NULL,
  anios_experiencia  INT          NULL,
  foto_url           VARCHAR(255) NULL,
  correo             VARCHAR(150) NULL UNIQUE,
  ubicacion          VARCHAR(150) NULL,
  horario_atencion   VARCHAR(150) NULL,
  activo             BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_personal_departamento
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_personal_experiencia CHECK (anios_experiencia IS NULL OR anios_experiencia >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_personal_departamento ON personal(departamento_id);
CREATE INDEX idx_personal_activo       ON personal(activo);


-- =====================================================================
-- BLOQUE 3 — SEGURIDAD  (depende de: personal, roles, permisos)
-- =====================================================================

CREATE TABLE usuarios (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  nombre_completo    VARCHAR(150) NOT NULL,
  correo             VARCHAR(150) NOT NULL UNIQUE,
  -- NULL mientras estado='invitado'; se llenan al activar la cuenta.
  -- SIEMPRE hash (bcrypt/argon2), NUNCA texto plano.
  contrasena_hash    VARCHAR(255) NULL,
  pin_hash           VARCHAR(255) NULL,
  personal_id        INT          NULL,
  estado             ENUM('invitado','activo','inactivo') NOT NULL DEFAULT 'invitado',
  invitado_por       INT          NULL,
  fecha_invitacion   DATETIME     NULL,
  fecha_activacion   DATETIME     NULL,
  ultimo_acceso      DATETIME     NULL,
  created_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_usuarios_personal
    FOREIGN KEY (personal_id) REFERENCES personal(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_usuarios_invitado_por
    FOREIGN KEY (invitado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_usuarios_estado ON usuarios(estado);

CREATE TABLE usuario_roles (
  usuario_id         INT      NOT NULL,
  rol_id             INT      NOT NULL,
  asignado_por       INT      NULL,
  fecha_asignacion   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usuario_id, rol_id),
  CONSTRAINT fk_usuario_roles_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_usuario_roles_rol
    FOREIGN KEY (rol_id) REFERENCES roles(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_usuario_roles_asignado_por
    FOREIGN KEY (asignado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rol_permisos (
  rol_id             INT NOT NULL,
  permiso_id         INT NOT NULL,
  PRIMARY KEY (rol_id, permiso_id),
  CONSTRAINT fk_rol_permisos_rol
    FOREIGN KEY (rol_id) REFERENCES roles(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rol_permisos_permiso
    FOREIGN KEY (permiso_id) REFERENCES permisos(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE refresh_tokens (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id         INT          NOT NULL,
  token_hash         VARCHAR(255) NOT NULL,
  expira_en          DATETIME     NOT NULL,
  created_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_refresh_tokens_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_refresh_tokens_usuario ON refresh_tokens(usuario_id);
CREATE INDEX idx_refresh_tokens_expira  ON refresh_tokens(expira_en);


-- =====================================================================
-- BLOQUE 4 — ACADÉMICO  (depende de: carreras)
-- =====================================================================

CREATE TABLE secciones_academicas (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  carrera_id      INT          NOT NULL,
  nombre          VARCHAR(80)  NOT NULL,
  jornada         ENUM('matutina','vespertina') NOT NULL,
  modalidad       VARCHAR(80)  NULL,
  cupo_maximo     INT          NULL,
  activa          BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_secciones_carrera
    FOREIGN KEY (carrera_id) REFERENCES carreras(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  -- Evita dos secciones con el mismo nombre y jornada dentro de una carrera
  CONSTRAINT uq_seccion_carrera UNIQUE (carrera_id, nombre, jornada),
  CONSTRAINT chk_seccion_cupo CHECK (cupo_maximo IS NULL OR cupo_maximo > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE horarios (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  seccion_id      INT          NOT NULL,
  dia             ENUM('lunes','martes','miercoles','jueves','viernes') NOT NULL,
  hora_inicio     TIME         NOT NULL,
  hora_fin        TIME         NOT NULL,
  materia         VARCHAR(100) NOT NULL,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_horarios_seccion
    FOREIGN KEY (seccion_id) REFERENCES secciones_academicas(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  -- Impide registrar dos materias en la misma franja de la misma sección
  CONSTRAINT uq_horario_franja UNIQUE (seccion_id, dia, hora_inicio),
  CONSTRAINT chk_horario_rango CHECK (hora_fin > hora_inicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_horarios_seccion_dia ON horarios(seccion_id, dia);


-- =====================================================================
-- BLOQUE 5 — DEPORTES  (depende de: personal, disciplinas, categorías, usuarios)
-- =====================================================================

CREATE TABLE personal_deportivo (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  personal_id       INT          NOT NULL,
  disciplina_id     INT          NULL,
  rol_deportivo     VARCHAR(150) NOT NULL,
  cita_destacada    TEXT         NULL,
  orden             INT          NOT NULL DEFAULT 0,
  created_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_personal_deportivo_personal
    FOREIGN KEY (personal_id) REFERENCES personal(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_personal_deportivo_disciplina
    FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_personal_deportivo_personal ON personal_deportivo(personal_id);

CREATE TABLE equipos (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  nombre          VARCHAR(120) NOT NULL,
  disciplina_id   INT          NOT NULL,
  categoria_id    INT          NOT NULL,
  descripcion     TEXT         NULL,
  activo          BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_equipos_disciplina
    FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_equipos_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias_competencia(id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_equipos_disciplina ON equipos(disciplina_id);

-- ---------------------------------------------------------------------
-- TABLA SENSIBLE: contiene nombres de estudiantes menores de edad.
-- `mostrar_publicamente` = FALSE por defecto: la API pública SOLO debe
-- exponer nombre_completo/foto_url de integrantes con este campo en TRUE.
-- Nunca hacer SELECT * hacia el frontend público desde esta tabla.
-- ---------------------------------------------------------------------
CREATE TABLE integrantes_equipo (
  id                    INT AUTO_INCREMENT PRIMARY KEY,
  equipo_id             INT          NOT NULL,
  nombre_completo       VARCHAR(150) NOT NULL,
  numero_camisa         INT          NULL,
  posicion              VARCHAR(50)  NULL,
  foto_url              VARCHAR(255) NULL,
  grado_seccion         VARCHAR(50)  NULL,
  mostrar_publicamente  BOOLEAN      NOT NULL DEFAULT FALSE,
  activo                BOOLEAN      NOT NULL DEFAULT TRUE,
  created_at            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at            DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_integrantes_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  -- Evita dos jugadores con el mismo número en un mismo equipo
  CONSTRAINT uq_integrante_dorsal UNIQUE (equipo_id, numero_camisa),
  CONSTRAINT chk_integrante_dorsal CHECK (numero_camisa IS NULL OR numero_camisa > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_integrantes_equipo_publico ON integrantes_equipo(equipo_id, mostrar_publicamente);

CREATE TABLE hitos_historicos (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  anio_periodo    VARCHAR(20)  NOT NULL,
  titulo          VARCHAR(150) NOT NULL,
  descripcion     TEXT         NOT NULL,
  imagen_url      VARCHAR(255) NULL,
  orden           INT          NOT NULL DEFAULT 0,
  creado_por      INT          NULL,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_hitos_creado_por
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE logros (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  titulo          VARCHAR(150) NOT NULL,
  descripcion     TEXT         NOT NULL,
  anio            VARCHAR(20)  NOT NULL,
  etiqueta        VARCHAR(80)  NULL,
  disciplina_id   INT          NULL,
  equipo_id       INT          NULL,
  creado_por      INT          NULL,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_logros_disciplina
    FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_logros_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_logros_creado_por
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE eventos_deportivos (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  titulo          VARCHAR(150) NOT NULL,
  rival           VARCHAR(150) NULL,
  disciplina_id   INT          NOT NULL,
  categoria_id    INT          NOT NULL,
  equipo_id       INT          NULL,
  fecha           DATETIME     NOT NULL,
  lugar           VARCHAR(150) NULL,
  estado          ENUM('proximo','jugado','cancelado') NOT NULL DEFAULT 'proximo',
  resultado       VARCHAR(50)  NULL,
  destacado       BOOLEAN      NOT NULL DEFAULT FALSE,
  creado_por      INT          NULL,
  created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_eventos_disciplina
    FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_eventos_categoria
    FOREIGN KEY (categoria_id) REFERENCES categorias_competencia(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_eventos_equipo
    FOREIGN KEY (equipo_id) REFERENCES equipos(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_eventos_creado_por
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Índice para la consulta más frecuente del sitio: próximos partidos por fecha
CREATE INDEX idx_eventos_estado_fecha ON eventos_deportivos(estado, fecha);
CREATE INDEX idx_eventos_disciplina   ON eventos_deportivos(disciplina_id);

-- ---------------------------------------------------------------------
-- TESTIMONIOS
-- usuario_id es NOT NULL incluso cuando es_anonimo = TRUE:
-- el anonimato es SOLO ante el público; administración siempre puede
-- rastrear al autor. La API pública debe devolver `descriptor_publico`
-- en lugar de la identidad cuando es_anonimo = TRUE.
-- ---------------------------------------------------------------------
CREATE TABLE testimonios (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  usuario_id          INT          NOT NULL,
  cita                TEXT         NOT NULL,
  rol_mostrado        VARCHAR(100) NULL,
  es_anonimo          BOOLEAN      NOT NULL DEFAULT FALSE,
  descriptor_publico  VARCHAR(150) NULL,
  disciplina_id       INT          NULL,
  estado              ENUM('pendiente','publicado','rechazado') NOT NULL DEFAULT 'pendiente',
  revisado_por        INT          NULL,
  fecha_revision      DATETIME     NULL,
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_testimonios_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_testimonios_disciplina
    FOREIGN KEY (disciplina_id) REFERENCES disciplinas(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_testimonios_revisado_por
    FOREIGN KEY (revisado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  -- Si se publica como anónimo, DEBE existir un descriptor público que mostrar
  CONSTRAINT chk_testimonio_anonimo
    CHECK (es_anonimo = FALSE OR descriptor_publico IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_testimonios_estado ON testimonios(estado);


-- =====================================================================
-- BLOQUE 6 — PUBLICACIONES Y COMENTARIOS  (depende de: personal, usuarios)
-- =====================================================================

CREATE TABLE publicaciones (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  titulo              VARCHAR(200) NOT NULL,
  resumen             VARCHAR(300) NULL,
  contenido           TEXT         NOT NULL,
  imagen_portada      VARCHAR(255) NULL,
  autor_id            INT          NULL,
  creado_por          INT          NULL,
  estado              ENUM('borrador','publicado') NOT NULL DEFAULT 'borrador',
  destacado           BOOLEAN      NOT NULL DEFAULT FALSE,
  fecha_publicacion   DATETIME     NULL,
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_publicaciones_autor
    FOREIGN KEY (autor_id) REFERENCES personal(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_publicaciones_creado_por
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Consulta más frecuente del blog: publicadas, ordenadas por fecha
CREATE INDEX idx_publicaciones_estado_fecha ON publicaciones(estado, fecha_publicacion);
CREATE INDEX idx_publicaciones_destacado    ON publicaciones(destacado, estado);

-- ---------------------------------------------------------------------
-- COMENTARIOS
-- Ahora requieren cuenta (usuario_id NOT NULL), igual que los testimonios.
-- Mismo modelo de anonimato: público no ve identidad si es_anonimo=TRUE,
-- pero administración y docentes siempre pueden rastrearla.
-- ---------------------------------------------------------------------
CREATE TABLE comentarios (
  id                  INT AUTO_INCREMENT PRIMARY KEY,
  publicacion_id      INT          NOT NULL,
  usuario_id          INT          NOT NULL,
  mensaje             TEXT         NOT NULL,
  rol_mostrado        VARCHAR(80)  NULL,
  es_anonimo          BOOLEAN      NOT NULL DEFAULT FALSE,
  descriptor_publico  VARCHAR(150) NULL,
  estado              ENUM('visible','oculto') NOT NULL DEFAULT 'visible',
  moderado_por        INT          NULL,
  created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_comentarios_publicacion
    FOREIGN KEY (publicacion_id) REFERENCES publicaciones(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_comentarios_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_comentarios_moderado_por
    FOREIGN KEY (moderado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_comentario_anonimo
    CHECK (es_anonimo = FALSE OR descriptor_publico IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_comentarios_publicacion ON comentarios(publicacion_id, estado);


-- =====================================================================
-- BLOQUE 7 — PROYECTOS FUTUROS / PETICIONES  (depende de: usuarios)
-- =====================================================================

CREATE TABLE proyectos_futuros (
  id                   INT AUTO_INCREMENT PRIMARY KEY,
  titulo               VARCHAR(150) NOT NULL,
  descripcion          TEXT         NOT NULL,
  origen               ENUM('peticion_comunidad','iniciativa_admin') NOT NULL DEFAULT 'peticion_comunidad',
  solicitante_nombre   VARCHAR(100) NULL,
  solicitante_rol      VARCHAR(80)  NULL,
  estado               ENUM('pendiente','en_revision','aprobado','en_gestion','completado','rechazado')
                       NOT NULL DEFAULT 'pendiente',
  respuesta_admin      TEXT         NULL,
  revisado_por         INT          NULL,
  fecha_revision       DATETIME     NULL,
  created_at           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at           DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_proyectos_revisado_por
    FOREIGN KEY (revisado_por) REFERENCES usuarios(id)
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- El sitio público filtra por estado; este índice sostiene esa consulta
CREATE INDEX idx_proyectos_estado ON proyectos_futuros(estado);


-- =====================================================================
-- BLOQUE 8 — CONFIGURACIÓN INSTITUCIONAL
-- Un solo registro: datos de contacto, redes sociales, etc.
-- =====================================================================

CREATE TABLE configuracion_institucional (
  id                 INT AUTO_INCREMENT PRIMARY KEY,
  clave              VARCHAR(80)  NOT NULL UNIQUE,
  valor              TEXT         NULL,
  descripcion        VARCHAR(255) NULL,
  updated_at         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =====================================================================
-- BLOQUE 9 — CATÁLOGOS BASE (estructura, no contenido editorial)
-- Sin esto el sistema de permisos no puede funcionar.
-- =====================================================================

INSERT INTO roles (nombre, descripcion) VALUES
  ('Administrador', 'Acceso total, incluida la gestion de usuarios y roles'),
  ('Colaborador',   'Puede crear y editar contenido; no elimina contenido ajeno ni gestiona usuarios');

INSERT INTO permisos (clave, descripcion) VALUES
  ('gestionar_usuarios',          'Invitar, activar y desactivar cuentas'),
  ('gestionar_roles_permisos',    'Asignar roles y permisos a usuarios'),
  ('gestionar_personal',          'Alta, edicion y baja del personal'),
  ('crear_publicacion',           'Crear publicaciones del blog'),
  ('editar_publicacion',          'Editar publicaciones existentes'),
  ('eliminar_publicacion',        'Eliminar cualquier publicacion'),
  ('moderar_comentarios',         'Ocultar o mostrar comentarios'),
  ('crear_evento_deportivo',      'Registrar partidos y competencias'),
  ('editar_evento_deportivo',     'Editar eventos deportivos'),
  ('eliminar_evento_deportivo',   'Eliminar cualquier evento deportivo'),
  ('crear_hito_historico',        'Agregar hitos a la linea de tiempo'),
  ('crear_logro',                 'Registrar logros y reconocimientos'),
  ('crear_testimonio',            'Publicar testimonios propios'),
  ('moderar_testimonio',          'Aprobar o rechazar testimonios'),
  ('gestionar_proyectos_futuros', 'Revisar y responder peticiones de mejora'),
  ('gestionar_equipos',           'Administrar equipos e integrantes'),
  ('gestionar_academico',         'Administrar carreras, secciones y horarios'),
  ('gestionar_productos',         'Administrar la tienda escolar');

-- Administrador: todos los permisos
INSERT INTO rol_permisos (rol_id, permiso_id)
SELECT r.id, p.id FROM roles r CROSS JOIN permisos p WHERE r.nombre = 'Administrador';

-- Colaborador: solo permisos de creacion/edicion de contenido operativo
INSERT INTO rol_permisos (rol_id, permiso_id)
SELECT r.id, p.id FROM roles r JOIN permisos p
  ON p.clave IN (
    'crear_publicacion', 'editar_publicacion',
    'crear_evento_deportivo', 'editar_evento_deportivo',
    'crear_hito_historico', 'crear_logro', 'crear_testimonio'
  )
WHERE r.nombre = 'Colaborador';

-- Departamentos observados en el directorio actual de personal
INSERT INTO departamentos (nombre) VALUES
  ('Direccion'), ('Secretaria'), ('Docentes'), ('Consejeria'), ('Mantenimiento');

-- Categorias de competencia observadas en la seccion de deportes
INSERT INTO categorias_competencia (nombre) VALUES
  ('U15'), ('U16'), ('U17'), ('Bachillerato'), ('Libre');

-- =====================================================================
-- FIN DEL ESQUEMA
--
-- SIGUIENTE PASO MANUAL (NO incluido aqui a proposito):
-- crear el primer usuario Administrador ejecutando el script
-- `scripts/crear-admin.js`, que pide el correo y la contrasena por
-- consola y guarda unicamente el hash. Nunca escribas una contrasena
-- real dentro de un archivo .sql versionado en Git.
-- =====================================================================
