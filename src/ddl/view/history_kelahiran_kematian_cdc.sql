-- View
CREATE OR REPLACE VIEW history_kelahiran_kematian_cdc AS
WITH cte_raw_parse AS (
  SELECT
    operation,
    "timestamp",
    (old_data->>'id')::INT8 AS old_id,
    (old_data->>'tgl_pencatatan')::DATE AS old_tgl_pencatatan,
    (old_data->>'id_peternak')::INT8 AS old_id_peternak,
    (old_data->>'jml_lahir_pedaging_jantan')::INT4 AS old_jml_lahir_pedaging_jantan,
    (old_data->>'jml_lahir_pedaging_betina')::INT4 AS old_jml_lahir_pedaging_betina,
    (old_data->>'jml_lahir_perah_jantan')::INT4 AS old_jml_lahir_perah_jantan,
    (old_data->>'jml_lahir_perah_betina')::INT4 AS old_jml_lahir_perah_betina,
    (old_data->>'jml_mati_pedaging_jantan')::INT4 AS old_jml_mati_pedaging_jantan,
    (old_data->>'jml_mati_pedaging_betina')::INT4 AS old_jml_mati_pedaging_betina,
    (old_data->>'jml_mati_perah_jantan')::INT4 AS old_jml_mati_perah_jantan,
    (old_data->>'jml_mati_perah_betina')::INT4 AS old_jml_mati_perah_betina,
    (old_data->>'jml_mati_pedaging_anakan_jantan')::INT4 AS old_jml_mati_pedaging_anakan_jantan,
    (old_data->>'jml_mati_pedaging_anakan_betina')::INT4 AS old_jml_mati_pedaging_anakan_betina,
    (old_data->>'jml_mati_perah_anakan_jantan')::INT4 AS old_jml_mati_perah_anakan_jantan,
    (old_data->>'jml_mati_perah_anakan_betina')::INT4 AS old_jml_mati_perah_anakan_betina,
    (new_data->>'id')::INT8 AS new_id,
    (new_data->>'tgl_pencatatan')::DATE AS new_tgl_pencatatan,
    (new_data->>'id_peternak')::INT8 AS new_id_peternak,
    (new_data->>'jml_lahir_pedaging_jantan')::INT4 AS new_jml_lahir_pedaging_jantan,
    (new_data->>'jml_lahir_pedaging_betina')::INT4 AS new_jml_lahir_pedaging_betina,
    (new_data->>'jml_lahir_perah_jantan')::INT4 AS new_jml_lahir_perah_jantan,
    (new_data->>'jml_lahir_perah_betina')::INT4 AS new_jml_lahir_perah_betina,
    (new_data->>'jml_mati_pedaging_jantan')::INT4 AS new_jml_mati_pedaging_jantan,
    (new_data->>'jml_mati_pedaging_betina')::INT4 AS new_jml_mati_pedaging_betina,
    (new_data->>'jml_mati_perah_jantan')::INT4 AS new_jml_mati_perah_jantan,
    (new_data->>'jml_mati_perah_betina')::INT4 AS new_jml_mati_perah_betina,
    (new_data->>'jml_mati_pedaging_anakan_jantan')::INT4 AS new_jml_mati_pedaging_anakan_jantan,
    (new_data->>'jml_mati_pedaging_anakan_betina')::INT4 AS new_jml_mati_pedaging_anakan_betina,
    (new_data->>'jml_mati_perah_anakan_jantan')::INT4 AS new_jml_mati_perah_anakan_jantan,
    (new_data->>'jml_mati_perah_anakan_betina')::INT4 AS new_jml_mati_perah_anakan_betina
  FROM log_cdc_prc
  WHERE table_name = 'history_kelahiran_kematian'
    AND is_processed IS FALSE
),
cte_op_insert AS (
  SELECT
    new_id AS id,
    new_tgl_pencatatan AS tgl_pencatatan,
    new_id_peternak AS id_peternak,
    new_jml_lahir_pedaging_jantan AS jml_lahir_pedaging_jantan,
    new_jml_lahir_pedaging_betina AS jml_lahir_pedaging_betina,
    new_jml_lahir_perah_jantan AS jml_lahir_perah_jantan,
    new_jml_lahir_perah_betina AS jml_lahir_perah_betina,
    new_jml_mati_pedaging_jantan AS jml_mati_pedaging_jantan,
    new_jml_mati_pedaging_betina AS jml_mati_pedaging_betina,
    new_jml_mati_perah_jantan AS jml_mati_perah_jantan,
    new_jml_mati_perah_betina AS jml_mati_perah_betina,
    new_jml_mati_pedaging_anakan_jantan AS jml_mati_pedaging_anakan_jantan,
    new_jml_mati_pedaging_anakan_betina AS jml_mati_pedaging_anakan_betina,
    new_jml_mati_perah_anakan_jantan AS jml_mati_perah_anakan_jantan,
    new_jml_mati_perah_anakan_betina AS jml_mati_perah_anakan_betina
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
    nw.id,
    nw.tgl_pencatatan,
    nw.id_peternak,
    (nw.jml_lahir_pedaging_jantan - ol.jml_lahir_pedaging_jantan) AS jml_lahir_pedaging_jantan,
    (nw.jml_lahir_pedaging_betina - ol.jml_lahir_pedaging_betina) AS jml_lahir_pedaging_betina,
    (nw.jml_lahir_perah_jantan - ol.jml_lahir_perah_jantan) AS jml_lahir_perah_jantan,
    (nw.jml_lahir_perah_betina - ol.jml_lahir_perah_betina) AS jml_lahir_perah_betina,
    (nw.jml_mati_pedaging_jantan - ol.jml_mati_pedaging_jantan) AS jml_mati_pedaging_jantan,
    (nw.jml_mati_pedaging_betina - ol.jml_mati_pedaging_betina) AS jml_mati_pedaging_betina,
    (nw.jml_mati_perah_jantan - ol.jml_mati_perah_jantan) AS jml_mati_perah_jantan,
    (nw.jml_mati_perah_betina - ol.jml_mati_perah_betina) AS jml_mati_perah_betina,
    (nw.jml_mati_pedaging_anakan_jantan - ol.jml_mati_pedaging_anakan_jantan) AS jml_mati_pedaging_anakan_jantan,
    (nw.jml_mati_pedaging_anakan_betina - ol.jml_mati_pedaging_anakan_betina) AS jml_mati_pedaging_anakan_betina,
    (nw.jml_mati_perah_anakan_jantan - ol.jml_mati_perah_anakan_jantan) AS jml_mati_perah_anakan_jantan,
    (nw.jml_mati_perah_anakan_betina - ol.jml_mati_perah_anakan_betina) AS jml_mati_perah_anakan_betina
  FROM (
   SELECT
    old_id AS id,
    old_tgl_pencatatan AS tgl_pencatatan,
    old_id_peternak AS id_peternak,
    old_jml_lahir_pedaging_jantan AS jml_lahir_pedaging_jantan,
    old_jml_lahir_pedaging_betina AS jml_lahir_pedaging_betina,
    old_jml_lahir_perah_jantan AS jml_lahir_perah_jantan,
    old_jml_lahir_perah_betina AS jml_lahir_perah_betina,
    old_jml_mati_pedaging_jantan AS jml_mati_pedaging_jantan,
    old_jml_mati_pedaging_betina AS jml_mati_pedaging_betina,
    old_jml_mati_perah_jantan AS jml_mati_perah_jantan,
    old_jml_mati_perah_betina AS jml_mati_perah_betina,
    old_jml_mati_pedaging_anakan_jantan AS jml_mati_pedaging_anakan_jantan,
    old_jml_mati_pedaging_anakan_betina AS jml_mati_pedaging_anakan_betina,
    old_jml_mati_perah_anakan_jantan AS jml_mati_perah_anakan_jantan,
    old_jml_mati_perah_anakan_betina AS jml_mati_perah_anakan_betina
   FROM cte_op_update_flg
   WHERE flag_asc = 1
  ) AS ol
  JOIN (
    SELECT
      new_id AS id,
      new_tgl_pencatatan AS tgl_pencatatan,
      new_id_peternak AS id_peternak,
      new_jml_lahir_pedaging_jantan AS jml_lahir_pedaging_jantan,
      new_jml_lahir_pedaging_betina AS jml_lahir_pedaging_betina,
      new_jml_lahir_perah_jantan AS jml_lahir_perah_jantan,
      new_jml_lahir_perah_betina AS jml_lahir_perah_betina,
      new_jml_mati_pedaging_jantan AS jml_mati_pedaging_jantan,
      new_jml_mati_pedaging_betina AS jml_mati_pedaging_betina,
      new_jml_mati_perah_jantan AS jml_mati_perah_jantan,
      new_jml_mati_perah_betina AS jml_mati_perah_betina,
      new_jml_mati_pedaging_anakan_jantan AS jml_mati_pedaging_anakan_jantan,
      new_jml_mati_pedaging_anakan_betina AS jml_mati_pedaging_anakan_betina,
      new_jml_mati_perah_anakan_jantan AS jml_mati_perah_anakan_jantan,
      new_jml_mati_perah_anakan_betina AS jml_mati_perah_anakan_betina
    FROM cte_op_update_flg
    WHERE flag_dsc = 1
  ) AS nw
  ON ol.id = nw.id
),
cte_op_delete AS (
  SELECT
    old_id AS id,
    old_tgl_pencatatan AS tgl_pencatatan,
    old_id_peternak AS id_peternak,
    (-1 * old_jml_lahir_pedaging_jantan) AS jml_lahir_pedaging_jantan,
    (-1 * old_jml_lahir_pedaging_betina) AS jml_lahir_pedaging_betina,
    (-1 * old_jml_lahir_perah_jantan) AS jml_lahir_perah_jantan,
    (-1 * old_jml_lahir_perah_betina) AS jml_lahir_perah_betina,
    (-1 * old_jml_mati_pedaging_jantan) AS jml_mati_pedaging_jantan,
    (-1 * old_jml_mati_pedaging_betina) AS jml_mati_pedaging_betina,
    (-1 * old_jml_mati_perah_jantan) AS jml_mati_perah_jantan,
    (-1 * old_jml_mati_perah_betina) AS jml_mati_perah_betina,
    (-1 * old_jml_mati_pedaging_anakan_jantan) AS jml_mati_pedaging_anakan_jantan,
    (-1 * old_jml_mati_pedaging_anakan_betina) AS jml_mati_pedaging_anakan_betina,
    (-1 * old_jml_mati_perah_anakan_jantan) AS jml_mati_perah_anakan_jantan,
    (-1 * old_jml_mati_perah_anakan_betina) AS jml_mati_perah_anakan_betina
  FROM cte_raw_parse
  WHERE operation = 'DELETE'
),
cte_cdc_view AS (
  SELECT
    COALESCE(i.id, u.id, d.id) AS id,
    COALESCE(i.tgl_pencatatan, u.tgl_pencatatan, d.tgl_pencatatan) AS tgl_pencatatan,
    COALESCE(i.id_peternak, u.id_peternak, d.id_peternak) AS id_peternak,
    COALESCE(i.jml_lahir_pedaging_jantan, 0) + COALESCE(u.jml_lahir_pedaging_jantan, 0) + COALESCE(d.jml_lahir_pedaging_jantan, 0) AS jml_lahir_pedaging_jantan,
    COALESCE(i.jml_lahir_pedaging_betina, 0) + COALESCE(u.jml_lahir_pedaging_betina, 0) + COALESCE(d.jml_lahir_pedaging_betina, 0) AS jml_lahir_pedaging_betina,
    COALESCE(i.jml_lahir_perah_jantan, 0) + COALESCE(u.jml_lahir_perah_jantan, 0) + COALESCE(d.jml_lahir_perah_jantan, 0) AS jml_lahir_perah_jantan,
    COALESCE(i.jml_lahir_perah_betina, 0) + COALESCE(u.jml_lahir_perah_betina, 0) + COALESCE(d.jml_lahir_perah_betina, 0) AS jml_lahir_perah_betina,
    COALESCE(i.jml_mati_pedaging_jantan, 0) + COALESCE(u.jml_mati_pedaging_jantan, 0) + COALESCE(d.jml_mati_pedaging_jantan, 0) AS jml_mati_pedaging_jantan,
    COALESCE(i.jml_mati_pedaging_betina, 0) + COALESCE(u.jml_mati_pedaging_betina, 0) + COALESCE(d.jml_mati_pedaging_betina, 0) AS jml_mati_pedaging_betina,
    COALESCE(i.jml_mati_perah_jantan, 0) + COALESCE(u.jml_mati_perah_jantan, 0) + COALESCE(d.jml_mati_perah_jantan, 0) AS jml_mati_perah_jantan,
    COALESCE(i.jml_mati_perah_betina, 0) + COALESCE(u.jml_mati_perah_betina, 0) + COALESCE(d.jml_mati_perah_betina, 0) AS jml_mati_perah_betina,
    COALESCE(i.jml_mati_pedaging_anakan_jantan, 0) + COALESCE(u.jml_mati_pedaging_anakan_jantan, 0) + COALESCE(d.jml_mati_pedaging_anakan_jantan, 0) AS jml_mati_pedaging_anakan_jantan,
    COALESCE(i.jml_mati_pedaging_anakan_betina, 0) + COALESCE(u.jml_mati_pedaging_anakan_betina, 0) + COALESCE(d.jml_mati_pedaging_anakan_betina, 0) AS jml_mati_pedaging_anakan_betina,
    COALESCE(i.jml_mati_perah_anakan_jantan, 0) + COALESCE(u.jml_mati_perah_anakan_jantan, 0) + COALESCE(d.jml_mati_perah_anakan_jantan, 0) AS jml_mati_perah_anakan_jantan,
    COALESCE(i.jml_mati_perah_anakan_betina, 0) + COALESCE(u.jml_mati_perah_anakan_betina, 0) + COALESCE(d.jml_mati_perah_anakan_betina, 0) AS jml_mati_perah_anakan_betina
  FROM cte_op_insert AS i
  FULL JOIN cte_op_update AS u
    ON i.id = u.id
  FULL JOIN cte_op_delete AS d
    ON i.id = d.id
    AND u.id = d.id
)
SELECT * FROM cte_cdc_view;
