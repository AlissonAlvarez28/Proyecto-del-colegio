-- =====================================================================
-- CIFRAS DEPORTIVAS EDITABLES
--
-- Estas son las estadísticas que NO se pueden calcular con un COUNT,
-- porque no existe un registro individual por cada una (ver ETAPA A,
-- punto 6). Provienen de la entrevista al Prof. Manuel Pineda y se
-- editan a mano desde el panel administrativo.
--
-- Las cifras que SÍ son calculables (disciplinas, equipos, logros,
-- eventos) NO se guardan aquí a propósito: el endpoint
-- /api/estadisticas-deportivas las cuenta en vivo, así nunca quedan
-- desactualizadas.
--
-- Ejecutar DESPUÉS de datos-reales.sql
-- =====================================================================

INSERT INTO configuracion_institucional (clave, valor, descripcion) VALUES
  ('anios_compitiendo',          '11',  'Años compitiendo formalmente (desde 2015)'),
  ('estudiantes_en_deporte',     '200', 'Estudiantes aprox. en actividades deportivas'),
  ('estudiantes_en_selecciones', '60',  'Estudiantes aprox. en selecciones oficiales'),
  ('competencias_formales',      '20',  'Competencias formales al año (cerca de 50 con amistosos)')
ON DUPLICATE KEY UPDATE valor = VALUES(valor);
