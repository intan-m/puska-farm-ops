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
