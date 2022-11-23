

  create or replace view `ae-recruitment-sandbox`.`dbt_sandbox16`.`stg_ecommerce__products`
  OPTIONS()
  as with products as (
        select * from `ae-recruitment-sandbox`.`raw`.`products`
),

final as (
    SELECT
        product_id --primary key
      , product_category_name
      , product_name_lenght as product_name_length
      , product_description_lenght as product_description_length
      , product_photos_qty
      , product_weight_g
      , product_length_cm
      , product_height_cm
      , product_width_cm

    from products
)

select * from final;

