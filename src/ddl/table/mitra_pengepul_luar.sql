-- Table
CREATE TABLE mitra_pengepul_luar (
  id BIGSERIAL,
  nama_pengepul VARCHAR(255),
  jenkel VARCHAR(255),
  pendidikan VARCHAR(255),
  tgl_lahir DATE,
  jenis_pengepul VARCHAR(255),
  provinsi_id VARCHAR(64),
  kota_id VARCHAR(64),
  kecamatan_id VARCHAR(64),
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
COPY mitra_pengepul_luar
FROM '/seed/csv/mitra_pengepul_luar.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE mitra_pengepul_luar_id_seq RESTART WITH 17;
