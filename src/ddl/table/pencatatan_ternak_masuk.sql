-- Table
CREATE TABLE pencatatan_ternak_masuk (
  id BIGSERIAL,
  tgl_pencatatan DATE,
  jenis_mitra_pengirim VARCHAR(255),
  jml_pedaging_jantan INT4,
  jml_pedaging_betina INT4,
  jml_pedaging_anakan_jantan INT4,
  jml_pedaging_anakan_betina INT4,
  jml_perah_jantan INT4,
  jml_perah_betina INT4,
  jml_perah_anakan_jantan INT4,
  jml_perah_anakan_betina INT4,
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
COPY pencatatan_ternak_masuk
FROM '/seed/csv/pencatatan_ternak_masuk.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE pencatatan_ternak_masuk_id_seq RESTART WITH 47;


-- Functions
CREATE OR REPLACE FUNCTION log_pencatatan_ternak_masuk_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'INSERT', 'pencatatan_ternak_masuk', NEW.id, null, row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_pencatatan_ternak_masuk_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'UPDATE', 'pencatatan_ternak_masuk', OLD.id, row_to_json(OLD), row_to_json(NEW));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_pencatatan_ternak_masuk_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_cdc (timestamp, operation, table_name, primary_key, old_data, new_data)
    VALUES (now(), 'DELETE', 'pencatatan_ternak_masuk', OLD.id, row_to_json(OLD), null);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Triggers
DROP TRIGGER IF EXISTS after_insert_pencatatan_ternak_masuk on pencatatan_ternak_masuk;  
CREATE TRIGGER after_insert_pencatatan_ternak_masuk
AFTER INSERT ON pencatatan_ternak_masuk
FOR EACH ROW
EXECUTE FUNCTION log_pencatatan_ternak_masuk_insert();

DROP TRIGGER IF EXISTS after_update_pencatatan_ternak_masuk on pencatatan_ternak_masuk;  
CREATE TRIGGER after_update_pencatatan_ternak_masuk
AFTER UPDATE ON pencatatan_ternak_masuk
FOR EACH ROW
EXECUTE FUNCTION log_pencatatan_ternak_masuk_update();

DROP TRIGGER IF EXISTS after_delete_pencatatan_ternak_masuk on pencatatan_ternak_masuk;  
CREATE TRIGGER after_delete_pencatatan_ternak_masuk
AFTER DELETE ON pencatatan_ternak_masuk
FOR EACH ROW
EXECUTE FUNCTION log_pencatatan_ternak_masuk_delete();
