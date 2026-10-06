use role accountadmin;

create warehouse if not exists zomato_wh
  warehouse_size='xsmall'
  auto_suspend=60
  auto_resume=True
  initially_suspended=true;

create database if not exists zomato;
create schema if not exists zomato.raw;
create schema if not exists zomato.staging;
create schema if not exists zomato.marts;
create schema if not exists zomato.snapshots;
create schema if not exists zomato.ai;

create role if not exists dbt_role;
grant usage on warehouse zomato_wh to role dbt_role;
grant operate on warehouse zomato_wh to role dbt_role;
grant all on all schemas in database zomato to role dbt_role;
grant all on database zomato to role dbt_role;
grant all on future schemas in database zomato to role dbt_role;
grant all on future tables in database zomato to role dbt_role;
grant all on future views in database zomato to role dbt_role;

set my_user = current_user();
grant role dbt_role to user identifier($my_user);

select 'setup complete' as status;