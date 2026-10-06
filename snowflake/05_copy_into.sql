use role accountadmin;
use database zomato;
use schema raw;
use warehouse zomato_wh;

copy into raw.restaurants from @zomato_raw_stage/restaurants on_error = 'continue';
copy into raw.users from @zomato_raw_stage/users on_error = 'continue';
copy into raw.food from @zomato_raw_stage/food on_error = 'continue';
copy into raw.menu from @zomato_raw_stage/menu on_error = 'continue';

copy into raw.orders from @zomato_raw_stage/orders on_error = 'abort_statement';
copy into raw.order_items from @zomato_raw_stage/order_items on_error = 'abort_statement';
copy into raw.reviews from @zomato_raw_stage/reviews on_error = 'abort_statement';
