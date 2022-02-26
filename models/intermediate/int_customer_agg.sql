{{
    config(
        materialized='table'
    )
}}

with joined as 
(
select 
customer_unique_id,
count(distinct a.order_id) as num_orders,
sum(b.price) as total_orders_value,
min(a.order_purchase_timestamp) as first_order_date,
max(a.order_purchase_timestamp) as latest_order_date,
max(b.price) as max_item_price
from 
{{ref ("stg_orders")}} a LEFT JOIN 
{{ref ("stg_order_items")}} b
ON a.order_id=b.order_id
group by 1
)

select * from joined