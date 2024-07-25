-- Table
CREATE TABLE history_kelahiran_kematian (
  id BIGSERIAL,
  tgl_pencatatan DATE,
  jml_lahir_pedaging_jantan INT4,
  jml_lahir_pedaging_betina INT4,
  jml_lahir_perah_jantan INT4,
  jml_lahir_perah_betina INT4,
  jml_mati_pedaging_jantan INT4,
  jml_mati_pedaging_betina INT4,
  jml_mati_perah_jantan INT4,
  jml_mati_perah_betina INT4,
  jml_mati_pedaging_anakan_jantan INT4,
  jml_mati_pedaging_anakan_betina INT4,
  jml_mati_perah_anakan_jantan INT4,
  jml_mati_perah_anakan_betina INT4,
  created_at TIMESTAMP(0),
  updated_at TIMESTAMP(0),
  deleted_at TIMESTAMP(0),
  created_by INT8,
  updated_by INT8,
  deleted_by INT8,
  id_peternak INT8,
  PRIMARY KEY (id)
);


-- Inject
COPY history_kelahiran_kematian
FROM '/seed/csv/history_kelahiran_kematian.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE history_kelahiran_kematian_id_seq RESTART WITH 52;


-- Functions
CREATE OR REPLACE FUNCTION log_history_kelahiran_kematian_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'INSERT', 'history_kelahiran_kematian', NEW.id, null, row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_history_kelahiran_kematian_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'UPDATE', 'history_kelahiran_kematian', OLD.id, row_to_json(OLD), row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_history_kelahiran_kematian_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'DELETE', 'history_kelahiran_kematian', OLD.id, row_to_json(OLD), null);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Triggers
DROP TRIGGER IF EXISTS after_insert_history_kelahiran_kematian on history_kelahiran_kematian;  
CREATE TRIGGER after_insert_history_kelahiran_kematian
AFTER INSERT ON history_kelahiran_kematian
FOR EACH ROW
EXECUTE FUNCTION log_history_kelahiran_kematian_insert();

DROP TRIGGER IF EXISTS after_update_history_kelahiran_kematian on history_kelahiran_kematian;  
CREATE TRIGGER after_update_history_kelahiran_kematian
AFTER UPDATE ON history_kelahiran_kematian
FOR EACH ROW
EXECUTE FUNCTION log_history_kelahiran_kematian_update();

DROP TRIGGER IF EXISTS after_delete_history_kelahiran_kematian on history_kelahiran_kematian;  
CREATE TRIGGER after_delete_history_kelahiran_kematian
AFTER DELETE ON history_kelahiran_kematian
FOR EACH ROW
EXECUTE FUNCTION log_history_kelahiran_kematian_delete();
