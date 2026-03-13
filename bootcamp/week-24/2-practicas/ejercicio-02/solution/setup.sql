-- Semana 24: Proyecto Integrador Final
-- setup.sql — Ejercicio 02 (solution)
-- Motor: PostgreSQL 16
-- ============================================

DROP TABLE IF EXISTS audit_log CASCADE;

CREATE TABLE audit_log (
    id          BIGSERIAL   PRIMARY KEY,
    table_name  TEXT        NOT NULL,
    action      TEXT        NOT NULL,
    record_id   INTEGER,
    changed_at  TIMESTAMP   NOT NULL DEFAULT NOW()
);
