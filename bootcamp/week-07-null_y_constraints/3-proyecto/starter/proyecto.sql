-- ============================================
-- PROYECTO SEMANAL: NULL y Constraints
-- Semana 07 — NOT NULL, UNIQUE, CHECK, FK,
--             COALESCE, IFNULL, NULLIF
-- Instituto Técnico
-- ============================================

CREATE DATABASE IF NOT EXISTS instituto_tecnico;
USE instituto_tecnico;

-- ============================================
-- PARTE 1: ESQUEMA CON CONSTRAINTS (MySQL)
-- ============================================

-- Nota: En MySQL las FK se declaran explícitamente
-- con FOREIGN KEY ... REFERENCES, no con REFERENCES inline.
-- Se usa INT en lugar de INTEGER, y no existe PRAGMA.

DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS programs;

CREATE TABLE programs (
    program_id      INT           AUTO_INCREMENT PRIMARY KEY,
    program_name    VARCHAR(100)  NOT NULL UNIQUE,
    duration_months INT           NOT NULL CHECK (duration_months > 0),
    cost            DECIMAL(10,2) NOT NULL CHECK (cost > 0)
);

CREATE TABLE instructors (
    instructor_id   INT           AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    email           VARCHAR(100)  NOT NULL UNIQUE,
    phone           VARCHAR(20),                        -- permite NULL (teléfono opcional)
    salary          DECIMAL(10,2) NOT NULL CHECK (salary > 0),
    is_active       TINYINT       NOT NULL DEFAULT 1,
    program_id      INT,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE RESTRICT
);

CREATE TABLE students (
    student_id      INT           AUTO_INCREMENT PRIMARY KEY,
    identification  VARCHAR(20)   NOT NULL UNIQUE,
    first_name      VARCHAR(50)   NOT NULL,
    last_name       VARCHAR(50)   NOT NULL,
    email           VARCHAR(100)  NOT NULL UNIQUE,
    phone           VARCHAR(20),                        -- permite NULL (teléfono opcional)
    age             INT           NOT NULL CHECK (age > 0),
    is_active       TINYINT       NOT NULL DEFAULT 1,
    program_id      INT           NOT NULL,
    FOREIGN KEY (program_id) REFERENCES programs(program_id) ON DELETE RESTRICT
);

CREATE TABLE schedules (
    schedule_id     INT          AUTO_INCREMENT PRIMARY KEY,
    program_id      INT          NOT NULL,
    instructor_id   INT          NOT NULL,
    day             VARCHAR(20)  NOT NULL CHECK (day IN ('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado')),
    start_time      TIME         NOT NULL,
    end_time        TIME         NOT NULL,
    UNIQUE (program_id, instructor_id, day),            -- constraint compuesto: no duplicar mismo horario
    FOREIGN KEY (program_id)    REFERENCES programs(program_id)       ON DELETE RESTRICT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS — programs (30)
-- ============================================

INSERT INTO programs (program_name, duration_months, cost) VALUES
('Desarrollo de Software',           12, 4500000.00),
('Diseño Gráfico',                   10, 3800000.00),
('Redes y Telecomunicaciones',       12, 4200000.00),
('Administración de Empresas',       18, 5000000.00),
('Contabilidad y Finanzas',          18, 4800000.00),
('Marketing Digital',                 8, 3200000.00),
('Inteligencia Artificial',          12, 5500000.00),
('Ciberseguridad',                   10, 4900000.00),
('Logística y Cadena de Suministro', 14, 4100000.00),
('Gestión de Proyectos',             10, 3900000.00),
('Base de Datos',                     8, 3500000.00),
('Diseño UX/UI',                      8, 3600000.00),
('Electrónica Industrial',           14, 4300000.00),
('Mecatrónica',                      16, 4700000.00),
('Salud Ocupacional',                12, 4000000.00),
('Gastronomía',                      10, 3700000.00),
('Turismo y Hotelería',              12, 4100000.00),
('Fotografía y Video',                8, 3300000.00),
('Idiomas — Inglés Avanzado',         6, 2800000.00),
('Idiomas — Francés',                 6, 2800000.00),
('Idiomas — Portugués',               6, 2700000.00),
('Enfermería Auxiliar',              18, 5200000.00),
('Regencia de Farmacia',             18, 5100000.00),
('Instrumentación Quirúrgica',       24, 6500000.00),
('Trabajo Social',                   18, 4400000.00),
('Arquitectura de Interiores',       12, 4600000.00),
('Producción Musical',               10, 3900000.00),
('Animación 3D',                     10, 4200000.00),
('Cloud Computing',                   8, 4800000.00),
('DevOps y CI/CD',                    8, 5000000.00);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS — instructors (30)
-- Algunos sin teléfono (NULL) para practicar IS NULL / COALESCE
-- ============================================

INSERT INTO instructors (first_name, last_name, email, phone, salary, program_id) VALUES
('Carlos',    'Ramírez',   'c.ramirez@instituto.edu',    '3101111111', 4200000.00,  1),
('Laura',     'Gómez',     'l.gomez@instituto.edu',      '3102222222', 3800000.00,  2),
('Andrés',    'Torres',    'a.torres@instituto.edu',      NULL,         4500000.00,  3),
('Marcela',   'Herrera',   'm.herrera@instituto.edu',    '3104444444', 3900000.00,  4),
('Felipe',    'Díaz',      'f.diaz@instituto.edu',        NULL,         4100000.00,  5),
('Valentina', 'Moreno',    'v.moreno@instituto.edu',     '3106666666', 3700000.00,  6),
('Santiago',  'López',     's.lopez@instituto.edu',      '3107777777', 5200000.00,  7),
('Daniela',   'Castro',    'd.castro@instituto.edu',      NULL,         4800000.00,  8),
('Julián',    'Peña',      'j.pena@instituto.edu',       '3109999999', 4000000.00,  9),
('Natalia',   'Vargas',    'n.vargas@instituto.edu',     '3110000000', 3950000.00, 10),
('Ricardo',   'Salcedo',   'r.salcedo@instituto.edu',     NULL,         3600000.00, 11),
('Paula',     'Ríos',      'p.rios@instituto.edu',       '3112222222', 3700000.00, 12),
('Esteban',   'Mendoza',   'e.mendoza@instituto.edu',    '3113333333', 4300000.00, 13),
('Camila',    'Ortega',    'c.ortega@instituto.edu',      NULL,         4700000.00, 14),
('Hernán',    'Blanco',    'h.blanco@instituto.edu',     '3115555555', 4050000.00, 15),
('Sofía',     'Aguilar',   's.aguilar@instituto.edu',    '3116666666', 3750000.00, 16),
('Mateo',     'Serrano',   'm.serrano@instituto.edu',     NULL,         4100000.00, 17),
('Isabella',  'Fuentes',   'i.fuentes@instituto.edu',    '3118888888', 3400000.00, 18),
('Tomás',     'Cabrera',   't.cabrera@instituto.edu',    '3119999999', 2900000.00, 19),
('Alejandra', 'Pinto',     'a.pinto@instituto.edu',       NULL,         2900000.00, 20),
('Diego',     'Estrada',   'd.estrada@instituto.edu',    '3121111111', 2800000.00, 21),
('Mónica',    'Suárez',    'm.suarez@instituto.edu',     '3122222222', 5100000.00, 22),
('Gustavo',   'Pinzón',    'g.pinzon@instituto.edu',      NULL,         5000000.00, 23),
('Adriana',   'Leal',      'a.leal@instituto.edu',       '3124444444', 6200000.00, 24),
('Roberto',   'Cifuentes', 'r.cifuentes@instituto.edu',  '3125555555', 4500000.00, 25),
('Paola',     'Naranjo',   'p.naranjo@instituto.edu',     NULL,         4650000.00, 26),
('Sebastián', 'Vera',      's.vera@instituto.edu',       '3127777777', 3950000.00, 27),
('Ximena',    'Acosta',    'x.acosta@instituto.edu',     '3128888888', 4250000.00, 28),
('Rodrigo',   'Mejía',     'r.mejia@instituto.edu',       NULL,         4850000.00, 29),
('Luciana',   'Ospina',    'l.ospina@instituto.edu',     '3130000000', 5050000.00, 30);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS — students (30)
-- Algunos sin teléfono (NULL) para practicar IS NULL / COALESCE
-- ============================================

INSERT INTO students (identification, first_name, last_name, email, phone, age, program_id) VALUES
('1001', 'Ana',       'Martínez',  'ana.martinez@mail.com',     '3201111111', 20,  1),
('1002', 'Luis',      'García',    'luis.garcia@mail.com',       NULL,         22,  1),
('1003', 'Sara',      'Rodríguez', 'sara.rodriguez@mail.com',   '3203333333', 19,  2),
('1004', 'Jorge',     'Hernández', 'jorge.hernandez@mail.com',   NULL,         21,  2),
('1005', 'Manuela',   'López',     'manuela.lopez@mail.com',    '3205555555', 20,  3),
('1006', 'David',     'Martínez',  'david.martinez@mail.com',    NULL,         23,  3),
('1007', 'Camila',    'González',  'camila.gonzalez@mail.com',  '3207777777', 18,  4),
('1008', 'Andrés',    'Pérez',     'andres.perez@mail.com',     '3208888888', 25,  4),
('1009', 'Valeria',   'Sánchez',   'valeria.sanchez@mail.com',   NULL,         20,  4),
('1010', 'Miguel',    'Ramírez',   'miguel.ramirez@mail.com',   '3210000000', 22,  5),
('1011', 'Daniela',   'Torres',    'daniela.torres@mail.com',    NULL,         19,  5),
('1012', 'Carlos',    'Flores',    'carlos.flores@mail.com',    '3212222222', 21,  5),
('1013', 'Sofía',     'Rivera',    'sofia.rivera@mail.com',     '3213333333', 20,  6),
('1014', 'Sebastián', 'Morales',   'sebastian.morales@mail.com', NULL,         24,  6),
('1015', 'Natalia',   'Jiménez',   'natalia.jimenez@mail.com',  '3215555555', 18,  7),
('1016', 'Felipe',    'Ruiz',      'felipe.ruiz@mail.com',       NULL,         22,  7),
('1017', 'Isabella',  'Díaz',      'isabella.diaz@mail.com',    '3217777777', 20,  7),
('1018', 'Alejandro', 'Vargas',    'alejandro.vargas@mail.com', '3218888888', 21,  8),
('1019', 'Laura',     'Castro',    'laura.castro@mail.com',      NULL,         19,  8),
('1020', 'Mateo',     'Romero',    'mateo.romero@mail.com',     '3220000000', 23,  9),
('1021', 'Valentina', 'Mendoza',   'valentina.mendoza@mail.com', NULL,         20,  9),
('1022', 'Julián',    'Ortega',    'julian.ortega@mail.com',    '3222222222', 22, 10),
('1023', 'Mariana',   'Guerrero',  'mariana.guerrero@mail.com',  NULL,         18, 10),
('1024', 'Santiago',  'Medina',    'santiago.medina@mail.com',  '3224444444', 21, 10),
('1025', 'Paula',     'Reyes',     'paula.reyes@mail.com',      '3225555555', 20, 11),
('1026', 'Tomás',     'Cruz',      'tomas.cruz@mail.com',        NULL,         24, 11),
('1027', 'Gabriela',  'Herrera',   'gabriela.herrera@mail.com', '3227777777', 19, 12),
('1028', 'Ricardo',   'Núñez',     'ricardo.nunez@mail.com',     NULL,         22, 12),
('1029', 'Luciana',   'Aguilar',   'luciana.aguilar@mail.com',  '3229999999', 20,  1),
('1030', 'Esteban',   'Vega',      'esteban.vega@mail.com',     '3230000000', 23,  3);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS — schedules (30)
-- ============================================

INSERT INTO schedules (program_id, instructor_id, day, start_time, end_time) VALUES
( 1,  1, 'Lunes',      '07:00:00', '09:00:00'),
( 1,  1, 'Miércoles',  '07:00:00', '09:00:00'),
( 1,  1, 'Viernes',    '07:00:00', '09:00:00'),
( 2,  2, 'Lunes',      '09:00:00', '11:00:00'),
( 2,  2, 'Jueves',     '09:00:00', '11:00:00'),
( 3,  3, 'Martes',     '10:00:00', '12:00:00'),
( 3,  3, 'Jueves',     '10:00:00', '12:00:00'),
( 4,  4, 'Lunes',      '14:00:00', '16:00:00'),
( 4,  4, 'Miércoles',  '14:00:00', '16:00:00'),
( 5,  5, 'Martes',     '07:00:00', '09:00:00'),
( 5,  5, 'Viernes',    '07:00:00', '09:00:00'),
( 6,  6, 'Miércoles',  '09:00:00', '11:00:00'),
( 6,  6, 'Viernes',    '09:00:00', '11:00:00'),
( 7,  7, 'Lunes',      '16:00:00', '18:00:00'),
( 7,  7, 'Miércoles',  '16:00:00', '18:00:00'),
( 8,  8, 'Martes',     '14:00:00', '16:00:00'),
( 8,  8, 'Jueves',     '14:00:00', '16:00:00'),
( 9,  9, 'Lunes',      '11:00:00', '13:00:00'),
( 9,  9, 'Viernes',    '11:00:00', '13:00:00'),
(10, 10, 'Martes',     '16:00:00', '18:00:00'),
(10, 10, 'Jueves',     '16:00:00', '18:00:00'),
(11, 11, 'Lunes',      '18:00:00', '20:00:00'),
(11, 11, 'Miércoles',  '18:00:00', '20:00:00'),
(12, 12, 'Martes',     '18:00:00', '20:00:00'),
(12, 12, 'Jueves',     '18:00:00', '20:00:00'),
( 1, 29, 'Sábado',     '08:00:00', '10:00:00'),
( 3, 30, 'Sábado',     '10:00:00', '12:00:00'),
( 7,  7, 'Sábado',     '08:00:00', '10:00:00'),
( 4,  4, 'Viernes',    '14:00:00', '16:00:00'),
( 5,  5, 'Miércoles',  '07:00:00', '09:00:00');

-- ============================================
-- PARTE 3: CONSULTAS CON NULL
-- ============================================

-- Consulta 1: Estudiantes sin teléfono registrado (IS NULL)
SELECT
    student_id,
    CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM students
WHERE phone IS NULL;

-- Consulta 2: Instructores sin teléfono registrado (IS NULL)
SELECT
    instructor_id,
    CONCAT(first_name, ' ', last_name) AS nombre_completo
FROM instructors
WHERE phone IS NULL;

-- Consulta 3: Todos los estudiantes mostrando teléfono o 'Sin teléfono' (COALESCE)
SELECT
    CONCAT(first_name, ' ', last_name)  AS nombre_completo,
    COALESCE(phone, 'Sin teléfono')     AS telefono_display
FROM students;

-- Consulta 4: Todos los instructores con teléfono usando IFNULL (equivalente MySQL)
SELECT
    CONCAT(first_name, ' ', last_name)          AS nombre_completo,
    IFNULL(phone, 'Sin teléfono')               AS telefono_display,
    salary                                       AS salario
FROM instructors;

-- Consulta 5: Usar NULLIF para evitar división por cero
-- Calcula costo por mes; si duration_months fuera 0, devuelve NULL en vez de error
SELECT
    program_name,
    cost,
    duration_months,
    cost / NULLIF(duration_months, 0)            AS costo_por_mes
FROM programs;

-- Consulta 6: Estudiantes activos vs inactivos (usando DEFAULT is_active)
SELECT
    is_active,
    COUNT(*)                                     AS total_estudiantes
FROM students
GROUP BY is_active;

-- ============================================
-- PARTE 4: DEMOSTRACIÓN DE CONSTRAINTS
-- ============================================

-- Intentar insertar email duplicado → viola UNIQUE (comentado para no romper el script)
-- INSERT INTO students (identification, first_name, last_name, email, age, program_id)
-- VALUES ('9999', 'Test', 'Test', 'ana.martinez@mail.com', 20, 1);
-- Error esperado: Duplicate entry 'ana.martinez@mail.com' for key 'email'

-- Intentar insertar edad negativa → viola CHECK (comentado para no romper el script)
-- INSERT INTO students (identification, first_name, last_name, email, age, program_id)
-- VALUES ('8888', 'Test', 'Test', 'test@mail.com', -5, 1);
-- Error esperado: Check constraint 'students_chk_1' is violated

-- Intentar insertar student con program_id inexistente → viola FK (comentado)
-- INSERT INTO students (identification, first_name, last_name, email, age, program_id)
-- VALUES ('7777', 'Test', 'Test', 'test2@mail.com', 20, 999);
-- Error esperado: Cannot add or update a child row: a foreign key constraint fails