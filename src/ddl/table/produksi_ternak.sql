-- Table
CREATE TABLE produksi_ternak (
  id BIGSERIAL,
  tgl_produksi DATE,
  jumlah NUMERIC(8, 2),
  satuan VARCHAR(255),
  sumber_pasokan VARCHAR(255),
  created_at TIMESTAMP(0),
  updated_at TIMESTAMP(0),
  deleted_at TIMESTAMP(0),
  created_by INT8,
  updated_by INT8,
  deleted_by INT8,
  id_unit_ternak INT8,
  id_jenis_produk INT8,
  PRIMARY KEY (id)
);


-- Inject
COPY produksi_ternak
FROM '/seed/csv/produksi_ternak.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE produksi_ternak_id_seq RESTART WITH 21;


-- Functions
CREATE OR REPLACE FUNCTION log_produksi_ternak_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'INSERT', 'produksi_ternak', NEW.id, null, row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_produksi_ternak_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'UPDATE', 'produksi_ternak', OLD.id, row_to_json(OLD), row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_produksi_ternak_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'DELETE', 'produksi_ternak', OLD.id, row_to_json(OLD), null);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Triggers
DROP TRIGGER IF EXISTS after_insert_produksi_ternak on produksi_ternak;  
CREATE TRIGGER after_insert_produksi_ternak
AFTER INSERT ON produksi_ternak
FOR EACH ROW
EXECUTE FUNCTION log_produksi_ternak_insert();

DROP TRIGGER IF EXISTS after_update_produksi_ternak on produksi_ternak;  
CREATE TRIGGER after_update_produksi_ternak
AFTER UPDATE ON produksi_ternak
FOR EACH ROW
EXECUTE FUNCTION log_produksi_ternak_update();

DROP TRIGGER IF EXISTS after_delete_produksi_ternak on produksi_ternak;  
CREATE TRIGGER after_delete_produksi_ternak
AFTER DELETE ON produksi_ternak
FOR EACH ROW
EXECUTE FUNCTION log_produksi_ternak_delete();
