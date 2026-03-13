-- Semana 14: Window Functions — Ejercicio 02 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: DENSE_RANK() por departamento
-- ============================================

SELECT
    first_name,
    department_id,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS dept_rank
FROM employees
ORDER BY department_id, salary DESC;


-- ============================================
-- PASO 2: El más alto por departamento (top-1)
-- ============================================

WITH ranked AS (
    SELECT
        first_name,
        department_id,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS dept_rank
    FROM employees
)
SELECT first_name, department_id, salary
FROM ranked
WHERE dept_rank = 1;


-- ============================================
-- PASO 3: Top-2 por departamento
-- ============================================

WITH ranked AS (
    SELECT
        first_name,
        department_id,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY department_id
            ORDER BY salary DESC
        ) AS dept_rank
    FROM employees
)
SELECT first_name, department_id, salary, dept_rank
FROM ranked
WHERE dept_rank <= 2
ORDER BY department_id, dept_rank;


-- ============================================
-- PASO 4: Top-3 global de la empresa
-- ============================================

WITH global_ranked AS (
    SELECT
        first_name,
        salary,
        DENSE_RANK() OVER (ORDER BY salary DESC) AS company_rank
    FROM employees
)
SELECT first_name, salary, company_rank
FROM global_ranked
WHERE company_rank <= 3
ORDER BY company_rank;
