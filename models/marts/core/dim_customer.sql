{{
    config(
        materialized='table'
    )
}}


with cust_agg as (
    select 
    customer_unique_id,
    num_orders,
    total_orders_value,
    first_order_date,
    latest_order_date,
    from 
    {{ref ("int_customer_agg")}}
),
 most_expensive as 
(
    select 
    customer_unique_id,
    max(order_price) as most_expensive_order
    from 
    {{ref ('int_order_agg')}}
    group by 
    1
)
select 
    a.customer_unique_id,
    num_orders,
    total_orders_value,
    first_order_date,
    latest_order_date,
    b.most_expensive_order
    from 
    cust_agg a LEFT JOIN 
    most_expensive b ON a.customer_unique_id=b.customer_unique_id


