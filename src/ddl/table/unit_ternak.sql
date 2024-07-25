-- Table
CREATE TABLE unit_ternak (
  id BIGSERIAL,
  nama_unit VARCHAR(255),
  alamat TEXT,
  provinsi_id VARCHAR(64),
  kota_id VARCHAR(64),
  kecamatan_id VARCHAR(64),
  kelurahan_id VARCHAR(64),
  latitude NUMERIC(10, 8),
  longitude NUMERIC(11, 8),
  created_at TIMESTAMP(0),
  updated_at TIMESTAMP(0),
  deleted_at TIMESTAMP(0),
  created_by INT8,
  updated_by INT8,
  deleted_by INT8,
  PRIMARY KEY (id)
);


-- Inject
COPY unit_ternak
FROM '/seed/csv/unit_ternak.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE unit_ternak_id_seq RESTART WITH 42;
