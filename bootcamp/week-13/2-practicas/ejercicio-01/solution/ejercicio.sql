-- Semana 13: CTEs Recursivas — Ejercicio 01 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Consulta simple — empleados y su manager
-- ============================================

SELECT
    e.employee_id,
    e.first_name,
    e.job_title,
    m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.manager_id NULLS FIRST;


-- ============================================
-- PASO 2: CTE recursiva — profundidad y path
-- ============================================

WITH RECURSIVE org_chart AS (
    SELECT
        employee_id,
        first_name,
        manager_id,
        1            AS depth,
        first_name   AS path
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT
        e.employee_id,
        e.first_name,
        e.manager_id,
        oc.depth + 1,
        oc.path || ' > ' || e.first_name
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || first_name AS indented_name,
    path
FROM org_chart
ORDER BY path;


-- ============================================
-- PASO 3: Filtrar por nivel de profundidad
-- ============================================

WITH RECURSIVE org_chart AS (
    SELECT
        employee_id,
        first_name,
        manager_id,
        1          AS depth,
        first_name AS path
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT
        e.employee_id,
        e.first_name,
        e.manager_id,
        oc.depth + 1,
        oc.path || ' > ' || e.first_name
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT first_name, depth, path
FROM org_chart
WHERE depth = 3
ORDER BY path;


-- ============================================
-- PASO 4: Subordinados de un empleado específico
-- ============================================

WITH RECURSIVE subordinados AS (
    SELECT employee_id, first_name, manager_id, 0 AS depth
    FROM employees
    WHERE first_name = 'Ana'
    UNION ALL
    SELECT e.employee_id, e.first_name, e.manager_id, s.depth + 1
    FROM employees e
    INNER JOIN subordinados s ON e.manager_id = s.employee_id
)
SELECT first_name, depth
FROM subordinados
ORDER BY depth, first_name;
