{{
    config(
        materialized='view'
    )
}}

with cust as 
(
    select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state 
    from 
    raw.customers
    
)

select * from cust