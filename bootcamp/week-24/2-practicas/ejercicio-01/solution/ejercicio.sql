-- Semana 24: Proyecto Integrador Final
-- ejercicio.sql — Ejercicio 01 (solution)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: JOIN base — ventas por producto
-- ============================================

SELECT
    c.name              AS category_name,
    p.name              AS product_name,
    SUM(oi.quantity)    AS total_sold
FROM categories c
JOIN products p       ON p.category_id = c.id
JOIN order_items oi   ON oi.product_id = p.id
GROUP BY c.name, p.name
ORDER BY total_sold DESC
LIMIT 10;


-- ============================================
-- PASO 2: CTE + ROW_NUMBER — top-2 por categoría
-- ============================================

WITH ranked_products AS (
    SELECT
        c.name                                  AS category_name,
        p.name                                  AS product_name,
        SUM(oi.quantity)                        AS total_sold,
        ROW_NUMBER() OVER (
            PARTITION BY c.id
            ORDER BY SUM(oi.quantity) DESC
        )                                       AS rn
    FROM categories c
    JOIN products p     ON p.category_id = c.id
    JOIN order_items oi ON oi.product_id = p.id
    GROUP BY c.id, c.name, p.id, p.name
)
SELECT category_name, product_name, total_sold
FROM ranked_products
WHERE rn <= 2
ORDER BY category_name, rn;


-- ============================================
-- PASO 3: Full-Text Search sobre productos
-- ============================================

SELECT
    p.name,
    ts_rank(p.search_vector, query) AS rank
FROM products p,
     plainto_tsquery('spanish', 'inalámbrico bluetooth') AS query
WHERE p.search_vector @@ query
ORDER BY rank DESC;


-- ============================================
-- PASO 4: EXPLAIN ANALYZE — medir el JOIN
-- ============================================

-- Sin índice:
EXPLAIN ANALYZE
SELECT p.name, SUM(oi.quantity)
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.name;

-- Crear índice:
CREATE INDEX IF NOT EXISTS idx_order_items_product
    ON order_items (product_id);

-- Con índice:
EXPLAIN ANALYZE
SELECT p.name, SUM(oi.quantity)
FROM products p
JOIN order_items oi ON oi.product_id = p.id
GROUP BY p.name;
