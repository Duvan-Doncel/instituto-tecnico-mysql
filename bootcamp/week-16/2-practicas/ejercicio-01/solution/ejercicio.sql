-- Semana 16: Índices y Funciones — Ejercicio 01 (SOLUCIÓN)
-- PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: EXPLAIN sin índice
-- ============================================

EXPLAIN
SELECT * FROM employees WHERE department_id = 2;


-- ============================================
-- PASO 2: Crear índice y repetir EXPLAIN
-- ============================================

CREATE INDEX idx_employees_department_id
    ON employees (department_id);

EXPLAIN
SELECT * FROM employees WHERE department_id = 2;


-- ============================================
-- PASO 3: Índice UNIQUE en email
-- ============================================

CREATE UNIQUE INDEX idx_employees_email
    ON employees (email);

EXPLAIN ANALYZE
SELECT * FROM employees WHERE email = 'ana.garcia@empresa.com';


-- ============================================
-- PASO 4: Ver los índices creados
-- ============================================

SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE tablename = 'employees';
