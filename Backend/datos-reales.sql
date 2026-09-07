-- =====================================================================
-- DATOS REALES — I.G.T. Francisco Miranda
--
-- Contenido migrado desde el sitio existente y desde las entrevistas
-- realizadas al Prof. Manuel Pineda y a la Entrenadora de Fútbol Femenino.
--
-- REQUISITO: ejecutar schema.sql ANTES que este archivo.
-- Los catálogos base (roles, permisos, departamentos, categorías)
-- ya vienen creados por schema.sql y aquí solo se referencian.
-- =====================================================================

SET NAMES utf8mb4;
START TRANSACTION;

-- ============================================================
-- PERSONAL (42 registros reales del directorio institucional)
-- ============================================================
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Juan Carlos Herrera Espinoza', 'Director de la Institución', d.id, 'Nació el 12 de enero de 1977 y labora en la institución desde 2007. Es Maestro en Educación Primaria y Licenciado en Ciencias con Orientación en Matemática por la UPNFM, y actualmente finaliza su tesis de Maestría en Matemática Educativa. Se le reconoce por liderar la transformación y fortalecimiento del instituto.', 'Dirección Institucional & Administración', 18, 'img.png/Juan Carlois.jpeg', 'direccion@igtfm.edu.hn', 'Edificio Principal - Dirección', 'Lun - Vie: 7:00 AM - 1:00 PM'
FROM departamentos d WHERE d.nombre = 'Direccion';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Juan Andrés Izaguirre Gonzáles', 'Subdirector', d.id, 'Asumió el cargo el 1 de septiembre de 2020. Cuenta con Maestría en Educación Primaria, Licenciatura en Pedagogía y Ciencias de la Educación, y estudios en la carrera de Derecho.', 'Supervisión Docente y Gestión Administrativa', 5, 'img.png/Juan Izaguirre.png', 'subdireccion@igtfm.edu.hn', 'Edificio Principal - Subdirección', 'Lun - Vie: 7:00 AM - 1:00 PM'
FROM departamentos d WHERE d.nombre = 'Direccion';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Lesby Elieth Medina Agurcia', 'Secretaria General', d.id, 'Licenciada en Pedagogía (Planeamiento y Administración). Secretaria General desde 2003. Ha sido clave en la gestión académica, la creación de nuevas carreras (Informática, Agroindustria) y la administración de beneficios sociales para el personal.', 'Atención a estudiantes y padres de familia', NULL, 'img.png/Elieth Medina.jpeg', 'secretaria@igtfm.edu.hn', 'Oficina de Secretaría General', 'Lun - Vie: 7:00 AM - 12:00 PM'
FROM departamentos d WHERE d.nombre = 'Secretaria';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Marisabel Rosales', 'Asistente de Orientación', d.id, 'Licenciada en Pedagogía y Ciencias de la Educación. Encargada del acompañamiento psicopedagógico, liderazgo del gobierno estudiantil, escuela para padres y campañas de prevención de violencia.', 'Acompañamiento Psicopedagógico', NULL, 'img.png/Marisabel Rosales.jpg', 'asistencia.secretaria@igtfm.edu.hn', 'Oficina de Orientación', 'Lun - Vie: 7:00 AM - 1:00 PM'
FROM departamentos d WHERE d.nombre = 'Secretaria';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Katia Patricia Osorto Galo', 'Asistente Administrativo y Docente', d.id, 'Con más de 30 años de trayectoria. Combina su labor como asistente de secretaría (desde 2016) con la docencia de inglés (desde 2004) y educación primaria.', 'Atención Institucional', 30, 'img.png/Katia Patricia Osorto Galo.jpeg', 'administracion@igtfm.edu.hn', 'Modulo Administrativo', 'Lun - Vie: 7:00 AM - 1:00 PM'
FROM departamentos d WHERE d.nombre = 'Secretaria';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Junior Josué López Montes', 'Jefe Consejero de Estudiantes', d.id, 'Se destaca por su continua continuidad en estudios superiores y su formación profesional constante dentro del ámbito educativo de la institución.', 'Consejería y Orientación Estudiantil', NULL, 'img.png/Junior Josue Lopez Montes.jpeg', 'consejeria.jefe@igtfm.edu.hn', 'Oficina de Consejería Estudiantil', 'Jornada Completa'
FROM departamentos d WHERE d.nombre = 'Consejeria';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Marlon Noel Izaguirre Velásquez', 'Consejero de Estudiantes', d.id, 'Licenciado en Educación Comercial. Docente de Informática y Agroindustria, y Consejero Estudiantil desde 2020. Líder en proyectos de infraestructura (cafetería, kiosko) y extensión comunitaria (T.E.S.).', 'Orden, Disciplina y Acompañamiento', 17, 'img.png/Marlon Izaguirre.png', 'consejeria.marlon@igtfm.edu.hn', 'Oficina de Consejería Estudiantil', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Consejeria';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Irma Yolanda Erazo Lagos', 'Consejera de Estudiantes', d.id, 'Licenciada en Pedagogía y Perito Mercantil. Se desempeña como Consejera de Estudiantes enfocándose en disciplina, rendimiento académico y asistencia. Cuenta con trayectoria en trabajo social y participación política.', 'Mantener el orden y atención estudiantil', 2, 'img.png/Irma Yolanda Erazo Lagos.jpeg', 'consejeria.irma@igtfm.edu.hn', 'Oficina de Consejería Estudiantil', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Consejeria';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Wilmer Javier Aguilar Domínguez', 'Docente de Informática', d.id, 'Licenciado en Informática Educativa con especialidad en Robótica. Encargado de la carrera de Informática, fundador del laboratorio de robótica y gestor de éxitos institucionales en ferias de ciencias.', 'Carrera de Informática y Programación', 15, 'img.png/Wilmer Javier Aguilar Dominguez.jpeg', 'wilmer.aguilar@igtfm.edu.hn', 'Laboratorio de Computación #1', 'Clases Presenciales & Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Ana Gabriela Simona Zelaya', 'Docente de Matemáticas', d.id, 'Nacida el 31 de julio de 1990 (35 años), es Licenciada en Matemáticas por la UPNFM. Con 12 años de trayectoria en el centro (2014-2026), imparte Matemáticas, Física y Dibujo Técnico. Ampliamente reconocida por impulsar el talento juvenil como tutora y jurado en las Olimpiadas de Matemáticas a nivel nacional.', 'Matemáticas, Física y Dibujo Técnico', 12, 'img.png/Ana Simons.png', 'ana.zelaya@igtfm.edu.hn', 'Edificio de Aulas 2', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Fredis Armando Domínguez Medina', 'Docente de Matemáticas y Administración', d.id, 'Cuenta con 19 años en la institución. Posee una Licenciatura en Matemática por la UPNFM y una Licenciatura en Economía por la UNAH. Ejerce como docente de matemáticas y cumple funciones administrativas.', 'Matemáticas y Área de Administración', 19, 'img.png/Fredy Dominguez.jpeg', 'fredis.dominguez@igtfm.edu.hn', 'Edificio de Aulas 1', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Celeste María Machuca Tejada', 'Docente de Ciencias Naturales', d.id, 'Profesora y Licenciada en Ciencias Naturales con orientación en Química, Física y Biología, y especialista en Tecnología y Alimentos. Con 9 años de servicio, asiste y coordina el laboratorio de ciencias.', 'Ciencias Naturales, Química, Física y Biología', 9, 'img.png/Ceteste Machuca.jpg', 'celeste.machuca@igtfm.edu.hn', 'Laboratorio de Ciencias', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Fátima Yaneth Rodríguez', 'Docente BTP Contaduría y Finanzas', d.id, 'Con 56 años de edad y 18 años de servicio en el instituto. Imparte asignaturas del área comercial como Administración General, Gestión Empresarial, Economía y Legislación. Además, coordina el programa TES y apoya en funciones de consejería estudiantil.', 'Administración, Economía, Contabilidad, Auditoría', 18, 'img.png/Profe Fátima.jpg', 'fatima.rodriguez@igtfm.edu.hn', 'Aula BTP Finanzas', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Suyapa Janeth Pineda López', 'Docente Comercial', d.id, 'Docente de las asignaturas de Legislación Mercantil, Aduanas, Contaduría de Costos e Informática Contable. Enfocándose en fortalecer los conocimientos jurídicos, administrativos, contables y tecnológicos para el ámbito empresarial.', 'Legislación Mercantil, Aduanas, Contabilidad de Costos', 3, 'img.png/Suyapa Janeth Pineda Lopez.png', 'suyapa.pineda@igtfm.edu.hn', 'Aula BTP Comercio', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'María De La Paz Álvarez Yanes', 'Coordinadora de Prácticas Profesionales', d.id, 'Licenciada por la UPNFM. Maestra de Educación Media en Comercio y actualmente coordinadora de prácticas profesionales del Instituto Técnico Francisco Miranda.', 'Contabilidad, Adm. Financiera, Tributaria, Servicio al Cliente', NULL, 'img.png/Maria de la paz Álvarez.png', 'maria.alvarez@igtfm.edu.hn', 'Coordinación de Prácticas', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Miriam Janeth Torres Castillo', 'Coordinadora BTP Agroindustria', d.id, 'Ingeniera Industrial. Docente del área de Ciencias Naturales y carrera de Ingeniería en Producción Industrial. Se enfoca en la sostenibilidad agroindustrial, investigación y transferencia tecnológica.', 'Coordinación Académica y BTP Agroindustria', NULL, 'img.png/Miriam Janeth Ortez Novoa.png', 'miriam.torres@igtfm.edu.hn', 'Coordinación Agroindustrial', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Francis Elizabeth Moncada Silva', 'Docente Taller de Hogar', d.id, 'Nacida el 8 de abril de 1970, con 21 años de servicio en la institución. Es Licenciada en Taller de Hogar (Belleza, Cosmetología, Corte, Nutrición y Alimentos) por la UPNFM.', 'Nutrición, Taller de Hogar y Corte y Confección', 21, 'img.png/Profe Francis.jpg', 'francis.moncada@igtfm.edu.hn', 'Taller de Hogar y Nutrición', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Luis Eduardo Salgado Benítez', 'Docente del Área Agroindustrial', d.id, 'Ingeniero Agrónomo. Docente del área agroindustrial con proyectos activos de siembra (maíz y frijol), crianza de animales (cerdos y gallinas) y planes a futuro en sistemas de acuaponía.', 'Ciencias Agroindustriales', NULL, 'img.png/Luis Salgado.png', 'luis.salgado@igtfm.edu.hn', 'Área Agroindustrial', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Wendy Patricia Andino Amador', 'Docente de Ciencias Sociales', d.id, 'Licenciada en Educación Primaria y Ciencias Sociales con Maestría en Administración de Proyectos. Reconocida por su gestión en el ''Movimiento Juventud'' y el proyecto ''¡Viva la Juventud!''', 'Sociología, Historia de Honduras, Cívica', 11, 'img.png/Wendy Patricia Andino Amador.jpeg', 'wendy.andino@igtfm.edu.hn', 'Edificio de Aulas 1', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Jenny Roseli Sosa Chávez', 'Docente de Inglés', d.id, 'Docente con más de 17 años de experiencia (en la institución desde marzo de 2009). Licenciada en la Enseñanza del Inglés por la UPNFM, Perito Mercantil y Contador Público.', 'Idioma Inglés Institucional', 17, 'img.png/Jenny Sosa.png', 'jenny.sosa@igtfm.edu.hn', 'Edificio de Aulas 3', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Mayra Alejandra Martínez Aguilar', 'Docente de Español', d.id, 'Licenciada en Letras y Lenguas Españolas (Español) por la UPNFM. Se especializa en el fortalecimiento de la oratoria, expresión oral y técnicas de comunicación efectiva.', 'Lengua Española y Literatura', 11, 'img.png/Docente Mayra Alejandra Martines Aguilar.jpg', 'mayra.martinez@igtfm.edu.hn', 'Edificio de Aulas 2', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Ada Lizeth Ordóñez Martínez', 'Docente de Español', d.id, 'Licenciada en la Enseñanza del Español y con una Maestría en Lenguas y Cultura por la UNAH. Más de 20 años de experiencia docente e investigativa en el instituto.', 'Lengua Española y Literatura', 20, 'img.png/Ada Lizeth Ordóñez.png', 'ada.ordonez@igtfm.edu.hn', 'Edificio de Aulas 2', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Karen Leticia Sánchez Bautista', 'Docente de Ciencias Sociales', d.id, 'Licenciada en Ciencias Sociales con 27 años de experiencia (25 en esta institución). Graduada de la Escuela Normal Mixta Pedro Nufio. Ha liderado eventos cívicos como el Día de las Américas y de la Independencia.', 'Ciencias Sociales, Ed. Cívica, Psicología, Filosofía', 25, 'img.png/Karen Sanchez.png', 'karen.sanchez@igtfm.edu.hn', 'Edificio de Aulas 1', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Gabriela Arely Beltrán Rodríguez', 'Docente Ed. Artística', d.id, 'Nacida el 5 de diciembre de 1992 y vinculada al centro desde el 1 de abril de 2024. Cuenta con 14 años de trayectoria docente. Profesora de Educación Artística especializada en Artes Musicales por la UPNFM.', 'Educación Artística con orientación Musical', 14, 'img.png/Gabriela Rodriguez.jpeg', 'gabriela.beltran@igtfm.edu.hn', 'Salón de Música y Arte', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'José Manuel Pineda Gámez', 'Director Banda Latina FM', d.id, 'Ingresó en 2013. Maestro de Educación Primaria en Educación Musical por la Escuela Nacional de Música, Licenciado en Artes con orientación en Música por la UPNFM y pasante de Maestría en Gestión Cultural.', 'Director Artístico de la Banda Francisco Miranda', 12, 'img.png/manuel pineda.jpg', 'manuel.pineda@igtfm.edu.hn', 'Salón Recreativo / Banda Latina', 'Horario Ensayo y Clases'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Enedas Alfonso Berríos Alvarado', 'Docente Taller de Madera', d.id, 'Maestro de Educación Primaria, Bachiller en Educación, Licenciado en Educación Básica y en Educación Técnica Industrial. Con 16 años como docente y una antigüedad total de 31 años.', 'Taller de Madera y Carpintería', 31, 'img.png/Enedas Berrios.jpeg', 'enedas.berrios@igtfm.edu.hn', 'Área de Talleres - Madera', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Cloevin Fabricio Yánez Santos', 'Docente Estructuras Metálicas', d.id, 'Maestro de Educación Primaria, Licenciado en Educación Tecnológica con orientación en Mecánica Industrial y Maestría en Proyectos. Reconocido como Docente del Año (2018), instructor certificado por el INFOP.', 'Taller de Estructuras Metálicas', NULL, 'img.png/Fabrio yanez.png', 'cloevin.yanez@igtfm.edu.hn', 'Área de Talleres - Estructuras Metálicas', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Vanessa Lizeth Galindo Velásquez', 'Docente Estructuras Metálicas', d.id, 'Licenciada en Educación Técnica Industrial (Metal Mecánica). Imparte Estructuras Metálicas y Dibujo Técnico. Destaca por su enfoque en proyectos institucionales de reciclaje.', 'Estructuras Metálicas y Dibujo Técnico', 3, 'img.png/Vanessa Lizeth galindo Velasquez.png', 'vanessa.galindo@igtfm.edu.hn', 'Área de Talleres - Estructuras', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Heydy Vanessa González García', 'Docente Estructuras Metálicas', d.id, 'Licenciada en Educación Técnica Industrial con orientación en Metal Mecánica por la UPNFM. Docente desde 2009. Destaca por su disciplina y compromiso con la enseñanza práctica.', 'Taller de Estructuras Metálicas y Dibujo Técnico', NULL, 'img.png/Heydy Vanessa Gonzales Garcia.jpeg', 'heydy.gonzalez@igtfm.edu.hn', 'Área de Talleres - Estructuras', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Edwin Geovanny Raudales Lanza', 'Docente Taller de Madera', d.id, 'Nacido el 22 de julio de 1983. Especialista y formado en Carpintería y Ebanistería. Actualmente cursa la carrera de Educación Tecnológica orientada en Madera en la UPNFM.', 'Taller de Madera y Carpintería', NULL, 'img.png/Edwin Geovani Raudales Lanza.png', 'edwin.raudales@igtfm.edu.hn', 'Área de Talleres - Madera', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Christian Obed Medina Alvarado', 'Docente Dibujo Técnico y Taller de Electricidad', d.id, 'Licenciado en Educación Tecnológica Industrial con orientación en Electricidad. Con 9 años de experiencia general en el sector eléctrico. Exvicepresidente de la carrera de Educación Tecnológica en la UPNFM y contratista independiente.', 'Dibujo Técnico Industrial y Taller de Electricidad', 9, 'img.png/CHRISTIAN MEDINA.jpeg', 'christian.medina@igtfm.edu.hn', 'Aula de Dibujo Técnico y Taller de Electricidad', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Mario Leonel Ávila Maradiaga', 'Docente Dibujo Técnico / Electricidad', d.id, 'Licenciado en Educación Tecnológica, Diplomado en Gestión Administrativa. Licenciado en Educación Tecnológica Industrial.', 'Dibujo Técnico y Taller de Electricidad', 11, 'img.png/Mario leonel avila maradiaga.png', 'mario.avila@igtfm.edu.hn', 'Taller de Electricidad', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Rodyn Javier Figueroa Osorto', 'Docente Taller de Madera', d.id, 'Perfil multidisciplinario con Ingeniería Industrial, Licenciatura en Metalmecánica y Maestría en Cerámica y Metalurgia. Con cerca de 48 años de trayectoria, imparte Carpintería y Dibujo Técnico.', 'Carpintería y Dibujo Técnico', 48, 'img.png/Rodyn Javier Figueroa Osorto.png', 'rodyn.figueroa@igtfm.edu.hn', 'Área de Talleres - Madera', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Valeska Yamileth Mejía', 'Docente Orientadora', d.id, 'Licenciada en Educación Técnica Industrial con orientación en Madera. Docente con trayectoria desde 1998, asignada al departamento de orientación desde 2013.', 'Orientación y Taller de Madera', NULL, 'img.png/Valeska Yamileth Mejia.png', 'valeska.mejia@igtfm.edu.hn', 'Oficina de Orientación', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Wilmer Alexis Guevara Cárdenas', 'Docente de Ciencias Naturales', d.id, 'Licenciado en Ciencias Naturales con especialidad en Biología y Química. Trayectoria de 18 años como docente en la institución.', 'Ciencias Naturales, Biología, Química y Física', 18, 'img.png/wilmer Alexis Guebara Cardenas.png', 'wilmer.guevara@igtfm.edu.hn', 'Laboratorio de Ciencias', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Santiago Humberto Fúnez Zúniga', 'Docente de Educación Física', d.id, 'Perito Mercantil, Contador Público y Licenciado en Educación Física. Docente de educación media con nueve años de antigüedad en la institución.', 'Educación Física y Deportes', 9, 'img.png/Santiago Funez.png', 'santiago.funez@igtfm.edu.hn', 'Cancha Deportiva', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Carlos Fernando Medina', 'Jefe de Orientación', d.id, 'Maestro de Educación Primaria (2009), Licenciado en Orientación Educativa (2016) con Maestrías en Transformación Digital y Negocios.', 'Orientación y Bienestar Estudiantil', NULL, 'img.png/Carlos Fernando Medina.jpg', 'carlos.medina@igtfm.edu.hn', 'Departamento de Orientación', 'Jornada Matutina'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Danilo José Banegas Figueroa', 'Docente de Talleres', d.id, 'Licenciado en Educación Técnica Industrial y estudiante de Derecho.', 'Taller de Madera y Estructuras Metálicas', NULL, 'img.png/Danilo Jose Banegas Figueroa.png', 'danilo.banegas@igtfm.edu.hn', 'Área de Talleres', 'Jornada Taller'
FROM departamentos d WHERE d.nombre = 'Docentes';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Juan Carlos Cruz Silva', 'Conserje / Vigilancia', d.id, 'Personal de Apoyo', 'Vigilancia e Instalaciones', 25, 'img.png/Juan Carlos Cruz Silva.png', 'mantenimiento@igtfm.edu.hn', 'Acceso Principal e Instalaciones', 'Turno Rotativo'
FROM departamentos d WHERE d.nombre = 'Mantenimiento';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Nelcy Dinora Rápalo Vizcaíno', 'Conserje (Aseo)', d.id, 'Personal de Apoyo', 'Limpieza y Aseo Institucional', 14, 'img.png/Nelcy Dinora Rapalo Vizcaino.png', 'servicio.aseo@igtfm.edu.hn', 'Módulos Educativos y Aulas', 'Turno Matutino'
FROM departamentos d WHERE d.nombre = 'Mantenimiento';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Walter José Acosta Cálix', 'Conserje (Vigilancia)', d.id, 'Personal de Apoyo', 'Vigilancia e Instalaciones', 2, 'img.png/Walter Jose Acosta Calix.png', 'vigilancia@igtfm.edu.hn', 'Caseta de Seguridad y Portón', 'Turno Rotativo'
FROM departamentos d WHERE d.nombre = 'Mantenimiento';
INSERT INTO personal (nombre_completo, cargo, departamento_id, biografia, materia, anios_experiencia, foto_url, correo, ubicacion, horario_atencion)
SELECT 'Susy', 'Personal de Aseo', d.id, 'Personal de Apoyo', 'Área de Vigilancia y Aseo', 2, 'img.png/Susy.png', 'apoyo.limpieza@igtfm.edu.hn', 'Módulos Educativos', 'Turno Matutino'
FROM departamentos d WHERE d.nombre = 'Mantenimiento';

-- ============================================================
-- DISCIPLINAS DEPORTIVAS (6, según la entrevista)
-- ============================================================
INSERT INTO disciplinas (nombre, descripcion, icono, orden) VALUES ('Fútbol masculino', 'Ciclo básico y bachillerato · U15/U17 según torneo', 'fa-futbol', 1);
INSERT INTO disciplinas (nombre, descripcion, icono, orden) VALUES ('Fútbol femenino', 'Ciclo básico y bachillerato · referente del instituto', 'fa-futbol', 2);
INSERT INTO disciplinas (nombre, descripcion, icono, orden) VALUES ('Baloncesto', 'Cuadro representativo institucional', 'fa-basketball', 3);
INSERT INTO disciplinas (nombre, descripcion, icono, orden) VALUES ('Voleibol', 'Cuadro representativo institucional', 'fa-volleyball', 4);
INSERT INTO disciplinas (nombre, descripcion, icono, orden) VALUES ('Atletismo', 'CODICADER y torneos interinstitucionales', 'fa-person-running', 5);
INSERT INTO disciplinas (nombre, descripcion, icono, orden) VALUES ('Ajedrez y Tenis de Mesa', 'Se trabajan en Educación Física', 'fa-chess', 6);

-- ============================================================
-- PERSONAL DEPORTIVO (extiende a personal, no lo duplica)
-- Nota: la encargada de fútbol femenino se registra por su ROL,
-- sin nombre, según la decisión de privacidad tomada en el proyecto.
-- ============================================================
INSERT INTO personal_deportivo (personal_id, disciplina_id, rol_deportivo, cita_destacada, orden)
SELECT p.id, d.id, 'Asistente técnico de fútbol (masculino y femenino)', 'El deporte es salud.', 1
FROM personal p, disciplinas d
WHERE p.nombre_completo LIKE '%Manuel%' AND d.nombre = 'Fútbol masculino' LIMIT 1;
INSERT INTO personal_deportivo (personal_id, disciplina_id, rol_deportivo, cita_destacada, orden)
SELECT p.id, d.id, 'Educación Física · Colaborador histórico del área', NULL, 3
FROM personal p, disciplinas d
WHERE p.nombre_completo LIKE '%Santiago%' AND d.nombre = 'Fútbol masculino' LIMIT 1;
INSERT INTO personal_deportivo (personal_id, rol_deportivo, cita_destacada, orden)
SELECT p.id, 'Subdirección · Gestión de transporte y logística', NULL, 5
FROM personal p WHERE p.nombre_completo LIKE '%Izaguirre%' LIMIT 1;

-- Encargada de fútbol femenino: registrada solo por su cargo.
-- Si la institución autoriza publicar su nombre, basta con enlazarla
-- a su ficha de `personal` como se hizo con los demás.

-- ============================================================
-- EQUIPOS REPRESENTATIVOS
-- El roster (integrantes_equipo) NO se migra: debe cargarse desde
-- el panel, con autorización explícita por estudiante.
-- ============================================================
INSERT INTO equipos (nombre, disciplina_id, categoria_id, descripcion)
SELECT 'Selección Femenina de Fútbol', d.id, c.id, 'Campeona del torneo de la Universidad Católica y cuartos de final en CODICADER.'
FROM disciplinas d, categorias_competencia c
WHERE d.nombre = 'Fútbol femenino' AND c.nombre = 'U17';
INSERT INTO equipos (nombre, disciplina_id, categoria_id, descripcion)
SELECT 'Selección Masculina de Bachillerato', d.id, c.id, 'Primera de grupo en el torneo de la Semana de la Juventud.'
FROM disciplinas d, categorias_competencia c
WHERE d.nombre = 'Fútbol masculino' AND c.nombre = 'Bachillerato';
INSERT INTO equipos (nombre, disciplina_id, categoria_id, descripcion)
SELECT 'Selección Masculina de Ciclo Básico', d.id, c.id, NULL
FROM disciplinas d, categorias_competencia c
WHERE d.nombre = 'Fútbol masculino' AND c.nombre = 'U15';

-- ============================================================
-- LÍNEA DE TIEMPO (datos reales de la entrevista)
-- ============================================================
INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, orden) VALUES ('~2010', 'Los primeros cuadros', 'Los equipos del instituto empiezan a tomar forma a partir de los torneos improvisados de los recreos: el punto de partida de todo lo que vendría después.', 1);
INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, orden) VALUES ('~2015', 'El salto a la competencia formal', 'El instituto empieza a competir oficialmente fuera de sus instalaciones. Arranca la trayectoria competitiva que hoy suma más de una década.', 2);
INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, orden) VALUES ('2018–2019', 'Semifinalistas', 'El equipo llega a semifinales en el torneo de la Secretaría de Educación y cae por penales ante el equipo que, más tarde, se coronaría campeón.', 3);
INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, orden) VALUES ('Después de 2020', 'Nace el fútbol femenino', 'Todo comenzó con la pregunta de una estudiante: ¿por qué solo los varones podían representar al instituto? De esa inquietud, impulsada por la encargada del área, nace el equipo femenino de fútbol.', 4);
INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, orden) VALUES ('2024', 'Nace la Copa Amistad', 'El equipo femenino se consolida. De un campeonato disputado en octubre nace la Copa Amistad de Fútbol Femenino, torneo propio del instituto.', 5);
INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, orden) VALUES ('2025', 'Subcampeones, con la FIFA de testigo', 'Final cerrada 3-2 en el torneo interinstitucional: subcampeonato con trofeo y medallas. En ese mismo torneo hubo presencia de personas vinculadas a la FIFA, y un estudiante fue invitado a una prueba con un equipo.', 6);
INSERT INTO hitos_historicos (anio_periodo, titulo, descripcion, orden) VALUES ('2026', 'Goleadas, campeonato y cuartos de CODICADER', 'La selección de bachillerato termina 1ª de grupo en el torneo de la Semana de la Juventud —con goleadas de hasta 9-0— y cae en cuartos por penales ante el Instituto Salesiano San Miguel. La selección femenina se corona campeona del torneo de la Universidad Católica y llega a cuartos de final en CODICADER.', 7);

-- ============================================================
-- VITRINA DE LOGROS
-- ============================================================
INSERT INTO logros (titulo, descripcion, anio, etiqueta, disciplina_id)
SELECT 'Campeonas — Torneo Universidad Católica', 'La selección femenina se coronó campeona por encima de centros educativos públicos y privados.', '2026', 'Fútbol femenino', di.id
FROM disciplinas di WHERE di.nombre = 'Fútbol femenino';
INSERT INTO logros (titulo, descripcion, anio, etiqueta, disciplina_id)
SELECT 'Subcampeones interinstitucionales', 'Final cerrada 3-2, con trofeo y medallas de plata, en un torneo con presencia de personas vinculadas a la FIFA.', '2025', 'Fútbol masculino', di.id
FROM disciplinas di WHERE di.nombre = 'Fútbol masculino';
INSERT INTO logros (titulo, descripcion, anio, etiqueta, disciplina_id)
SELECT 'Semifinalistas — Secretaría de Educación', 'Eliminados por penales ante el equipo que luego se coronaría campeón del torneo.', '2018–2019', 'Fútbol masculino', di.id
FROM disciplinas di WHERE di.nombre = 'Fútbol masculino';
INSERT INTO logros (titulo, descripcion, anio, etiqueta, disciplina_id)
SELECT '1º de grupo — Semana de la Juventud', 'Bachillerato masculino, con goleadas de hasta 9-0 antes de caer en cuartos de final por penales.', '2026', 'Fútbol masculino', di.id
FROM disciplinas di WHERE di.nombre = 'Fútbol masculino';
INSERT INTO logros (titulo, descripcion, anio, etiqueta, disciplina_id)
SELECT 'Cuartos de final — CODICADER', 'La selección femenina avanzó hasta los cuartos de final del torneo organizado por la Secretaría de Educación.', '2026', 'Fútbol femenino', di.id
FROM disciplinas di WHERE di.nombre = 'Fútbol femenino';
INSERT INTO logros (titulo, descripcion, anio, etiqueta, disciplina_id)
SELECT 'III Copa Amistad — en preparación', 'El torneo propio del instituto, nacido en 2024, prepara su tercera edición como evento insignia del fútbol femenino escolar.', '2026', 'Fútbol femenino', di.id
FROM disciplinas di WHERE di.nombre = 'Fútbol femenino';

-- ============================================================
-- PRÓXIMAS COMPETENCIAS
-- NOTA: la fecha de la III Copa Amistad es ESTIMADA (mediados de
-- octubre). Confirmar con el área deportiva y corregir desde el panel.
-- ============================================================
INSERT INTO eventos_deportivos (titulo, rival, disciplina_id, categoria_id, equipo_id, fecha, estado, destacado)
SELECT 'Selección femenina vs. Faita Academy', 'Faita Academy', d.id, c.id, e.id, '2026-10-01 09:00:00', 'proximo', FALSE
FROM disciplinas d, categorias_competencia c, equipos e
WHERE d.nombre = 'Fútbol femenino' AND c.nombre = 'U15' AND e.nombre = 'Selección Femenina de Fútbol';
INSERT INTO eventos_deportivos (titulo, rival, disciplina_id, categoria_id, equipo_id, fecha, estado, destacado)
SELECT 'Selección femenina vs. IER', 'IER', d.id, c.id, e.id, '2026-10-08 09:00:00', 'proximo', FALSE
FROM disciplinas d, categorias_competencia c, equipos e
WHERE d.nombre = 'Fútbol femenino' AND c.nombre = 'U17' AND e.nombre = 'Selección Femenina de Fútbol';
INSERT INTO eventos_deportivos (titulo, rival, disciplina_id, categoria_id, equipo_id, fecha, estado, destacado)
SELECT 'III Copa Amistad de Fútbol Femenino', NULL, d.id, c.id, e.id, '2026-10-15 09:00:00', 'proximo', TRUE
FROM disciplinas d, categorias_competencia c, equipos e
WHERE d.nombre = 'Fútbol femenino' AND c.nombre = 'U16' AND e.nombre = 'Selección Femenina de Fútbol';

-- ============================================================
-- PROYECTOS DE INFRAESTRUCTURA (iniciativa institucional)
-- ============================================================
INSERT INTO proyectos_futuros (titulo, descripcion, origen, estado) VALUES ('Techado de la cancha', 'En proceso junto a la municipalidad, para que la lluvia deje de decidir cuándo se juega.', 'iniciativa_admin', 'en_gestion');
INSERT INTO proyectos_futuros (titulo, descripcion, origen, estado) VALUES ('Construcción de graderías', 'Un espacio digno para que las familias acompañen cada partido de cerca.', 'iniciativa_admin', 'aprobado');
INSERT INTO proyectos_futuros (titulo, descripcion, origen, estado) VALUES ('Remodelación del salón de usos múltiples', 'Más espacio para entrenar, premiar y celebrar cada logro del área.', 'iniciativa_admin', 'aprobado');

-- ============================================================
-- OFERTA ACADÉMICA
-- ============================================================
INSERT INTO carreras (nombre, tipo, descripcion, icono) VALUES ('7mo Grado', 'basica', 'Educación Básica con iniciación técnica', 'fa-child');
INSERT INTO carreras (nombre, tipo, descripcion, icono) VALUES ('8vo Grado', 'basica', 'Educación Básica', 'fa-child');
INSERT INTO carreras (nombre, tipo, descripcion, icono) VALUES ('9no Grado', 'basica', 'Educación Básica', 'fa-child');
INSERT INTO carreras (nombre, tipo, descripcion, icono) VALUES ('BTP en Informática', 'tecnica', 'Programación, mantenimiento, diseño web y redes', 'fa-laptop-code');
INSERT INTO carreras (nombre, tipo, descripcion, icono) VALUES ('BTP en Contaduría y Finanzas', 'tecnica', 'Contabilidad bancaria, tributación e impuestos', 'fa-calculator');
INSERT INTO carreras (nombre, tipo, descripcion, icono) VALUES ('BTP en Agroindustria', 'tecnica', 'Procesamiento de lácteos, embutidos y alimentos', 'fa-seedling');

-- ============================================================
-- SECCIONES Y HORARIOS (20 secciones, 155 franjas reales)
-- ============================================================
-- Séptimo Grado - Sección 1 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Séptimo Grado - Sección 1', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '7mo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Educación Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Valores/Cívica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Taller Tecnológico');

-- Séptimo Grado - Sección 2 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Séptimo Grado - Sección 2', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '7mo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Educación Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Valores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Español');

-- Séptimo Grado - Sección 3 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Séptimo Grado - Sección 3', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '7mo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Valores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Orientación');

-- Séptimo Grado - Sección 4 (Vespertina (12:30 PM - 05:30 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Séptimo Grado - Sección 4', 'vespertina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '7mo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '12:30:00', '13:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '12:30:00', '13:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '12:30:00', '13:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '12:30:00', '13:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '12:30:00', '13:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '13:15:00', '14:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '13:15:00', '14:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '13:15:00', '14:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '13:15:00', '14:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '13:15:00', '14:00:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:00:00', '14:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:00:00', '14:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:00:00', '14:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:00:00', '14:45:00', 'Educación Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:00:00', '14:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:00:00', '15:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:00:00', '15:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:00:00', '15:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:00:00', '15:45:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:00:00', '15:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:45:00', '16:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:45:00', '16:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:45:00', '16:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:45:00', '16:30:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:45:00', '16:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '16:30:00', '17:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '16:30:00', '17:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '16:30:00', '17:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '16:30:00', '17:30:00', 'Valores/Cívica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '16:30:00', '17:30:00', 'Orientación');

-- Octavo Grado - Sección 1 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Octavo Grado - Sección 1', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '8vo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Educación Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Valores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Tecnología');

-- Octavo Grado - Sección 2 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Octavo Grado - Sección 2', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '8vo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Valores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Matemáticas');

-- Octavo Grado - Sección 3 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Octavo Grado - Sección 3', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '8vo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Valores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Matemáticas');

-- Octavo Grado - Sección 4 (Vespertina (12:30 PM - 05:30 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Octavo Grado - Sección 4', 'vespertina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '8vo Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '12:30:00', '13:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '12:30:00', '13:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '12:30:00', '13:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '12:30:00', '13:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '12:30:00', '13:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '13:15:00', '14:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '13:15:00', '14:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '13:15:00', '14:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '13:15:00', '14:00:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '13:15:00', '14:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:00:00', '14:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:00:00', '14:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:00:00', '14:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:00:00', '14:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:00:00', '14:45:00', 'Educación Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:00:00', '15:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:00:00', '15:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:00:00', '15:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:00:00', '15:45:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:00:00', '15:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:45:00', '16:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:45:00', '16:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:45:00', '16:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:45:00', '16:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:45:00', '16:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '16:30:00', '17:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '16:30:00', '17:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '16:30:00', '17:30:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '16:30:00', '17:30:00', 'Valores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '16:30:00', '17:30:00', 'Tecnología');

-- Noveno Grado - Sección 1 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Noveno Grado - Sección 1', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '9no Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Valores');

-- Noveno Grado - Sección 2 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Noveno Grado - Sección 2', 'matutina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '9no Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Ed. Artística');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Valores');

-- Noveno Grado - Sección 3 (Vespertina (12:30 PM - 05:30 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Noveno Grado - Sección 3', 'vespertina', 'Tercer Ciclo de Educación Básica'
FROM carreras c WHERE c.nombre = '9no Grado';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '12:30:00', '13:15:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '12:30:00', '13:15:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '12:30:00', '13:15:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '12:30:00', '13:15:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '12:30:00', '13:15:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '13:15:00', '14:00:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '13:15:00', '14:00:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '13:15:00', '14:00:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '13:15:00', '14:00:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '13:15:00', '14:00:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:00:00', '14:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:00:00', '14:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:00:00', '14:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:00:00', '14:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:00:00', '14:45:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:00:00', '15:45:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:00:00', '15:45:00', 'Ciencias Naturales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:00:00', '15:45:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:00:00', '15:45:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:00:00', '15:45:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:45:00', '16:30:00', 'Estudios Sociales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:45:00', '16:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:45:00', '16:30:00', 'Español');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:45:00', '16:30:00', 'Matemáticas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:45:00', '16:30:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '16:30:00', '17:30:00', 'Tecnología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '16:30:00', '17:30:00', 'Inglés');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '16:30:00', '17:30:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '16:30:00', '17:30:00', 'Valores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '16:30:00', '17:30:00', 'Ed. Artística');

-- Décimo Grado - Sección 1 (Matutina (07:00 AM - 12:15 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Décimo Grado - Sección 1', 'matutina', 'BTP / Educación Media (Tronco Común)'
FROM carreras c WHERE c.nombre = 'BTP en Informática';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Inglés Técnico I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Inglés Técnico I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Sociología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Filosofía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Inglés Técnico I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Sociología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Filosofía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Ed. Física y Deportes');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '12:15:00', 'Orientación Vocacional');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '12:15:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '12:15:00', 'Psicología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '12:15:00', 'Proyectos y Talleres');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '12:15:00', 'Valores Cívicos');

-- Décimo Grado - Sección 2 (Vespertina (12:30 PM - 05:30 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Décimo Grado - Sección 2', 'vespertina', 'BTP / Educación Media (Tronco Común)'
FROM carreras c WHERE c.nombre = 'BTP en Informática';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '12:30:00', '13:15:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '12:30:00', '13:15:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '12:30:00', '13:15:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '12:30:00', '13:15:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '12:30:00', '13:15:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '13:15:00', '14:00:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '13:15:00', '14:00:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '13:15:00', '14:00:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '13:15:00', '14:00:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '13:15:00', '14:00:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:00:00', '14:45:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:00:00', '14:45:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:00:00', '14:45:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:00:00', '14:45:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:00:00', '14:45:00', 'Inglés Técnico I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:00:00', '15:45:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:00:00', '15:45:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:00:00', '15:45:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:00:00', '15:45:00', 'Sociología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:00:00', '15:45:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:45:00', '16:30:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:45:00', '16:30:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:45:00', '16:30:00', 'Filosofía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:45:00', '16:30:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:45:00', '16:30:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '16:30:00', '17:30:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '16:30:00', '17:30:00', 'Inglés Técnico I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '16:30:00', '17:30:00', 'Sociología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '16:30:00', '17:30:00', 'Orientación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '16:30:00', '17:30:00', 'Ed. Física');

-- Décimo Grado - Sección 3 (Vespertina (12:30 PM - 05:30 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Décimo Grado - Sección 3', 'vespertina', 'BTP / Educación Media (Tronco Común)'
FROM carreras c WHERE c.nombre = 'BTP en Informática';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '12:30:00', '13:15:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '12:30:00', '13:15:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '12:30:00', '13:15:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '12:30:00', '13:15:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '12:30:00', '13:15:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '13:15:00', '14:00:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '13:15:00', '14:00:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '13:15:00', '14:00:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '13:15:00', '14:00:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '13:15:00', '14:00:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:00:00', '14:45:00', 'Inglés Técnico I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:00:00', '14:45:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:00:00', '14:45:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:00:00', '14:45:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:00:00', '14:45:00', 'Sociología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '14:45:00', '15:00:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:00:00', '15:45:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:00:00', '15:45:00', 'Biología I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:00:00', '15:45:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:00:00', '15:45:00', 'Filosofía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:00:00', '15:45:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '15:45:00', '16:30:00', 'Matemáticas I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '15:45:00', '16:30:00', 'Español I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '15:45:00', '16:30:00', 'Informática Básica');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '15:45:00', '16:30:00', 'Física I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '15:45:00', '16:30:00', 'Química I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '16:30:00', '17:30:00', 'Filosofía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '16:30:00', '17:30:00', 'Sociología');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '16:30:00', '17:30:00', 'Inglés Técnico I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '16:30:00', '17:30:00', 'Ed. Física');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '16:30:00', '17:30:00', 'Orientación');

-- Undécimo Grado - BTP en Contabilidad y Finanzas (Matutina / Extendida (07:00 AM - 01:00 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Undécimo Grado - BTP en Contabilidad y Finanzas', 'matutina', 'Bachillerato Técnico Profesional en Finanzas (11º)'
FROM carreras c WHERE c.nombre = 'BTP en Contaduría y Finanzas';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Contabilidad General I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Legislación Mercantil');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Contabilidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Administración I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Economía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Contabilidad General I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Legislación Mercantil');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Contabilidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Administración I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Economía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Matemática Financiera');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Contabilidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Informática Aplicada');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Contabilidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Mercadotecnia');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Informática Aplicada');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Matemática Financiera');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Matemática Financiera');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Legislación Laboral');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Contabilidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Administración I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Informática Aplicada');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Economía');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Matemática Financiera');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Finanzas Privadas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Inglés Técnico Finanzas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Finanzas Privadas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Inglés Técnico Finanzas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Finanzas Privadas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Ética Profesional');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '13:00:00', 'Taller Contable');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '13:00:00', 'Taller Contable');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '13:00:00', 'Laboratorio Computación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '13:00:00', 'Laboratorio Computación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '13:00:00', 'Orientación Profesional');

-- Undécimo Grado - BTP en Informática (Matutina / Extendida (07:00 AM - 01:00 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Undécimo Grado - BTP en Informática', 'matutina', 'Bachillerato Técnico Profesional en Informática (11º)'
FROM carreras c WHERE c.nombre = 'BTP en Informática';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Laboratorio de Informática I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Programación I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Mantenimiento y Reparación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Redes de Información I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Diseño Web I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Laboratorio de Informática I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Programación I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Mantenimiento y Reparación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Redes de Información I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Diseño Web I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Programación I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Laboratorio Informática I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Programación I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Diseño Web I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Redes de Información I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Ofimática Avanzada');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Mantenimiento Hardware');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Laboratorio Informática I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Programación I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Sistemas Operativos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Inglés Técnico Informática');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Redes de Información I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Diseño Web I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Ofimática Avanzada');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Programación I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Mantenimiento Hardware');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Inglés Técnico Informática');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Sistemas Operativos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Ética e Informática');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Laboratorio Informática I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '13:00:00', 'Taller de Programación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '13:00:00', 'Taller de Redes');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '13:00:00', 'Taller de Mantenimiento');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '13:00:00', 'Práctica Informática');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '13:00:00', 'Lógica de Programación');

-- Undécimo Grado - BTP en Agroindustria (Matutina / Campo (07:00 AM - 01:00 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Undécimo Grado - BTP en Agroindustria', 'matutina', 'Bachillerato Técnico Profesional en Agroindustria (11º)'
FROM carreras c WHERE c.nombre = 'BTP en Agroindustria';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Química Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Procesamiento de Alimentos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Procesos Agrícolas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Biología Aplicada');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Control de Calidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Química Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Procesamiento de Alimentos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Procesos Agrícolas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Biología Aplicada');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Control de Calidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Procesamiento de Alimentos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Química Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Maquinaria Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Procesos Pecuarios');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Seguridad e Higiene');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Procesos Agrícolas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Procesos Pecuarios');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Procesamiento Alimentos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Microbiología Alimentos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Gestión Ambiental');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Microbiología Alimentos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Maquinaria Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Seguridad e Higiene');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Procesamiento Alimentos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Inglés Técnico Agro');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Inglés Técnico Agro');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Gestión Ambiental');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Control de Calidad I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Química Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Procesos Agrícolas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '13:00:00', 'Práctica de Planta/Campo');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '13:00:00', 'Práctica de Planta/Campo');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '13:00:00', 'Taller de Lacteos/Cárnicos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '13:00:00', 'Taller de Granos/Frutas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '13:00:00', 'Proyectos Agropecuarios');

-- Duodécimo Grado - BTP en Contabilidad y Finanzas (Matutina / Práctica (07:00 AM - 01:00 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Duodécimo Grado - BTP en Contabilidad y Finanzas', 'matutina', 'Bachillerato Técnico Profesional en Finanzas (12º)'
FROM carreras c WHERE c.nombre = 'BTP en Contaduría y Finanzas';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Contabilidad Bancaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Auditoría I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Contabilidad de Costos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Finanzas Públicas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Formulación de Proyectos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Contabilidad Bancaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Auditoría I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Contabilidad de Costos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Finanzas Públicas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Formulación de Proyectos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Contabilidad de Costos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Contabilidad Bancaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Auditoría I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Sistemas Tributarios');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Banca y Seguros');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Auditoría I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Contabilidad de Costos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Software Contable Avanzado');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Formulación de Proyectos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Contabilidad Bancaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Sistemas Tributarios');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Software Contable Avanzado');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Finanzas Públicas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Auditoría I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Ética Financiera');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Software Contable Avanzado');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Banca y Seguros');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Bancaria y Financiera');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Contabilidad de Costos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Evaluación de Proyectos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '13:00:00', 'Seminario de Investigación');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '13:00:00', 'Práctica Contable Virtual');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '13:00:00', 'Taller de Auditoría');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '13:00:00', 'Preparación PPS/TES');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '13:00:00', 'Orientación Práctica Profesional');

-- Duodécimo Grado - BTP en Informática (Matutina / Práctica (07:00 AM - 01:00 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Duodécimo Grado - BTP en Informática', 'matutina', 'Bachillerato Técnico Profesional en Informática (12º)'
FROM carreras c WHERE c.nombre = 'BTP en Informática';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Programación II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Bases de Datos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Laboratorio de Informática II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Redes de Información II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Diseño Web II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Programación II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Bases de Datos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Laboratorio de Informática II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Redes de Información II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Diseño Web II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Bases de Datos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Programación II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Diseño Web II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Laboratorio Informática II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Análisis y Diseño Sistemas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Laboratorio Informática II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Redes de Información II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Programación II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Bases de Datos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Mantenimiento Avanzado');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Redes de Información II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Diseño Web II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Bases de Datos I');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Análisis y Diseño Sistemas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Programación II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Análisis y Diseño Sistemas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Mantenimiento Avanzado');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Gestión de Proyectos TI');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Gestión de Proyectos TI');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Seguridad Informática');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '13:00:00', 'Taller de Desarrollo Software');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '13:00:00', 'Taller de Bases de Datos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '13:00:00', 'Taller de Redes y Servidores');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '13:00:00', 'Preparación PPS/TES');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '13:00:00', 'Orientación Práctica Profesional');

-- Duodécimo Grado - BTP en Agroindustria (Matutina / Campo (07:00 AM - 01:00 PM))
INSERT INTO secciones_academicas (carrera_id, nombre, jornada, modalidad)
SELECT c.id, 'Duodécimo Grado - BTP en Agroindustria', 'matutina', 'Bachillerato Técnico Profesional en Agroindustria (12º)'
FROM carreras c WHERE c.nombre = 'BTP en Agroindustria';
SET @seccion_id = LAST_INSERT_ID();
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:00:00', '07:45:00', 'Procesamiento de Alimentos II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:00:00', '07:45:00', 'Control de Calidad II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:00:00', '07:45:00', 'Diseño y Gestión de Plantas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:00:00', '07:45:00', 'Comercialización Agropecuaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:00:00', '07:45:00', 'Análisis Químico Alimentario');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '07:45:00', '08:30:00', 'Procesamiento de Alimentos II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '07:45:00', '08:30:00', 'Control de Calidad II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '07:45:00', '08:30:00', 'Diseño y Gestión de Plantas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '07:45:00', '08:30:00', 'Comercialización Agropecuaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '07:45:00', '08:30:00', 'Análisis Químico Alimentario');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '08:30:00', '09:15:00', 'Control de Calidad II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '08:30:00', '09:15:00', 'Procesamiento de Alimentos II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '08:30:00', '09:15:00', 'Análisis Químico Alimentario');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '08:30:00', '09:15:00', 'Tecnología de Granos/Semillas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '08:30:00', '09:15:00', 'Procesamiento de Cárnicos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:15:00', '09:30:00', 'RECESO');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '09:30:00', '10:15:00', 'Procesamiento de Lácteos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '09:30:00', '10:15:00', 'Análisis Químico Alimentario');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '09:30:00', '10:15:00', 'Procesamiento de Alimentos II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '09:30:00', '10:15:00', 'Control de Calidad II');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '09:30:00', '10:15:00', 'Biotecnología Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '10:15:00', '11:00:00', 'Tecnología de Frutas/Hortalizas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '10:15:00', '11:00:00', 'Diseño y Gestión de Plantas');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '10:15:00', '11:00:00', 'Procesamiento de Lácteos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '10:15:00', '11:00:00', 'Procesamiento de Cárnicos');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '10:15:00', '11:00:00', 'Proyectos Agroindustriales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:00:00', '11:45:00', 'Proyectos Agroindustriales');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:00:00', '11:45:00', 'Comercialización Agropecuaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:00:00', '11:45:00', 'Biotecnología Agroindustrial');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:00:00', '11:45:00', 'Empaque y Embalaje');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:00:00', '11:45:00', 'Gestión e Inocuidad (HACCP)');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'lunes', '11:45:00', '13:00:00', 'Práctica Industrial de Planta');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'martes', '11:45:00', '13:00:00', 'Práctica Industrial de Planta');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'miercoles', '11:45:00', '13:00:00', 'Taller de Innovación Alimentaria');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'jueves', '11:45:00', '13:00:00', 'Preparación PPS/TES');
INSERT INTO horarios (seccion_id, dia, hora_inicio, hora_fin, materia) VALUES (@seccion_id, 'viernes', '11:45:00', '13:00:00', 'Orientación Práctica Profesional');

-- ============================================================
-- TIENDA ESCOLAR
-- ============================================================
INSERT INTO productos (nombre, precio, descripcion) VALUES ('Carnet Estudiantil', 100.0, 'Carnet oficial de identificación estudiantil.');
INSERT INTO productos (nombre, precio, descripcion) VALUES ('Buzo Deportivo Completo', 550.0, 'Uniforme deportivo institucional completo.');
INSERT INTO productos (nombre, precio, descripcion) VALUES ('Paquete de Graduación', 800.0, 'Paquete completo para ceremonia de graduación.');
INSERT INTO productos (nombre, precio, descripcion) VALUES ('Monograma / Escudo Oficial', 50.0, 'Escudo oficial bordado del instituto.');

-- ============================================================
-- CONFIGURACIÓN INSTITUCIONAL
-- ============================================================
INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES ('nombre_institucion', 'Instituto Gubernamental Técnico Francisco Miranda', 'Nombre oficial');
INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES ('direccion', 'Aldea Zambrano, Municipio del Distrito Central, Francisco Morazán, Honduras', 'Dirección física');
INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES ('telefono', '+504 2200-0000', 'Teléfono de secretaría');
INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES ('horario_atencion', 'Lunes a Viernes: 7:00 AM - 5:00 PM', 'Horario de atención');
INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES ('facebook_url', 'https://www.facebook.com/share/1JbkamZUK5/', 'Página de Facebook');
INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES ('instagram_url', 'https://www.instagram.com/igt_franciscomiranda', 'Perfil de Instagram');
INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES ('anio_fundacion', '1988', 'Año de fundación');

COMMIT;

-- =====================================================================
-- FIN DE LA MIGRACIÓN
--
-- NO se migran a propósito:
--   · integrantes_equipo → requiere autorización por estudiante
--   · testimonios y comentarios → requieren cuenta de usuario
--   · publicaciones → los 3 artículos del blog son contenido de ejemplo,
--     conviene reescribirlos como noticias reales desde el panel
-- =====================================================================
