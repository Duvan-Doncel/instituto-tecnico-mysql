-- ============================================
-- Semana 19: Triggers
-- Ejercicio 02 — SOLUCIÓN
-- Motor: PostgreSQL 16
-- ============================================

-- ============================================
-- PASO 1: Trigger BEFORE — normalizar nombre
-- ============================================

CREATE OR REPLACE FUNCTION fn_normalize_product()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.name := TRIM(UPPER(NEW.name));
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_normalize_before_insert
BEFORE INSERT ON products
FOR EACH ROW EXECUTE FUNCTION fn_normalize_product();

-- El nombre '  laptop mini  ' se almacena como 'LAPTOP MINI'
INSERT INTO products (name, price, stock, category)
VALUES ('  laptop mini  ', 499.00, 3, 'electronics');

SELECT id, name FROM products WHERE name LIKE '%LAPTOP%';


-- ============================================
-- PASO 2: Trigger BEFORE — rechazar precio inválido
-- ============================================

CREATE OR REPLACE FUNCTION fn_validate_price()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.price <= 0 THEN
        RAISE EXCEPTION
            'El precio debe ser positivo; recibido: %', NEW.price;
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_validate_price
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION fn_validate_price();

-- ERROR: El precio debe ser positivo; recibido: 0
INSERT INTO products (name, price, stock, category)
VALUES ('Artículo inválido', 0, 1, 'test');


-- ============================================
-- PASO 3: Trigger AFTER — historial de precios
-- ============================================

CREATE OR REPLACE FUNCTION fn_log_price_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.price <> OLD.price THEN
        INSERT INTO price_history (product_id, old_price, new_price)
        VALUES (OLD.id, OLD.price, NEW.price);
    END IF;
    RETURN NULL;
END;
$$;

CREATE TRIGGER trg_price_history
AFTER UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION fn_log_price_change();

UPDATE products SET price = 1199.00 WHERE id = 1;
SELECT * FROM price_history ORDER BY id DESC LIMIT 3;


-- ============================================
-- PASO 4: DROP TRIGGER y DROP FUNCTION
-- ============================================

DROP TRIGGER IF EXISTS trg_normalize_before_insert ON products;
DROP TRIGGER IF EXISTS trg_validate_price ON products;
DROP TRIGGER IF EXISTS trg_price_history ON products;

DROP FUNCTION IF EXISTS fn_normalize_product();
DROP FUNCTION IF EXISTS fn_validate_price();
DROP FUNCTION IF EXISTS fn_log_price_change();

-- Debe retornar 0 filas (ningún trigger de usuario)
SELECT tgname FROM pg_trigger
WHERE tgrelid = 'products'::REGCLASS;
