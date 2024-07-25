-- View
CREATE OR REPLACE VIEW distribusi_ternak_cdc AS
WITH cte_raw_parse AS (
  SELECT
    operation,
    "timestamp",
    (old_data->>'id')::INT8 AS old_id,
    (old_data->>'tgl_distribusi')::DATE AS old_tgl_distribusi,
    (old_data->>'id_unit_ternak')::INT8 AS old_id_unit_ternak,
    (old_data->>'id_jenis_produk')::INT8 AS old_id_jenis_produk,
    (old_data->>'id_mitra_bisnis')::INT8 AS old_id_mitra_bisnis,
    (old_data->>'satuan')::VARCHAR(255) AS old_satuan,
    (old_data->>'jumlah')::NUMERIC(8,2) AS old_jumlah,
    (old_data->>'harga_berlaku')::INT8 AS old_harga_berlaku,
    (new_data->>'id')::INT8 AS new_id,
    (new_data->>'tgl_distribusi')::DATE AS new_tgl_distribusi,
    (new_data->>'id_unit_ternak')::INT8 AS new_id_unit_ternak,
    (new_data->>'id_jenis_produk')::INT8 AS new_id_jenis_produk,
    (new_data->>'id_mitra_bisnis')::INT8 AS new_id_mitra_bisnis,
    (new_data->>'satuan')::VARCHAR(255) AS new_satuan,
    (new_data->>'jumlah')::NUMERIC(8,2) AS new_jumlah,
    (new_data->>'harga_berlaku')::INT8 AS new_harga_berlaku
  FROM log_cdc_prc
  WHERE table_name = 'distribusi_ternak'
    AND is_processed IS FALSE
),
cte_op_insert AS (
  SELECT
    new_id AS id,
    new_tgl_distribusi AS tgl_distribusi,
    new_id_unit_ternak AS id_unit_ternak,
    new_id_jenis_produk AS id_jenis_produk,
    new_id_mitra_bisnis AS id_mitra_bisnis,
    new_satuan AS satuan,
    new_jumlah AS jumlah,
    new_harga_berlaku AS harga_berlaku
  FROM cte_raw_parse
  WHERE operation = 'INSERT'
),
cte_op_update_flag AS (
  SELECT *,
    ROW_NUMBER() OVER(PARTITION BY new_id ORDER BY "timestamp" ASC) AS flag_asc,
    ROW_NUMBER() OVER(PARTITION BY new_id ORDER BY "timestamp" DESC) AS flag_dsc
  FROM cte_raw_parse
  WHERE operation = 'UPDATE'
),
cte_op_update AS (
  SELECT
    new.id AS id,
    new.tgl_distribusi AS tgl_distribusi,
    new.id_unit_ternak AS id_unit_ternak,
    new.id_jenis_produk AS id_jenis_produk,
    new.id_mitra_bisnis AS id_mitra_bisnis,
    new.satuan AS satuan,
    (new.jumlah - old.jumlah) AS jumlah,
    (new.harga_berlaku - old.harga_berlaku) AS harga_berlaku
  FROM (
    SELECT
      old_id AS id,
      old_tgl_distribusi AS tgl_distribusi,
      old_id_unit_ternak AS id_unit_ternak,
      old_id_jenis_produk AS id_jenis_produk,
      old_id_mitra_bisnis AS id_mitra_bisnis,
      old_satuan AS satuan,
      old_jumlah AS jumlah,
      old_harga_berlaku AS harga_berlaku
    FROM cte_op_update_flag
    WHERE flag_asc = 1
  ) AS old
  JOIN (
    SELECT
      new_id AS id,
      new_tgl_distribusi AS tgl_distribusi,
      new_id_unit_ternak AS id_unit_ternak,
      new_id_jenis_produk AS id_jenis_produk,
      new_id_mitra_bisnis AS id_mitra_bisnis,
      new_satuan AS satuan,
      new_jumlah AS jumlah,
      new_harga_berlaku AS harga_berlaku
    FROM cte_op_update_flag
    WHERE flag_dsc = 1
  ) AS new
    ON old.id = new.id
),
cte_op_delete AS (
  SELECT
    old_id AS id,
    old_tgl_distribusi AS tgl_distribusi,
    old_id_unit_ternak AS id_unit_ternak,
    old_id_jenis_produk AS id_jenis_produk,
    old_id_mitra_bisnis AS id_mitra_bisnis,
    old_satuan AS satuan,
    (-1 * old_jumlah) AS jumlah,
    (-1 * old_harga_berlaku) AS harga_berlaku
  FROM cte_raw_parse
  WHERE operation = 'DELETE'
),
cte_cdc_view AS (
  SELECT
    COALESCE(i.id, u.id, d.id) AS id,
    COALESCE(i.tgl_distribusi, u.tgl_distribusi, d.tgl_distribusi) AS tgl_distribusi,
    COALESCE(i.id_unit_ternak, u.id_unit_ternak, d.id_unit_ternak) AS id_unit_ternak,
    COALESCE(i.id_jenis_produk, u.id_jenis_produk, d.id_jenis_produk) AS id_jenis_produk,
    COALESCE(i.id_mitra_bisnis, u.id_mitra_bisnis, d.id_mitra_bisnis) AS id_mitra_bisnis,
    COALESCE(i.satuan, u.satuan, d.satuan) AS satuan,
    COALESCE(i.jumlah, 0) + COALESCE(u.jumlah, 0) + COALESCE(d.jumlah, 0) AS jumlah,
    COALESCE(i.harga_berlaku, 0) + COALESCE(u.harga_berlaku, 0) + COALESCE(d.harga_berlaku, 0) AS harga_berlaku
  FROM cte_op_insert AS i
  FULL JOIN cte_op_update AS u
    ON i.id = u.id
  FULL JOIN cte_op_delete AS d
    ON i.id = d.id
    AND u.id = d.id
)
SELECT * FROM cte_cdc_view;
