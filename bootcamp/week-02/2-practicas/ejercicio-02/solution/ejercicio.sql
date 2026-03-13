-- ============================================
-- Semana 02: DDL — Diseño de Esquemas
-- Ejercicio 02 — SOLUCIÓN
-- ============================================

-- ============================================
-- PASO 2: Agregar columna phone a employees
-- ============================================

ALTER TABLE employees
ADD COLUMN phone TEXT;

-- ============================================
-- PASO 3: Agregar columna con NOT NULL + DEFAULT
-- ============================================

ALTER TABLE employees
ADD COLUMN is_active INTEGER NOT NULL DEFAULT 1;

-- ============================================
-- PASO 4: Renombrar columna phone → phone_number
-- ============================================

ALTER TABLE employees
RENAME COLUMN phone TO phone_number;

-- ============================================
-- PASO 5: Renombrar tabla employees → staff
-- ============================================

ALTER TABLE employees
RENAME TO staff;

-- ============================================
-- PASO 6: Verificar estructura final
-- ============================================

PRAGMA table_info(staff);
SELECT * FROM staff;
