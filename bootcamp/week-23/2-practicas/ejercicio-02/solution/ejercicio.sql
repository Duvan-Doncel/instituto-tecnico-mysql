-- ============================================
-- Semana 23: Optimización y EXPLAIN ANALYZE
-- Ejercicio 02 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Índice parcial
-- ============================================

CREATE INDEX idx_orders_pending
    ON orders (created_at)
    WHERE status = 'pending';

EXPLAIN ANALYZE
SELECT * FROM orders
WHERE status = 'pending'
  AND created_at >= CURRENT_DATE - INTERVAL '30 days';


-- ============================================
-- PASO 2: Funciones que rompen índices
-- ============================================

-- El cast impide usar un índice normal sobre customer_id
EXPLAIN SELECT * FROM orders
WHERE customer_id::TEXT = '15';

-- Crear índice funcional correcto
CREATE INDEX idx_orders_customer_cast ON orders ((customer_id::TEXT));

-- Ahora sí usa el índice funcional
EXPLAIN SELECT * FROM orders
WHERE customer_id::TEXT = '15';


-- ============================================
-- PASO 3: VACUUM ANALYZE y pg_stat_user_tables
-- ============================================

VACUUM ANALYZE orders;

SELECT
    tablename,
    n_live_tup     AS filas_vivas,
    n_dead_tup     AS filas_muertas,
    last_analyze
FROM pg_stat_user_tables
WHERE tablename = 'orders';


-- ============================================
-- PASO 4: Listar índices con pg_indexes
-- ============================================

SELECT
    indexname,
    tablename,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN ('orders', 'customers')
ORDER BY tablename, indexname;
