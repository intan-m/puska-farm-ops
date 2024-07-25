-- Table
CREATE TABLE wilayah (
  id BIGSERIAL,
  kode VARCHAR(13),
  nama VARCHAR(100),
  PRIMARY KEY (id)
);


-- Inject
COPY wilayah
FROM '/seed/csv/wilayah.csv'
WITH (
  FORMAT 'csv',
  DELIMITER ';',
  HEADER TRUE
);


-- Restart Sequence
ALTER SEQUENCE wilayah_id_seq RESTART WITH 91282;
