-- ============================================
-- PROYECTO SEMANAL: Ranking con Window Functions
-- Semana 14 — Window Functions (ROW_NUMBER, RANK, DENSE_RANK)
-- PostgreSQL 16
-- Instituto Técnico
-- Entidades: categories (áreas académicas), items (programas)
-- ============================================

DROP TABLE IF EXISTS items CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

CREATE TABLE categories (
    id   SERIAL PRIMARY KEY,
    name TEXT   NOT NULL
);

CREATE TABLE items (
    id          SERIAL         PRIMARY KEY,
    name        TEXT           NOT NULL,
    value       NUMERIC(10, 2) NOT NULL,  -- costo del programa
    category_id INT            REFERENCES categories (id),
    is_active   BOOLEAN        NOT NULL DEFAULT TRUE
);

-- ============================================
-- INSERCIÓN DE DATOS
-- Incluye 1 duplicado exacto por nombre (para TODO 1)
-- e items con el mismo valor (para TODO 2, empate real)
-- ============================================

INSERT INTO categories (name) VALUES
    ('Tecnología'),
    ('Salud'),
    ('Diseño');

INSERT INTO items (name, value, category_id) VALUES
    ('Desarrollo de Software',   4500000, 1),
    ('Ciberseguridad',           4900000, 1),
    ('Inteligencia Artificial',  4900000, 1),  -- empate con Ciberseguridad
    ('Redes y Telecomunicaciones', 4200000, 1),
    ('Enfermería Auxiliar',      5200000, 2),
    ('Regencia de Farmacia',     5100000, 2),
    ('Salud Ocupacional',        4000000, 2),
    ('Diseño Gráfico',           3800000, 3),
    ('Diseño UX/UI',             3600000, 3),
    ('Diseño Gráfico',           3800000, 3);  -- duplicado exacto para TODO 1


-- ============================================
-- CONSULTA 1: Eliminar duplicados con ROW_NUMBER()
-- Se queda con un solo registro por nombre (el de menor id)
-- ============================================

WITH deduped AS (
    SELECT
        id,
        name,
        value,
        category_id,
        ROW_NUMBER() OVER (
            PARTITION BY name
            ORDER BY id
        ) AS rn
    FROM items
)
SELECT id, name, value, category_id
FROM deduped
WHERE rn = 1
ORDER BY id;


-- ============================================
-- CONSULTA 2: RANK y DENSE_RANK por categoría
-- Usa ambas funciones para mostrar la diferencia
-- con el empate real entre Ciberseguridad e IA
-- ============================================

SELECT
    name,
    value,
    category_id,
    RANK()       OVER (PARTITION BY category_id ORDER BY value DESC) AS rnk,
    DENSE_RANK() OVER (PARTITION BY category_id ORDER BY value DESC) AS dense_rnk
FROM items
ORDER BY category_id, value DESC;


-- ============================================
-- CONSULTA 3: Top-2 por categoría con CTE
-- Los 2 programas de mayor costo por área
-- ============================================

WITH ranked AS (
    SELECT
        name,
        value,
        category_id,
        DENSE_RANK() OVER (
            PARTITION BY category_id
            ORDER BY value DESC
        ) AS dense_rnk
    FROM items
)
SELECT name, value, category_id, dense_rnk
FROM ranked
WHERE dense_rnk <= 2
ORDER BY category_id, dense_rnk;