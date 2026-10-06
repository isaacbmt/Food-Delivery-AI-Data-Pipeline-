use role accountadmin;
use database zomato;
use schema raw;

create or replace file format zomato.raw.csv_fmt
    type = 'CSV'
    compression = 'AUTO'
    field_delimiter = ','
    field_optionally_enclosed_by = '"'
    skip_header = 1
    empty_field_as_null = TRUE
    null_if = (' ', '\\N', 'NULL')
    trim_space = FALSE
    error_on_column_count_mismatch = FALSE;

-- Use credentials if storage integration does not work
create or replace stage zomato.raw.zomato_raw_stage
    -- credentials = (aws_key_id = 'AWS_KEY_ID' aws_secret_key = 'AWS_SECRET_ID') 
    url = 's3://zomato-pipeline-isaac/raw/'
    file_format = zomato.raw.csv_fmt;


list @zomato.raw.zomato_raw_stage;

