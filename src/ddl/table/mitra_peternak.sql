-- Table
CREATE TABLE mitra_peternak (
  id BIGSERIAL,
  nama_mitra VARCHAR(255),
  nama_pemilik VARCHAR(255),
  jenkel VARCHAR(255),
  pendidikan VARCHAR(255),
  tgl_lahir DATE,
  latitude NUMERIC(10, 8),
  longitude NUMERIC(11, 8),
  provinsi_id VARCHAR(64),
  kota_id VARCHAR(64),
  kecamatan_id VARCHAR(64),
  kelurahan_id VARCHAR(64),
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
  id_unit_ternak INT8,
  PRIMARY KEY (id)
);


-- Inject
COPY mitra_peternak
FROM '/seed/csv/mitra_peternak.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE mitra_peternak_id_seq RESTART WITH 51;
