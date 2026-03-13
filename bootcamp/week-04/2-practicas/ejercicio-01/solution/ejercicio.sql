-- ============================================
-- Semana 04: SELECT — Ejercicio 01 — SOLUCIÓN
-- ============================================

-- PASO 1
SELECT first_name, last_name, email
FROM   employees;

-- PASO 2
SELECT
    first_name  AS nombre,
    last_name   AS apellido,
    salary * 12 AS salario_anual
FROM employees;

-- PASO 3
SELECT first_name, salary
FROM   employees
WHERE  department_id = 1;

-- PASO 4
SELECT
    first_name  AS nombre,
    last_name   AS apellido,
    salary      AS salario
FROM   employees
WHERE  department_id = 2;
