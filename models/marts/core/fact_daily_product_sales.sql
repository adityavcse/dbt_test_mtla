{{
    config(
        materialized='incremental'
    )
}}


with daily_products as (
select 
product_id ,
date_day 
from {{ref("dim_dates")}} a cross join  
{{ref("stg_products")}} b 

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_day > (select max(date_day) from {{ this }})

{% endif %}
)
,
 products_sold as
(
 select 
a.product_id ,
date(b.order_purchase_timestamp) as order_purchased_date
from 
{{ref("stg_order_items")}} a JOIN 
{{ref("stg_orders")}} b 
ON a.order_id=b.order_id 
)

select 
a.product_id,
a.date_day,
sum(case when b.order_purchased_date is null then 0 else 1 end) as num  
from daily_products  a LEFT JOIN 
products_sold b ON 
a.product_id=b.product_id and a.date_day=b.order_purchased_date
group by 1,2
