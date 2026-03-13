-- Semana 24: Proyecto Integrador Final
-- ejercicio.sql — Ejercicio 02 (solution)
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Trigger de auditoría AFTER
-- ============================================

CREATE OR REPLACE FUNCTION fn_audit_products()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO audit_log (table_name, action, record_id)
    VALUES (TG_TABLE_NAME, TG_OP, COALESCE(NEW.id, OLD.id));
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_audit_products
    AFTER INSERT OR UPDATE OR DELETE ON products
    FOR EACH ROW EXECUTE FUNCTION fn_audit_products();

-- Prueba
INSERT INTO products (category_id, name, description, price, stock)
VALUES (1, 'Producto de Prueba', 'Solo para probar el trigger', 9.99, 5);

UPDATE products SET stock = 0 WHERE name = 'Producto de Prueba';

SELECT * FROM audit_log ORDER BY changed_at DESC LIMIT 5;


-- ============================================
-- PASO 2: Trigger de validación BEFORE UPDATE
-- ============================================

CREATE OR REPLACE FUNCTION fn_validate_price()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.price < OLD.price * 0.5 THEN
        RAISE EXCEPTION
            'Precio inválido: no se puede reducir el precio en más del 50%%.'
            ' Precio actual: %, Nuevo: %', OLD.price, NEW.price;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_price
    BEFORE UPDATE OF price ON products
    FOR EACH ROW EXECUTE FUNCTION fn_validate_price();

-- Esta actualización válida no debe fallar (reducción del ~20%)
UPDATE products SET price = 240.00 WHERE name = 'Silla Ergonómica Mesh';


-- ============================================
-- PASO 3: jsonb_set — actualizar campo JSONB
-- ============================================

UPDATE products
SET attributes = jsonb_set(attributes, '{stock_alert}', 'true', true)
WHERE stock < 50;

SELECT name, stock, attributes->'stock_alert' AS alert
FROM products
WHERE (attributes->>'stock_alert')::BOOLEAN = TRUE;


-- ============================================
-- PASO 4: Reporte consolidado con jsonb_agg
-- ============================================

SELECT
    c.id,
    c.name,
    jsonb_build_object(
        'total_orders',  COUNT(o.id),
        'total_spent',   SUM(o.total_amount),
        'orders',        jsonb_agg(
            jsonb_build_object(
                'id',     o.id,
                'status', o.status,
                'amount', o.total_amount
            ) ORDER BY o.created_at
        )
    ) AS summary
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
ORDER BY c.name;
