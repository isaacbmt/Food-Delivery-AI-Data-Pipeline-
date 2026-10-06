use role accountadmin;

CREATE OR REPLACE storage integration zomato_s3_int
  type = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  enabled=TRUE
  storage_aws_role_arn='arn:aws:iam::028610957365:role/snowflake-s3-role-isaac'
  storage_allowed_locations = ('s3://zomato-pipeline-isaac/');

grant usage on integration zomato_s3_int to role dbt_role;
desc integration zomato_s3_int;
