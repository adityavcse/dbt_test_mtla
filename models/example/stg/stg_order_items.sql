{{
    config(
        materialized='view'
    )
}}

with oi as 
(
    select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price ,
    freight_value
    from 
    raw.order_items
)

select * from oi