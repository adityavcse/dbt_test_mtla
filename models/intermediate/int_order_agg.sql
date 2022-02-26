{{
    config(
        materialized='table'
    )
}}

with order_agg as 
(
    select 
    order_id,
    sum(price) as order_price
    from 
    {{ref ("stg_order_items")}}
    group by 
    1
)
,
order_cust as (
    select 
    customer_unique_id,
    order_id
    from 
    {{ref ("stg_orders")}}
)

select 
b.customer_unique_id,
a.order_id,
a.order_price
from 
order_agg a INNER JOIN 
order_cust b ON a.order_id=b.order_id