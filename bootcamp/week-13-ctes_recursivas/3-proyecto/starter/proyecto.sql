-- ============================================
-- PROYECTO SEMANAL: Jerarquías con CTEs Recursivas
-- Semana 13 — WITH RECURSIVE
-- PostgreSQL 16
-- Instituto Técnico
-- Entidad: area_tree (Institución > Áreas > Programas)
-- ============================================

DROP TABLE IF EXISTS area_tree CASCADE;

CREATE TABLE area_tree (
    id        SERIAL  PRIMARY KEY,
    name      TEXT    NOT NULL,
    parent_id INT     REFERENCES area_tree (id)
);

-- ============================================
-- INSERCIÓN DE DATOS — 3 niveles
-- Nivel 1: Institución (raíz)
-- Nivel 2: 3 áreas académicas
-- Nivel 3: programas dentro de cada área
-- ============================================

INSERT INTO area_tree (name, parent_id) VALUES
    ('Instituto Técnico', NULL);                       -- id 1, nivel 1

INSERT INTO area_tree (name, parent_id) VALUES
    ('Área de Tecnología', 1),                          -- id 2, nivel 2
    ('Área de Salud',      1),                          -- id 3, nivel 2
    ('Área de Diseño',     1);                          -- id 4, nivel 2

INSERT INTO area_tree (name, parent_id) VALUES
    ('Desarrollo de Software',     2),                  -- id 5, nivel 3
    ('Ciberseguridad',             2),                  -- id 6, nivel 3
    ('Inteligencia Artificial',    2),                  -- id 7, nivel 3
    ('Enfermería Auxiliar',        3),                  -- id 8, nivel 3
    ('Regencia de Farmacia',       3),                  -- id 9, nivel 3
    ('Diseño Gráfico',             4),                  -- id 10, nivel 3
    ('Diseño UX/UI',               4);                  -- id 11, nivel 3


-- ============================================
-- CONSULTA 1: Árbol completo con depth y path
-- ============================================

WITH RECURSIVE arbol AS (
    -- Caso base: la institución (raíz)
    SELECT
        id,
        name,
        parent_id,
        1        AS depth,
        name     AS path
    FROM area_tree
    WHERE parent_id IS NULL

    UNION ALL

    -- Caso recursivo: áreas y programas
    SELECT
        n.id,
        n.name,
        n.parent_id,
        a.depth + 1,
        a.path || ' > ' || n.name
    FROM area_tree n
    INNER JOIN arbol a ON n.parent_id = a.id
)
SELECT
    depth,
    REPEAT('  ', depth - 1) || name AS indented_name,
    path
FROM arbol
ORDER BY path;


-- ============================================
-- CONSULTA 2: Nodos de un nivel específico
-- Depth = 3 → solo los programas (el nivel más específico)
-- ============================================

WITH RECURSIVE arbol AS (
    SELECT id, name, parent_id, 1 AS depth, name AS path
    FROM area_tree
    WHERE parent_id IS NULL
    UNION ALL
    SELECT n.id, n.name, n.parent_id, a.depth + 1, a.path || ' > ' || n.name
    FROM area_tree n
    INNER JOIN arbol a ON n.parent_id = a.id
)
SELECT name, depth, path
FROM arbol
WHERE depth = 3
ORDER BY path;


-- ============================================
-- CONSULTA 3: Hojas del árbol (nodos sin hijos)
-- Los programas, que son el nivel final, no tienen hijos
-- ============================================

SELECT
    n.id,
    n.name
FROM area_tree n
WHERE NOT EXISTS (
    SELECT 1
    FROM area_tree child
    WHERE child.parent_id = n.id
)
ORDER BY n.name;