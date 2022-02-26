{{
    config(
        materialized='view'
    )
}}

with orders as 
(
    select
    order_id,
    a.customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    b.customer_unique_id
    from
    raw.orders a 
    JOIN 
    raw.customers b ON a.customer_id=b.customer_id
)

select * from orders