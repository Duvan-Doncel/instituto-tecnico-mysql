-- ============================================
-- PROYECTO SEMANAL: Análisis temporal con Window Functions y Vistas
-- Semana 15 — LEAD, LAG, FIRST_VALUE, LAST_VALUE, CREATE VIEW
-- PostgreSQL 16
-- Instituto Técnico
-- Entidades: categories (áreas), period_metrics (matrículas mensuales)
-- ============================================

DROP VIEW  IF EXISTS v_period_analysis CASCADE;
DROP TABLE IF EXISTS period_metrics CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
    id   SERIAL PRIMARY KEY,
    name TEXT   NOT NULL
);

CREATE TABLE period_metrics (
    id          SERIAL         PRIMARY KEY,
    period_date DATE           NOT NULL,   -- mes de matrícula
    category_id INT            REFERENCES categories (id),
    value       NUMERIC(12, 2) NOT NULL    -- total de estudiantes matriculados
);

-- ============================================
-- INSERCIÓN DE DATOS
-- 2 áreas académicas, 4 meses de matrículas cada una
-- ============================================

INSERT INTO categories (name) VALUES
    ('Tecnología'),
    ('Salud');

INSERT INTO period_metrics (period_date, category_id, value) VALUES
    ('2026-01-01', 1, 45),
    ('2026-02-01', 1, 52),
    ('2026-03-01', 1, 38),
    ('2026-04-01', 1, 60),
    ('2026-01-01', 2, 30),
    ('2026-02-01', 2, 34),
    ('2026-03-01', 2, 29),
    ('2026-04-01', 2, 41);


-- ============================================
-- CONSULTA 1: LAG para calcular la variación entre períodos
-- Compara cada mes con el mes anterior, por área
-- ============================================

SELECT
    period_date,
    category_id,
    value,
    LAG(value, 1, 0) OVER (
        PARTITION BY category_id
        ORDER BY period_date
    ) AS prev_value,
    value - LAG(value, 1, 0) OVER (
        PARTITION BY category_id
        ORDER BY period_date
    ) AS delta
FROM period_metrics
ORDER BY category_id, period_date;


-- ============================================
-- CONSULTA 2: FIRST_VALUE y LAST_VALUE por categoría
-- Mejor y peor mes histórico de matrículas, por área
-- ============================================

SELECT
    period_date,
    category_id,
    value,
    FIRST_VALUE(value) OVER w AS period_best,
    LAST_VALUE(value)  OVER w AS period_worst
FROM period_metrics
WINDOW w AS (
    PARTITION BY category_id
    ORDER BY value DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY category_id, period_date;


-- ============================================
-- CONSULTA 3: CREATE VIEW — encapsular el análisis
-- ============================================

CREATE OR REPLACE VIEW v_period_analysis AS
SELECT
    period_date,
    category_id,
    value,
    LAG(value, 1, 0) OVER (
        PARTITION BY category_id
        ORDER BY period_date
    ) AS prev_value,
    FIRST_VALUE(value) OVER w AS period_best,
    LAST_VALUE(value)  OVER w AS period_worst
FROM period_metrics
WINDOW w AS (
    PARTITION BY category_id
    ORDER BY value DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);

-- Consulta la vista filtrando por Tecnología (category_id = 1)
SELECT *
FROM v_period_analysis
WHERE category_id = 1
ORDER BY period_date;