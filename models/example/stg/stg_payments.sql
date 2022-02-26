{{
    config(
        materialized='view'
    )
}}

with pay as 
(
    select 
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
    from
    raw.payments

)

select * from pay