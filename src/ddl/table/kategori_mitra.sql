-- Table
CREATE TABLE kategori_mitra (
  id BIGSERIAL,
  nama_kategori VARCHAR(255),
  PRIMARY KEY (id)
);


-- Inject
COPY kategori_mitra
FROM '/seed/csv/kategori_mitra.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE history_kelahiran_kematian_id_seq RESTART WITH 10;
