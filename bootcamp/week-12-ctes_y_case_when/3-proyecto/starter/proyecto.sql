-- ============================================
-- PROYECTO SEMANAL: CTEs y CASE WHEN en tu dominio
-- Semana 12 — Common Table Expressions + Condicionales
-- Instituto Técnico
-- Entidades: programs_w12 (items), enrollments_w12 (transactions)
-- ============================================

CREATE DATABASE IF NOT EXISTS instituto_tecnico;
USE instituto_tecnico;

-- ============================================
-- PARTE 1: ESQUEMA DE TABLAS
-- ============================================

DROP TABLE IF EXISTS enrollments_w12;
DROP TABLE IF EXISTS programs_w12;

CREATE TABLE programs_w12 (
    program_id   INT           AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100)  NOT NULL,
    price        DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category     VARCHAR(50)   NOT NULL
);

CREATE TABLE enrollments_w12 (
    enrollment_id INT     AUTO_INCREMENT PRIMARY KEY,
    program_id    INT     NOT NULL,
    quantity      INT     NOT NULL DEFAULT 1,
    tx_date       DATE    NOT NULL,
    FOREIGN KEY (program_id) REFERENCES programs_w12(program_id) ON DELETE RESTRICT
);

-- ============================================
-- PARTE 2: INSERCIÓN DE DATOS
-- 9 programas en 3 categorías (Tecnología, Salud, Diseño)
-- 12 matrículas distribuidas en varias semanas
-- ============================================

INSERT INTO programs_w12 (program_name, price, category) VALUES
('Desarrollo de Software',     4500000.00, 'Tecnología'),
('Ciberseguridad',