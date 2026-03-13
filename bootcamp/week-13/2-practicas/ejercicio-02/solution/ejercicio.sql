-- Semana 13: CTEs Recursivas — Ejercicio 02 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Serie numérica del 1 al 10
-- ============================================

WITH RECURSIVE serie AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM serie
    WHERE n < 10
)
SELECT n FROM serie;


-- ============================================
-- PASO 2: Serie de fechas — primera semana
-- ============================================

WITH RECURSIVE calendario AS (
    SELECT CAST('2024-01-01' AS DATE) AS dia
    UNION ALL
    SELECT (dia + INTERVAL '1 day')::DATE
    FROM calendario
    WHERE dia < '2024-01-07'
)
SELECT dia FROM calendario;


-- ============================================
-- PASO 3: Calendario con ventas — días sin actividad
-- ============================================

WITH RECURSIVE calendario AS (
    SELECT CAST('2024-01-01' AS DATE) AS dia
    UNION ALL
    SELECT (dia + INTERVAL '1 day')::DATE
    FROM calendario
    WHERE dia < '2024-01-07'
)
SELECT
    c.dia                      AS fecha,
    COALESCE(SUM(s.amount), 0) AS total_ventas,
    COALESCE(COUNT(s.id), 0)   AS num_transacciones
FROM calendario c
LEFT JOIN daily_sales s ON s.sale_date = c.dia
GROUP BY c.dia
ORDER BY c.dia;


-- ============================================
-- PASO 4: generate_series() — alternativa PostgreSQL
-- ============================================

SELECT
    gs.dia::DATE               AS fecha,
    COALESCE(SUM(s.amount), 0) AS total_ventas
FROM generate_series(
    '2024-01-01'::DATE,
    '2024-01-07'::DATE,
    '1 day'::INTERVAL
) AS gs(dia)
LEFT JOIN daily_sales s ON s.sale_date = gs.dia::DATE
GROUP BY gs.dia
ORDER BY gs.dia;
