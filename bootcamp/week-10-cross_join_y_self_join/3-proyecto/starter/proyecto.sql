-- ============================================
-- PROYECTO SEMANAL: SELF JOIN en tu dominio
-- Semana 10 — CROSS JOIN y SELF JOIN
-- Instituto Técnico
-- Entidad: staff (jerarquía de personal académico)
-- ============================================

CREATE DATABASE IF NOT EXISTS instituto_tecnico;
USE instituto_tecnico;

-- ============================================
-- PARTE 1: ESQUEMA DE TABLA
-- Tabla auto-referencial: cada miembro del personal
-- tiene un jefe directo (parent_id), excepto el Rector
-- ============================================

DROP TABLE IF EXISTS staff;

CREATE TABLE staff (
    staff_id    INT          AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    position    VARCHAR(80)  NOT NULL,
    parent_id   INT,
    FOREIGN KEY (parent_id) REFERENCES staff(staff_id) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS
-- Nivel 0 (raíz):     Rector General
-- Nivel 1 (hijos):     3 Coordinadores
-- Nivel 2 (nietos):    6 Jefes de Área
-- Nivel 3 (bisnietos): 9 Instructores
-- ============================================

-- Nivel 0: raíz
INSERT INTO staff (full_name, position, parent_id) VALUES
('Ricardo Fonseca', 'Rector General', NULL);                         -- id 1

-- Nivel 1: coordinadores (hijos del Rector)
INSERT INTO staff (full_name, position, parent_id) VALUES
('Marta Elena Prieto',   'Coordinador Académico',        1),          -- id 2
('Jorge Iván Salazar',   'Coordinador Administrativo',   1),          -- id 3
('Consuelo Ríos',        'Coordinador de Bienestar',     1);          -- id 4

-- Nivel 2: jefes de área (nietos del Rector)
INSERT INTO staff (full_name, position, parent_id) VALUES
('Andrea Solano',   'Jefe de Área Tecnología',   2),                  -- id 5
('Camilo Restrepo', 'Jefe de Área Salud',        2),                  -- id 6
('Liliana Duarte',  'Jefe de Área Diseño',       2),                  -- id 7
('Pedro Camacho',   'Jefe de Recursos Humanos',  3),                  -- id 8
('Beatriz Núñez',   'Jefe de Finanzas',          3),                  -- id 9
('Fabián Osorio',   'Jefe de Deportes',          4);                  -- id 10

-- Nivel 3: instructores (bisnietos del Rector)
INSERT INTO staff (full_name, position, parent_id) VALUES
('Laura Gómez',    'Instructor Desarrollo de Software', 5),           -- id 11
('Carlos Ramírez', 'Instructor Redes',                  5),           -- id 12
('Daniela Castro', 'Instructor Ciberseguridad',         5),           -- id 13
('Felipe Díaz',    'Instructor Salud Ocupacional',      6),           -- id 14
('Valentina Moreno','Instructor Enfermería Auxiliar',   6),           -- id 15
('Santiago López', 'Instructor Diseño UX/UI',           7),           -- id 16
('Julián Peña',    'Instructor Diseño Gráfico',         7),           -- id 17
('Natalia Vargas', 'Analista de Nómina',                8),           -- id 18
('Ricardo Salcedo','Analista Contable',                 9);           -- id 19


-- ============================================
-- PARTE 3: CONSULTAS CON SELF JOIN
-- ============================================

-- CONSULTA 1: SELF JOIN básico (INNER JOIN)
-- Muestra cada miembro del personal con su jefe directo
-- Excluye al Rector (no tiene jefe)
SELECT
    child.full_name   AS empleado,
    parent.full_name  AS jefe_directo
FROM staff child
INNER JOIN staff parent ON child.parent_id = parent.staff_id
ORDER BY jefe_directo, empleado;


-- CONSULTA 2: Incluir la raíz con LEFT JOIN
-- El Rector aparece con 'Sin jefe (Rector)' en vez de NULL
SELECT
    child.full_name                              AS empleado,
    COALESCE(parent.full_name, 'Sin jefe (Rector)') AS jefe_directo
FROM staff child
LEFT JOIN staff parent ON child.parent_id = parent.staff_id
ORDER BY jefe_directo, empleado;


-- CONSULTA 3: Contar hijos directos por jefe
-- Cuántas personas reportan directamente a cada uno
SELECT
    parent.full_name    AS jefe,
    COUNT(child.staff_id) AS total_subordinados_directos
FROM staff parent
LEFT JOIN staff child ON child.parent_id = parent.staff_id
GROUP BY parent.staff_id, parent.full_name
HAVING COUNT(child.staff_id) > 0
ORDER BY total_subordinados_directos DESC;


-- CONSULTA 4: Tres niveles jerárquicos en una sola consulta
-- instructor → jefe de área → coordinador
SELECT
    child.full_name       AS instructor,
    parent.full_name      AS jefe_area,
    grandparent.full_name AS coordinador
FROM staff child
LEFT JOIN staff parent      ON child.parent_id  = parent.staff_id
LEFT JOIN staff grandparent ON parent.parent_id = grandparent.staff_id
ORDER BY coordinador, jefe_area, instructor;