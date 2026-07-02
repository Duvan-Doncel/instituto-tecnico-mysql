-- ============================================
-- PROYECTO SEMANAL: Subqueries en tu dominio
-- Semana 11 — Subqueries (escalar, IN, EXISTS, FROM)
-- Instituto Técnico
-- Entidades: programs (main), enrollments (child)
-- ============================================

CREATE DATABASE IF NOT EXISTS instituto_tecnico;
USE instituto_tecnico;

-- ============================================
-- PARTE 1: ESQUEMA DE TABLAS
-- ============================================

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS programs_sub;

CREATE TABLE programs_sub (
    program_id   INT           AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100)  NOT NULL UNIQUE,
    area         VARCHAR(50)   NOT NULL,
    cost         DECIMAL(10,2) NOT NULL CHECK (cost > 0)
);

CREATE TABLE enrollments (
    enrollment_id INT     AUTO_INCREMENT PRIMARY KEY,
    program_id    INT     NOT NULL,
    quantity      INT     NOT NULL DEFAULT 1,
    FOREIGN KEY (program_id) REFERENCES programs_sub(program_id) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS
-- Los últimos 2 programas NO tienen matrículas (para NOT EXISTS)
-- ============================================

INSERT INTO programs_sub (program_name, area, cost) VALUES
('Desarrollo de Software',     'Tecnología',    4500000.00),
('Ciberseguridad',             'Tecnología',    4900000.00),
('Inteligencia Artificial',    'Tecnología',    5500000.00),
('Redes y Telecomunicaciones', 'Tecnología',    4200000.00),
('Enfermería Auxiliar',        'Salud',         5200000.00),
('Regencia de Farmacia',       'Salud',         5100000.00),
('Salud Ocupacional',          'Salud',         4000000.00),
('Diseño Gráfico',             'Diseño',        3800000.00),
('Diseño UX/UI',               'Diseño',        3600000.00),
-- Estos 2 programas no tienen matrículas registradas
('Producción Musical',         'Arte',          3900000.00),
('Animación 3D',               'Arte',          4200000.00);

INSERT INTO enrollments (program_id, quantity) VALUES
(1, 28), (1, 15),
(2, 20),
(3, 12), (3, 8),
(4, 18),
(5, 30), (5, 22),
(6, 14),
(7, 10),
(8, 25),
(9, 19);
-- program_id 10 y 11 (Producción Musical, Animación 3D) quedan sin matrículas


-- ============================================
-- PARTE 3: CONSULTAS CON SUBQUERIES
-- ============================================

-- CONSULTA 1: Subquery escalar en WHERE
-- Programas cuyo costo supera el promedio de su propia área
SELECT
    program_name AS programa,
    area,
    cost         AS costo
FROM programs_sub p
WHERE cost > (
    SELECT AVG(p2.cost)
    FROM programs_sub p2
    WHERE p2.area = p.area
)
ORDER BY area, costo DESC;


-- CONSULTA 2: Subquery escalar en SELECT
-- Muestra el costo promedio global junto a cada programa
SELECT
    program_name AS programa,
    cost         AS costo,
    ROUND((SELECT AVG(cost) FROM programs_sub), 2) AS promedio_general
FROM programs_sub
ORDER BY costo DESC;


-- CONSULTA 3: NOT EXISTS — programas sin matrículas
-- Programas que NO tienen ninguna fila en enrollments
SELECT
    program_name AS programa_sin_matriculas
FROM programs_sub p
WHERE NOT EXISTS (
    SELECT 1
    FROM enrollments e
    WHERE e.program_id = p.program_id
);


-- CONSULTA 4: Tabla derivada en FROM
-- Áreas con más de 2 matrículas totales registradas
SELECT
    area_stats.area,
    area_stats.total_matriculas
FROM (
    SELECT
        p.area,
        COUNT(e.enrollment_id) AS total_matriculas
    FROM programs_sub p
    LEFT JOIN enrollments e ON e.program_id = p.program_id
    GROUP BY p.area
) AS area_stats
WHERE area_stats.total_matriculas > 2
ORDER BY area_stats.total_matriculas DESC;