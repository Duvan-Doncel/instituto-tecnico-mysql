-- Semana 16: Índices y Funciones — Ejercicio 02 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Funciones de cadena
-- ============================================

SELECT
    UPPER(first_name) || ' ' || UPPER(last_name) AS full_name_upper,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) AS email_domain,
    LENGTH(first_name) AS name_length
FROM employees
ORDER BY full_name_upper;


-- ============================================
-- PASO 2: Funciones de fecha
-- ============================================

SELECT
    first_name,
    hire_date,
    TO_CHAR(hire_date, 'DD/MM/YYYY') AS hire_fmt,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date))::INT AS years_in_company
FROM employees
ORDER BY hire_date;


-- ============================================
-- PASO 3: Funciones numéricas
-- ============================================

SELECT
    first_name,
    salary,
    ROUND(salary / 12, 2)            AS monthly_salary,
    ROUND(salary * 1.10, 2)          AS salary_with_bonus,
    ROUND(salary * 1.10 - salary, 2) AS bonus_amount
FROM employees
ORDER BY salary DESC;


-- ============================================
-- PASO 4: Reporte combinado
-- ============================================

SELECT
    UPPER(first_name) || ' ' || UPPER(last_name)         AS employee,
    TO_CHAR(hire_date, 'Mon YYYY')                       AS hired,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date))::INT AS years,
    ROUND(salary / 12, 2)                                AS monthly
FROM employees
WHERE is_active = TRUE
ORDER BY years DESC, salary DESC;
