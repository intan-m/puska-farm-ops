-- Table
CREATE TABLE log_cdc_prc (
  id INT8,
  "timestamp" TIMESTAMP(0),
  operation VARCHAR(20),
  table_name VARCHAR(50),
  primary_key INT8,
  old_data JSON,
  new_data JSON,
  is_processed BOOLEAN,
  PRIMARY KEY (id)
);
