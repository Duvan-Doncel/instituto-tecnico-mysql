-- ============================================
-- PROYECTO: Instituto Técnico
-- Semana 06 — Funciones de Agregación, GROUP BY, HAVING
-- Entidades: students, programs, instructors, schedules
-- ============================================
 
CREATE DATABASE IF NOT EXISTS instituto_tecnico;
USE instituto_tecnico;
 
-- ============================================
-- CREACIÓN DE TABLAS
-- ============================================
 
CREATE TABLE IF NOT EXISTS programs (
    program_id      INT AUTO_INCREMENT PRIMARY KEY,
    program_name    VARCHAR(100) NOT NULL,
    duration_months INT          NOT NULL,
    cost            DECIMAL(10,2) NOT NULL
);
 
CREATE TABLE IF NOT EXISTS instructors (
    instructor_id   INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    email           VARCHAR(100)  UNIQUE NOT NULL,
    salary          DECIMAL(10,2) NOT NULL,
    program_id      INT,
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);
 
CREATE TABLE IF NOT EXISTS students (
    student_id      INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    age             INT          NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    program_id      INT,
    FOREIGN KEY (program_id) REFERENCES programs(program_id)
);
 
CREATE TABLE IF NOT EXISTS schedules (
    schedule_id     INT AUTO_INCREMENT PRIMARY KEY,
    program_id      INT         NOT NULL,
    instructor_id   INT         NOT NULL,
    day             VARCHAR(20) NOT NULL,
    start_time      TIME        NOT NULL,
    end_time        TIME        NOT NULL,
    FOREIGN KEY (program_id)    REFERENCES programs(program_id),
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);
 
-- ============================================
-- INSERCIÓN DE DATOS — programs (30 registros)
-- ============================================
 
INSERT INTO programs (program_name, duration_months, cost) VALUES
('Desarrollo de Software',          12, 4500000.00),
('Diseño Gráfico',                  10,  3800000.00),
('Redes y Telecomunicaciones',      12,  4200000.00),
('Administración de Empresas',      18,  5000000.00),
('Contabilidad y Finanzas',         18,  4800000.00),
('Marketing Digital',               8,   3200000.00),
('Inteligencia Artificial',         12,  5500000.00),
('Ciberseguridad',                  10,  4900000.00),
('Logística y Cadena de Suministro',14,  4100000.00),
('Gestión de Proyectos',            10,  3900000.00),
('Base de Datos',                   8,   3500000.00),
('Diseño UX/UI',                    8,   3600000.00),
('Electrónica Industrial',          14,  4300000.00),
('Mecatrónica',                     16,  4700000.00),
('Salud Ocupacional',               12,  4000000.00),
('Gastronomía',                     10,  3700000.00),
('Turismo y Hotelería',             12,  4100000.00),
('Fotografía y Video',              8,   3300000.00),
('Idiomas — Inglés Avanzado',       6,   2800000.00),
('Idiomas — Francés',               6,   2800000.00),
('Idiomas — Portugués',             6,   2700000.00),
('Enfermería Auxiliar',             18,  5200000.00),
('Regencia de Farmacia',            18,  5100000.00),
('Instrumentación Quirúrgica',      24,  6500000.00),
('Trabajo Social',                  18,  4400000.00),
('Arquitectura de Interiores',      12,  4600000.00),
('Producción Musical',              10,  3900000.00),
('Animación 3D',                    10,  4200000.00),
('Cloud Computing',                 8,   4800000.00),
('DevOps y CI/CD',                  8,   5000000.00);
 
-- ============================================
-- INSERCIÓN DE DATOS — instructors (30 registros)
-- ============================================
 
INSERT INTO instructors (first_name, last_name, email, salary, program_id) VALUES
('Carlos',    'Ramírez',   'c.ramirez@instituto.edu',    4200000.00,  1),
('Laura',     'Gómez',     'l.gomez@instituto.edu',      3800000.00,  2),
('Andrés',    'Torres',    'a.torres@instituto.edu',     4500000.00,  3),
('Marcela',   'Herrera',   'm.herrera@instituto.edu',    3900000.00,  4),
('Felipe',    'Díaz',      'f.diaz@instituto.edu',       4100000.00,  5),
('Valentina', 'Moreno',    'v.moreno@instituto.edu',     3700000.00,  6),
('Santiago',  'López',     's.lopez@instituto.edu',      5200000.00,  7),
('Daniela',   'Castro',    'd.castro@instituto.edu',     4800000.00,  8),
('Julián',    'Peña',      'j.pena@instituto.edu',       4000000.00,  9),
('Natalia',   'Vargas',    'n.vargas@instituto.edu',     3950000.00, 10),
('Ricardo',   'Salcedo',   'r.salcedo@instituto.edu',    3600000.00, 11),
('Paula',     'Ríos',      'p.rios@instituto.edu',       3700000.00, 12),
('Esteban',   'Mendoza',   'e.mendoza@instituto.edu',    4300000.00, 13),
('Camila',    'Ortega',    'c.ortega@instituto.edu',     4700000.00, 14),
('Hernán',    'Blanco',    'h.blanco@instituto.edu',     4050000.00, 15),
('Sofía',     'Aguilar',   's.aguilar@instituto.edu',    3750000.00, 16),
('Mateo',     'Serrano',   'm.serrano@instituto.edu',    4100000.00, 17),
('Isabella',  'Fuentes',   'i.fuentes@instituto.edu',    3400000.00, 18),
('Tomás',     'Cabrera',   't.cabrera@instituto.edu',    2900000.00, 19),
('Alejandra', 'Pinto',     'a.pinto@instituto.edu',      2900000.00, 20),
('Diego',     'Estrada',   'd.estrada@instituto.edu',    2800000.00, 21),
('Mónica',    'Suárez',    'm.suarez@instituto.edu',     5100000.00, 22),
('Gustavo',   'Pinzón',    'g.pinzon@instituto.edu',     5000000.00, 23),
('Adriana',   'Leal',      'a.leal@instituto.edu',       6200000.00, 24),
('Roberto',   'Cifuentes', 'r.cifuentes@instituto.edu',  4500000.00, 25),
('Paola',     'Naranjo',   'p.naranjo@instituto.edu',    4650000.00, 26),
('Sebastián', 'Vera',      's.vera@instituto.edu',       3950000.00, 27),
('Ximena',    'Acosta',    'x.acosta@instituto.edu',     4250000.00, 28),
('Rodrigo',   'Mejía',     'r.mejia@instituto.edu',      4850000.00, 29),
('Luciana',   'Ospina',    'l.ospina@instituto.edu',     5050000.00, 30);
 
-- ============================================
-- INSERCIÓN DE DATOS — students (30 registros)
-- ============================================
 
INSERT INTO students (first_name, last_name, age, email, program_id) VALUES
('Ana',       'Martínez',  20, 'ana.martinez@mail.com',    1),
('Luis',      'García',    22, 'luis.garcia@mail.com',     1),
('Sara',      'Rodríguez', 19, 'sara.rodriguez@mail.com',  2),
('Jorge',     'Hernández', 21, 'jorge.hernandez@mail.com', 2),
('Manuela',   'López',     20, 'manuela.lopez@mail.com',   3),
('David',     'Martínez',  23, 'david.martinez@mail.com',  3),
('Camila',    'González',  18, 'camila.gonzalez@mail.com', 4),
('Andrés',    'Pérez',     25, 'andres.perez@mail.com',    4),
('Valeria',   'Sánchez',   20, 'valeria.sanchez@mail.com', 4),
('Miguel',    'Ramírez',   22, 'miguel.ramirez@mail.com',  5),
('Daniela',   'Torres',    19, 'daniela.torres@mail.com',  5),
('Carlos',    'Flores',    21, 'carlos.flores@mail.com',   5),
('Sofía',     'Rivera',    20, 'sofia.rivera@mail.com',    6),
('Sebastián', 'Morales',   24, 'sebastian.morales@mail.com',6),
('Natalia',   'Jiménez',   18, 'natalia.jimenez@mail.com', 7),
('Felipe',    'Ruiz',      22, 'felipe.ruiz@mail.com',     7),
('Isabella',  'Díaz',      20, 'isabella.diaz@mail.com',   7),
('Alejandro', 'Vargas',    21, 'alejandro.vargas@mail.com',8),
('Laura',     'Castro',    19, 'laura.castro@mail.com',    8),
('Mateo',     'Romero',    23, 'mateo.romero@mail.com',    9),
('Valentina', 'Mendoza',   20, 'valentina.mendoza@mail.com',9),
('Julián',    'Ortega',    22, 'julian.ortega@mail.com',  10),
('Mariana',   'Guerrero',  18, 'mariana.guerrero@mail.com',10),
('Santiago',  'Medina',    21, 'santiago.medina@mail.com', 10),
('Paula',     'Reyes',     20, 'paula.reyes@mail.com',     11),
('Tomás',     'Cruz',      24, 'tomas.cruz@mail.com',      11),
('Gabriela',  'Herrera',   19, 'gabriela.herrera@mail.com',12),
('Ricardo',   'Núñez',     22, 'ricardo.nunez@mail.com',   12),
('Luciana',   'Aguilar',   20, 'luciana.aguilar@mail.com', 1),
('Esteban',   'Vega',      23, 'esteban.vega@mail.com',    3);
 
-- ============================================
-- INSERCIÓN DE DATOS — schedules (30 registros)
-- ============================================
 
INSERT INTO schedules (program_id, instructor_id, day, start_time, end_time) VALUES
( 1,  1, 'Lunes',     '07:00:00', '09:00:00'),
( 1,  1, 'Miércoles', '07:00:00', '09:00:00'),
( 1,  1, 'Viernes',   '07:00:00', '09:00:00'),
( 2,  2, 'Lunes',     '09:00:00', '11:00:00'),
( 2,  2, 'Jueves',    '09:00:00', '11:00:00'),
( 3,  3, 'Martes',    '10:00:00', '12:00:00'),
( 3,  3, 'Jueves',    '10:00:00', '12:00:00'),
( 4,  4, 'Lunes',     '14:00:00', '16:00:00'),
( 4,  4, 'Miércoles', '14:00:00', '16:00:00'),
( 5,  5, 'Martes',    '07:00:00', '09:00:00'),
( 5,  5, 'Viernes',   '07:00:00', '09:00:00'),
( 6,  6, 'Miércoles', '09:00:00', '11:00:00'),
( 6,  6, 'Viernes',   '09:00:00', '11:00:00'),
( 7,  7, 'Lunes',     '16:00:00', '18:00:00'),
( 7,  7, 'Miércoles', '16:00:00', '18:00:00'),
( 8,  8, 'Martes',    '14:00:00', '16:00:00'),
( 8,  8, 'Jueves',    '14:00:00', '16:00:00'),
( 9,  9, 'Lunes',     '11:00:00', '13:00:00'),
( 9,  9, 'Viernes',   '11:00:00', '13:00:00'),
(10, 10, 'Martes',    '16:00:00', '18:00:00'),
(10, 10, 'Jueves',    '16:00:00', '18:00:00'),
(11, 11, 'Lunes',     '18:00:00', '20:00:00'),
(11, 11, 'Miércoles', '18:00:00', '20:00:00'),
(12, 12, 'Martes',    '18:00:00', '20:00:00'),
(12, 12, 'Jueves',    '18:00:00', '20:00:00'),
( 1, 29, 'Sábado',    '08:00:00', '10:00:00'),
( 3, 30, 'Sábado',    '10:00:00', '12:00:00'),
( 7,  7, 'Sábado',    '08:00:00', '10:00:00'),
( 4,  4, 'Viernes',   '14:00:00', '16:00:00'),
( 5,  5, 'Miércoles', '07:00:00', '09:00:00');
 
-- ============================================
-- SEMANA 06 — REPORTES CON AGREGACIÓN
-- ============================================
 
-- REPORTE 1: Totales globales de estudiantes
SELECT
    COUNT(*)     AS total_estudiantes,
    AVG(age)     AS promedio_edad,
    MIN(age)     AS edad_minima,
    MAX(age)     AS edad_maxima
FROM students;
 
 
-- REPORTE 2: Extremos de salarios de instructores
SELECT
    MIN(salary)  AS salario_minimo,
    MAX(salary)  AS salario_maximo,
    AVG(salary)  AS salario_promedio,
    SUM(salary)  AS masa_salarial
FROM instructors;
 
 
-- REPORTE 3: Estudiantes por programa (GROUP BY)
SELECT
    p.program_name,
    COUNT(s.student_id) AS total_estudiantes,
    AVG(s.age)          AS promedio_edad
FROM students s
JOIN programs p ON s.program_id = p.program_id
GROUP BY p.program_id, p.program_name
ORDER BY total_estudiantes DESC;
 
 
-- REPORTE 4: Programas con más de 2 estudiantes (HAVING)
SELECT
    p.program_name,
    COUNT(s.student_id) AS total_estudiantes
FROM students s
JOIN programs p ON s.program_id = p.program_id
GROUP BY p.program_id, p.program_name
HAVING COUNT(s.student_id) > 2
ORDER BY total_estudiantes DESC;