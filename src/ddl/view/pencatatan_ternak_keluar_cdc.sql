-- View
CREATE OR REPLACE VIEW pencatatan_ternak_keluar_cdc AS
WITH cte_raw_parse AS (
  SELECT
    operation,
    "timestamp",
    (old_data->>'id')::INT8 AS old_id,
    (old_data->>'tgl_pencatatan')::DATE AS old_tgl_pencatatan,
    (old_data->>'id_peternak')::INT8 AS old_id_peternak,
    (old_data->>'jenis_mitra_pengirim') AS old_jenis_mitra_pengirim,
    (old_data->>'jml_pedaging_jantan')::INT8 AS old_jml_pedaging_jantan,
    (old_data->>'jml_pedaging_betina')::INT8 AS old_jml_pedaging_betina,
    (old_data->>'jml_pedaging_anakan_jantan')::INT8 AS old_jml_pedaging_anakan_jantan,
    (old_data->>'jml_pedaging_anakan_betina')::INT8 AS old_jml_pedaging_anakan_betina,
    (old_data->>'jml_perah_jantan')::INT8 AS old_jml_perah_jantan,
    (old_data->>'jml_perah_betina')::INT8 AS old_jml_perah_betina,
    (old_data->>'jml_perah_anakan_jantan')::INT8 AS old_jml_perah_anakan_jantan,
    (old_data->>'jml_perah_anakan_betina')::INT8 AS old_jml_perah_anakan_betina,
    (new_data->>'id')::INT8 AS new_id,
    (new_data->>'tgl_pencatatan')::DATE AS new_tgl_pencatatan,
    (new_data->>'id_peternak')::INT8 AS new_id_peternak,
    (new_data->>'jenis_mitra_pengirim') AS new_jenis_mitra_pengirim,
    (new_data->>'jml_pedaging_jantan')::INT8 AS new_jml_pedaging_jantan,
    (new_data->>'jml_pedaging_betina')::INT8 AS new_jml_pedaging_betina,
    (new_data->>'jml_pedaging_anakan_jantan')::INT8 AS new_jml_pedaging_anakan_jantan,
    (new_data->>'jml_pedaging_anakan_betina')::INT8 AS new_jml_pedaging_anakan_betina,
    (new_data->>'jml_perah_jantan')::INT8 AS new_jml_perah_jantan,
    (new_data->>'jml_perah_betina')::INT8 AS new_jml_perah_betina,
    (new_data->>'jml_perah_anakan_jantan')::INT8 AS new_jml_perah_anakan_jantan,
    (new_data->>'jml_perah_anakan_betina')::INT8 AS new_jml_perah_anakan_betina
  FROM log_cdc_prc
  WHERE table_name = 'pencatatan_ternak_keluar'
    AND is_processed IS FALSE
),
cte_op_insert AS (
  SELECT
    new_id AS id,
    new_tgl_pencatatan AS tgl_pencatatan,
    new_id_peternak AS id_peternak,
    new_jenis_mitra_pengirim AS jenis_mitra_pengirim,
    new_jml_pedaging_jantan AS jml_pedaging_jantan,
    new_jml_pedaging_betina AS jml_pedaging_betina,
    new_jml_pedaging_anakan_jantan AS jml_pedaging_anakan_jantan,
    new_jml_pedaging_anakan_betina AS jml_pedaging_anakan_betina,
    new_jml_perah_jantan AS jml_perah_jantan,
    new_jml_perah_betina AS jml_perah_betina,
    new_jml_perah_anakan_jantan AS jml_perah_anakan_jantan,
    new_jml_perah_anakan_betina AS jml_perah_anakan_betina
  FROM cte_raw_parse
  WHERE operation = 'INSERT'
),
cte_op_update_flg AS (
  SELECT *,
    ROW_NUMBER() OVER(PARTITION BY new_id ORDER BY "timestamp" ASC) AS flag_asc,
    ROW_NUMBER() OVER(PARTITION BY new_id ORDER BY "timestamp" DESC) AS flag_dsc
  FROM cte_raw_parse
  WHERE operation = 'UPDATE'
),
cte_op_update AS (
  SELECT
    new.id,
    new.tgl_pencatatan,
    new.id_peternak,
    new.jenis_mitra_pengirim,
    (new.jml_pedaging_jantan - old.jml_pedaging_jantan) AS jml_pedaging_jantan,
    (new.jml_pedaging_betina - old.jml_pedaging_betina) AS jml_pedaging_betina,
    (new.jml_pedaging_anakan_jantan - old.jml_pedaging_anakan_jantan) AS jml_pedaging_anakan_jantan,
    (new.jml_pedaging_anakan_betina - old.jml_pedaging_anakan_betina) AS jml_pedaging_anakan_betina,
    (new.jml_perah_jantan - old.jml_perah_jantan) AS jml_perah_jantan,
    (new.jml_perah_betina - old.jml_perah_betina) AS jml_perah_betina,
    (new.jml_perah_anakan_jantan - old.jml_perah_anakan_jantan) AS jml_perah_anakan_jantan,
    (new.jml_perah_anakan_betina - old.jml_perah_anakan_betina) AS jml_perah_anakan_betina
  FROM (
   SELECT
    old_id AS id,
    old_tgl_pencatatan AS tgl_pencatatan,
    old_id_peternak AS id_peternak,
    old_jenis_mitra_pengirim AS jenis_mitra_pengirim,
    old_jml_pedaging_jantan AS jml_pedaging_jantan,
    old_jml_pedaging_betina AS jml_pedaging_betina,
    old_jml_pedaging_anakan_jantan AS jml_pedaging_anakan_jantan,
    old_jml_pedaging_anakan_betina AS jml_pedaging_anakan_betina,
    old_jml_perah_jantan AS jml_perah_jantan,
    old_jml_perah_betina AS jml_perah_betina,
    old_jml_perah_anakan_jantan AS jml_perah_anakan_jantan,
    old_jml_perah_anakan_betina AS jml_perah_anakan_betina
   FROM cte_op_update_flg
   WHERE flag_asc = 1
  ) AS old
  JOIN (
    SELECT
      new_id AS id,
      new_tgl_pencatatan AS tgl_pencatatan,
      new_id_peternak AS id_peternak,
      new_jenis_mitra_pengirim AS jenis_mitra_pengirim,
      new_jml_pedaging_jantan AS jml_pedaging_jantan,
      new_jml_pedaging_betina AS jml_pedaging_betina,
      new_jml_pedaging_anakan_jantan AS jml_pedaging_anakan_jantan,
      new_jml_pedaging_anakan_betina AS jml_pedaging_anakan_betina,
      new_jml_perah_jantan AS jml_perah_jantan,
      new_jml_perah_betina AS jml_perah_betina,
      new_jml_perah_anakan_jantan AS jml_perah_anakan_jantan,
      new_jml_perah_anakan_betina AS jml_perah_anakan_betina
    FROM cte_op_update_flg
    WHERE flag_dsc = 1
  ) AS new
  ON old.id = new.id
),
cte_op_delete AS (
  SELECT
    old_id AS id,
    old_tgl_pencatatan AS tgl_pencatatan,
    old_id_peternak AS id_peternak,
    old_jenis_mitra_pengirim AS jenis_mitra_pengirim,
    (-1 * old_jml_pedaging_jantan) AS jml_pedaging_jantan,
    (-1 * old_jml_pedaging_betina) AS jml_pedaging_betina,
    (-1 * old_jml_pedaging_anakan_jantan) AS jml_pedaging_anakan_jantan,
    (-1 * old_jml_pedaging_anakan_betina) AS jml_pedaging_anakan_betina,
    (-1 * old_jml_perah_jantan) AS jml_perah_jantan,
    (-1 * old_jml_perah_betina) AS jml_perah_betina,
    (-1 * old_jml_perah_anakan_jantan) AS jml_perah_anakan_jantan,
    (-1 * old_jml_perah_anakan_betina) AS jml_perah_anakan_betina
  FROM cte_raw_parse
  WHERE operation = 'DELETE'
),
cte_cdc_view AS (
  SELECT
    COALESCE(i.id, u.id, d.id) AS id,
    COALESCE(i.tgl_pencatatan, u.tgl_pencatatan, d.tgl_pencatatan) AS tgl_pencatatan,
    COALESCE(i.id_peternak, u.id_peternak, d.id_peternak) AS id_peternak,
    COALESCE(i.jml_pedaging_jantan, 0) + COALESCE(u.jml_pedaging_jantan, 0) + COALESCE(d.jml_pedaging_jantan, 0) AS jml_pedaging_jantan,
    COALESCE(i.jml_pedaging_betina, 0) + COALESCE(u.jml_pedaging_betina, 0) + COALESCE(d.jml_pedaging_betina, 0) AS jml_pedaging_betina,
    COALESCE(i.jml_pedaging_anakan_jantan, 0) + COALESCE(u.jml_pedaging_anakan_jantan, 0) + COALESCE(d.jml_pedaging_anakan_jantan, 0) AS jml_pedaging_anakan_jantan,
    COALESCE(i.jml_pedaging_anakan_betina, 0) + COALESCE(u.jml_pedaging_anakan_betina, 0) + COALESCE(d.jml_pedaging_anakan_betina, 0) AS jml_pedaging_anakan_betina,
    COALESCE(i.jml_perah_jantan, 0) + COALESCE(u.jml_perah_jantan, 0) + COALESCE(d.jml_perah_jantan, 0) AS jml_perah_jantan,
    COALESCE(i.jml_perah_betina, 0) + COALESCE(u.jml_perah_betina, 0) + COALESCE(d.jml_perah_betina, 0) AS jml_perah_betina,
    COALESCE(i.jml_perah_anakan_jantan, 0) + COALESCE(u.jml_perah_anakan_jantan, 0) + COALESCE(d.jml_perah_anakan_jantan, 0) AS jml_perah_anakan_jantan,
    COALESCE(i.jml_perah_anakan_betina, 0) + COALESCE(u.jml_perah_anakan_betina, 0) + COALESCE(d.jml_perah_anakan_betina, 0) AS jml_perah_anakan_betina
  FROM cte_op_insert AS i
  FULL JOIN cte_op_update AS u
    ON i.id = u.id
  FULL JOIN cte_op_delete AS d
    ON i.id = d.id
    AND u.id = d.id
)
SELECT * FROM cte_cdc_view;
