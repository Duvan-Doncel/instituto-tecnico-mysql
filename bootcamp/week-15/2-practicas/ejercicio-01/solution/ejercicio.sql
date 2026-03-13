-- Semana 15: Window Functions Navegación — Ejercicio 01 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: LAG — acceder al mes anterior
-- ============================================

SELECT
    sale_month,
    amount,
    LAG(amount, 1, 0) OVER (ORDER BY sale_month) AS prev_amount
FROM monthly_sales
ORDER BY sale_month;


-- ============================================
-- PASO 2: Calcular la diferencia (delta)
-- ============================================

SELECT
    sale_month,
    amount,
    LAG(amount, 1, 0) OVER (ORDER BY sale_month)          AS prev_amount,
    amount - LAG(amount, 1, 0) OVER (ORDER BY sale_month) AS delta
FROM monthly_sales
ORDER BY sale_month;


-- ============================================
-- PASO 3: LAG por departamento (PARTITION BY)
-- ============================================

SELECT
    sale_month,
    department_id,
    amount,
    LAG(amount, 1, 0) OVER (
        PARTITION BY department_id
        ORDER BY sale_month
    ) AS prev_dept_amount
FROM monthly_sales
ORDER BY department_id, sale_month;


-- ============================================
-- PASO 4: LEAD — ver el siguiente mes
-- ============================================

SELECT
    sale_month,
    amount,
    LEAD(amount, 1, NULL) OVER (ORDER BY sale_month) AS next_amount
FROM monthly_sales
ORDER BY sale_month;
