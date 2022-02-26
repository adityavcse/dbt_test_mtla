{{
    config(
        materialized='table'
    )
}}


with order_type as 
(
    select 
    a.customer_unique_id,
    a.order_id,
    a.order_purchase_timestamp,
    b.first_order_date,
    case when a.order_purchase_timestamp=b.first_order_date then 'New' else 'Repeat' END as order_type from 
    {{ref ("stg_orders")}} a JOIN
    {{ref ("int_customer_agg")}} b ON 
    a.customer_unique_id=b.customer_unique_id
),

order_item as 
(
    select 
    a.order_id,
    b.order_item_id,
    a.order_purchase_timestamp,
    a.order_delivered_customer_date,
    a.order_status,
    DATE_DIFF(a.order_delivered_customer_date, a.order_purchase_timestamp,  DAY) as purchased_delivered_day_diff
    from
    {{ref ("stg_orders")}} a JOIN
    {{ref ("stg_order_items")}} b ON a.order_id=b.order_id
)

select 
a.order_id,
b.customer_unique_id,
a.order_item_id,
b.order_type,
a.purchased_delivered_day_diff
from 
order_item a JOIN
order_type b ON 
a.order_id=b.order_id
