-- Table
CREATE TABLE history_populasi (
  id BIGSERIAL,
  tgl_pencatatan DATE,
  jml_pedaging_jantan INT4,
  jml_pedaging_betina INT4,
  jml_pedaging_anakan_jantan INT4,
  jml_pedaging_anakan_betina INT4,
  jml_perah_jantan INT4,
  jml_perah_betina INT4,
  jml_perah_anakan_jantan INT4,
  jml_perah_anakan_betina INT4,
  created_dt TIMESTAMP(0),
  modified_dt TIMESTAMP(0),
  deleted_at TIMESTAMP(0),
  created_by INT8,
  updated_by INT8,
  deleted_by INT8,
  id_peternak INT8,
  PRIMARY KEY (id)
);


-- Inject
COPY history_populasi
FROM '/seed/csv/history_populasi.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE history_populasi_id_seq RESTART WITH 55;


-- Functions
CREATE OR REPLACE FUNCTION log_history_populasi_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'INSERT', 'history_populasi', NEW.id, null, row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_history_populasi_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'UPDATE', 'history_populasi', OLD.id, row_to_json(OLD), row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_history_populasi_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'DELETE', 'history_populasi', OLD.id, row_to_json(OLD), null);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Triggers
DROP TRIGGER IF EXISTS after_insert_history_populasi on history_populasi;  
CREATE TRIGGER after_insert_history_populasi
AFTER INSERT ON history_populasi
FOR EACH ROW
EXECUTE FUNCTION log_history_populasi_insert();

DROP TRIGGER IF EXISTS after_update_history_populasi on history_populasi;  
CREATE TRIGGER after_update_history_populasi
AFTER UPDATE ON history_populasi
FOR EACH ROW
EXECUTE FUNCTION log_history_populasi_update();

DROP TRIGGER IF EXISTS after_delete_history_populasi on history_populasi;  
CREATE TRIGGER after_delete_history_populasi
AFTER DELETE ON history_populasi
FOR EACH ROW
EXECUTE FUNCTION log_history_populasi_delete();
