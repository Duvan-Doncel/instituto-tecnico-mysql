-- ============================================
-- PROYECTO SEMANAL: CTEs y CASE WHEN en tu dominio
-- Semana 12 — Common Table Expressions + Condicionales
-- Instituto Técnico
-- Entidades: programs_w12 (items), enrollments_w12 (transactions)
-- ============================================

CREATE DATABASE IF NOT EXISTS instituto_tecnico;
USE instituto_tecnico;

-- ============================================
-- PARTE 1: ESQUEMA DE TABLAS
-- ============================================

DROP TABLE IF EXISTS enrollments_w12;
DROP TABLE IF EXISTS programs_w12;

CREATE TABLE programs_w12 (
    program_id   INT           AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100)  NOT NULL,
    price        DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category     VARCHAR(50)   NOT NULL
);

CREATE TABLE enrollments_w12 (
    enrollment_id INT     AUTO_INCREMENT PRIMARY KEY,
    program_id    INT     NOT NULL,
    quantity      INT     NOT NULL DEFAULT 1,
    tx_date       DATE    NOT NULL,
    FOREIGN KEY (program_id) REFERENCES programs_w12(program_id) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS
-- 9 programas en 3 categorías (Tecnología, Salud, Diseño)
-- 12 matrículas distribuidas en varias semanas
-- ============================================

INSERT INTO programs_w12 (program_name, price, category) VALUES
('Desarrollo de Software',     4500000.00, 'Tecnología'),
('Ciberseguridad',             4900000.00, 'Tecnología'),
('Inteligencia Artificial',    5500000.00, 'Tecnología'),
('Enfermería Auxiliar',        5200000.00, 'Salud'),
('Regencia de Farmacia',       5100000.00, 'Salud'),
('Salud Ocupacional',          4000000.00, 'Salud'),
('Diseño Gráfico',             3800000.00, 'Diseño'),
('Diseño UX/UI',               3600000.00, 'Diseño'),
('Fotografía y Video',         3300000.00, 'Diseño');

INSERT INTO enrollments_w12 (program_id, quantity, tx_date) VALUES
(1, 15, '2026-01-12'),
(1, 10, '2026-02-03'),
(2, 20, '2026-01-15'),
(3, 8,  '2026-01-20'),
(3, 12, '2026-02-10'),
(4, 25, '2026-01-08'),
(4, 18, '2026-02-01'),
(5, 14, '2026-01-22'),
(6, 9,  '2026-02-05'),
(7, 16, '2026-01-18'),
(8, 11, '2026-02-08'),
(9, 7,  '2026-01-25');


-- ============================================
-- PARTE 3: CONSULTAS CON CTE Y CASE WHEN
-- ============================================

-- CONSULTA 1: CTE simple + CASE WHEN de clasificación
-- Clasifica cada programa según su precio en 3 bandas
WITH items_con_actividad AS (
    SELECT
        p.program_id,
        p.program_name,
        p.price,
        p.category,
        COUNT(e.enrollment_id) AS total_transactions
    FROM programs_w12 p
    LEFT JOIN enrollments_w12 e ON e.program_id = p.program_id
    GROUP BY p.program_id, p.program_name, p.price, p.category
)
SELECT
    program_name       AS programa,
    price               AS precio,
    total_transactions  AS total_matriculas,
    CASE
        WHEN price >= 4800000 THEN 'Premium'
        WHEN price >= 3900000 THEN 'Estándar'
        ELSE                       'Económico'
    END AS price_band
FROM items_con_actividad
ORDER BY price DESC;


-- CONSULTA 2: Dos CTEs encadenados
-- Primer CTE: total matriculado por categoría
-- Segundo CTE: categorías por encima del promedio
WITH ventas_por_categoria AS (
    SELECT
        p.category,
        SUM(e.quantity) AS total_vendido
    FROM programs_w12 p
    INNER JOIN enrollments_w12 e ON e.program_id = p.program_id
    GROUP BY p.category
),
categorias_top AS (
    SELECT category
    FROM ventas_por_categoria
    WHERE total_vendido > (SELECT AVG(total_vendido) FROM ventas_por_categoria)
)
SELECT
    vc.category       AS categoria,
    vc.total_vendido   AS total_matriculados
FROM ventas_por_categoria vc
WHERE vc.category IN (SELECT category FROM categorias_top)
ORDER BY vc.total_vendido DESC;


-- CONSULTA 3: CTE + COUNT condicional por banda
-- Por categoría, cuántos programas hay en cada banda de precio
WITH clasificados AS (
    SELECT
        program_name AS name,
        category,
        price,
        CASE
            WHEN price >= 4800000 THEN 'Premium'
            WHEN price >= 3900000 THEN 'Estándar'
            ELSE                       'Económico'
        END AS price_band
    FROM programs_w12
)
SELECT
    category                                                AS categoria,
    COUNT(CASE WHEN price_band = 'Premium'   THEN 1 END) AS premium_count,
    COUNT(CASE WHEN price_band = 'Estándar'  THEN 1 END) AS estandar_count,
    COUNT(CASE WHEN price_band = 'Económico' THEN 1 END) AS economico_count
FROM clasificados
GROUP BY category
ORDER BY category;