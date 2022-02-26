{{
    config(
        materialized='view'
    )
}}

with prd as 
(
    select
    product_id,
    product_category_name,
    product_name_lenght as product_name_length,
    product_description_lenght as product_description_length,
    product_photos_qty,
    product_weight_g as product_weight_gm ,
    product_length_cm,
    product_height_cm,
    product_width_cm
    from
    raw.products
)

select * from prd