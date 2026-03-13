-- Semana 14: Window Functions — Ejercicio 01 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: ROW_NUMBER() global — sin PARTITION BY
-- ============================================

SELECT
    first_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS global_rank
FROM employees
ORDER BY salary DESC;


-- ============================================
-- PASO 2: ROW_NUMBER() con PARTITION BY
-- ============================================

SELECT
    first_name,
    department_id,
    salary,
    ROW_NUMBER() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS dept_row_num
FROM employees
ORDER BY department_id, salary DESC;


-- ============================================
-- PASO 3: RANK() — compara con ROW_NUMBER()
-- ============================================

SELECT
    first_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK()       OVER (ORDER BY salary DESC) AS rnk
FROM employees
ORDER BY salary DESC;


-- ============================================
-- PASO 4: Las tres funciones en paralelo
-- ============================================

SELECT
    first_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num,
    RANK()       OVER (ORDER BY salary DESC) AS rnk,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rnk
FROM employees
ORDER BY salary DESC;
