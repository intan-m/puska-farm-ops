-- Table
CREATE TABLE distribusi_susu (
  id BIGSERIAL,
  tgl_distribusi DATE,
  jumlah NUMERIC(8, 2),
  satuan VARCHAR(255),
  harga_berlaku INT4,
  created_at TIMESTAMP(0),
  updated_at TIMESTAMP(0),
  deleted_at TIMESTAMP(0),
  created_by INT8,
  updated_by INT8,
  deleted_by INT8,
  id_unit_ternak INT8,
  id_jenis_produk INT8,
  id_mitra_bisnis INT8,
  PRIMARY KEY (id)
);


-- Inject
COPY distribusi_susu
FROM '/seed/csv/distribusi_susu.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE distribusi_susu_id_seq RESTART WITH 145;


-- Functions
CREATE OR REPLACE FUNCTION log_distribusi_susu_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'INSERT', 'distribusi_susu', NEW.id, null, row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_distribusi_susu_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'UPDATE', 'distribusi_susu', OLD.id, row_to_json(OLD), row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_distribusi_susu_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'DELETE', 'distribusi_susu', OLD.id, row_to_json(OLD), null);
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


-- Triggers
DROP TRIGGER IF EXISTS after_insert_distribusi_susu on distribusi_susu;  
CREATE TRIGGER after_insert_distribusi_susu
AFTER INSERT ON distribusi_susu
FOR EACH ROW
EXECUTE FUNCTION log_distribusi_susu_insert();

DROP TRIGGER IF EXISTS after_update_distribusi_susu on distribusi_susu;  
CREATE TRIGGER after_update_distribusi_susu
AFTER UPDATE ON distribusi_susu
FOR EACH ROW
EXECUTE FUNCTION log_distribusi_susu_update();

DROP TRIGGER IF EXISTS after_delete_distribusi_susu on distribusi_susu;  
CREATE TRIGGER after_delete_distribusi_susu
AFTER DELETE ON distribusi_susu
FOR EACH ROW
EXECUTE FUNCTION log_distribusi_susu_delete();
