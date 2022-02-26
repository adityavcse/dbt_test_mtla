{{
    config(
        materialized='table'
    )
}}

with prd_order_items as 
(
    select 
    product_id,
    sum(price-freight_value) as total_revenue,
    count(order_item_id) as total_units_sold
    from 
    {{ref("stg_order_items")}}
    group by 1

),

stg_prd as 
(
    select 
    product_id,
    product_length_cm*product_width_cm*product_height_cm as product_volume 
    from 
    {{ref("stg_products")}}
),

fin as 
(
select 
a.product_id,
a.total_units_sold,
a.total_revenue,
b.product_volume,
row_number() over(order by total_units_sold desc ) as rn
from
 prd_order_items a JOIN 
 stg_prd b ON a.product_id=b.product_id
)

select 
product_id,
total_units_sold,
total_revenue,
product_volume,
case when rn<=10 then 1 else 0 end as flag_top10
from fin 