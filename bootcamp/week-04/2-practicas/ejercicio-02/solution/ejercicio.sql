-- ============================================
-- Semana 04: SELECT — Ejercicio 02 — SOLUCIÓN
-- ============================================

-- PASO 1
SELECT first_name, salary
FROM   employees
ORDER BY salary DESC;

-- PASO 2
SELECT first_name, last_name, department_id
FROM   employees
ORDER BY department_id ASC,
         last_name     ASC;

-- PASO 3
SELECT first_name, salary
FROM   employees
ORDER BY salary DESC
LIMIT 3;

-- PASO 4 — Paginación
SELECT first_name, salary
FROM   employees
ORDER BY salary DESC
LIMIT  2
OFFSET 0;

SELECT first_name, salary
FROM   employees
ORDER BY salary DESC
LIMIT  2
OFFSET 2;

SELECT first_name, salary
FROM   employees
ORDER BY salary DESC
LIMIT  2
OFFSET 4;
