-- Table
CREATE TABLE log_cdc (
  id BIGSERIAL,
  "timestamp" TIMESTAMP(0),
  operation VARCHAR(20),
  table_name VARCHAR(50),
  primary_key INT8,
  old_data JSON,
  new_data JSON,
  PRIMARY KEY (id)
);
