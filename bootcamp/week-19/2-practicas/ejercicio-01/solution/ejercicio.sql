-- ============================================
-- Semana 19: Triggers
-- Ejercicio 01 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Crear la trigger function de auditoría
-- ============================================

CREATE OR REPLACE FUNCTION fn_audit_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO audit_log (table_name, action, record_id, detail)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        COALESCE(NEW.id, OLD.id),
        FORMAT('old_price=%s new_price=%s',
               OLD.price, NEW.price)
    );
    RETURN NULL;
END;
$$;


-- ============================================
-- PASO 2: Crear el trigger AFTER y probarlo
-- ============================================

CREATE TRIGGER trg_audit_products
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE FUNCTION fn_audit_changes();

INSERT INTO products (name, price, stock, category)
VALUES ('Test item', 99.00, 5, 'test');

SELECT * FROM audit_log ORDER BY id DESC LIMIT 3;


-- ============================================
-- PASO 3: UPDATE y DELETE — verificar en log
-- ============================================

UPDATE products SET price = 120.00 WHERE name = 'Test item';
DELETE FROM products WHERE name = 'Test item';

SELECT
    table_name,
    action,
    record_id,
    detail,
    executed_at
FROM audit_log
ORDER BY id DESC
LIMIT 5;


-- ============================================
-- PASO 4: Deshabilitar y habilitar el trigger
-- ============================================

ALTER TABLE products DISABLE TRIGGER trg_audit_products;

-- Este UPDATE masivo NO genera registros en audit_log
UPDATE products SET price = price * 1.1 WHERE category = 'furniture';

-- Debe retornar 0 nuevos logs
SELECT COUNT(*) AS nuevos_logs FROM audit_log
WHERE executed_at > NOW() - INTERVAL '5 seconds';

-- Rehabilitar para uso normal
ALTER TABLE products ENABLE TRIGGER trg_audit_products;
