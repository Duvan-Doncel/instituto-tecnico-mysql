-- Semana 15: Window Functions Navegación — Ejercicio 02 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: FIRST_VALUE por departamento
-- ============================================

SELECT
    sale_month,
    department_id,
    amount,
    FIRST_VALUE(amount) OVER (
        PARTITION BY department_id
        ORDER BY amount DESC
    ) AS dept_best
FROM monthly_sales
ORDER BY department_id, sale_month;


-- ============================================
-- PASO 2: LAST_VALUE con frame extendido
-- ============================================

SELECT
    sale_month,
    department_id,
    amount,
    LAST_VALUE(amount) OVER (
        PARTITION BY department_id
        ORDER BY amount DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS dept_worst
FROM monthly_sales
ORDER BY department_id, sale_month;


-- ============================================
-- PASO 3: Alias de ventana con WINDOW
-- ============================================

SELECT
    sale_month,
    department_id,
    amount,
    FIRST_VALUE(amount) OVER w AS dept_best,
    LAST_VALUE(amount)  OVER w AS dept_worst
FROM monthly_sales
WINDOW w AS (
    PARTITION BY department_id
    ORDER BY amount DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY department_id, sale_month;


-- ============================================
-- PASO 4: CREATE VIEW y consulta a la vista
-- ============================================

CREATE OR REPLACE VIEW v_dept_sales_analysis AS
SELECT
    sale_month,
    department_id,
    amount,
    FIRST_VALUE(amount) OVER w AS dept_best,
    LAST_VALUE(amount)  OVER w AS dept_worst
FROM monthly_sales
WINDOW w AS (
    PARTITION BY department_id
    ORDER BY amount DESC
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
);

SELECT *
FROM v_dept_sales_analysis
WHERE department_id = 1
ORDER BY sale_month;
