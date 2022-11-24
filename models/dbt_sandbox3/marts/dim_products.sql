with products as (
    select * from {{ ref('stg_ecommerce__products') }}
),


order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

products_orders as (
  SELECT products.product_id
       , order_id
       , price
       , product_length_cm
       , product_width_cm
       , product_height_cm 
FROM products
LEFT JOIN order_items
 ON products.product_id = order_items.product_id
)
,

aggregated as (
  SELECT product_id
      , COALESCE(ROUND((product_length_cm * product_width_cm * product_height_cm), 2),0) as product_volume_cu_cm
      , COUNT(order_id) as total_units_sold
      , ROUND(SUM(price), 2) as revenue
  FROM products_orders
  GROUP BY product_id, COALESCE(ROUND((product_length_cm * product_width_cm * product_height_cm), 2),0)
)
,
top_ten_products as (
  SELECT product_id
       , total_units_sold
       , revenue
       , product_volume_cu_cm
       , DENSE_RANK()OVER(ORDER BY total_units_sold desc) as ranking
  FROM aggregated
)

, final as (SELECT product_id
       , total_units_sold
       , revenue
       , product_volume_cu_cm
       , CASE WHEN ranking <= 10 THEN 'true'
        ELSE 'false' END AS in_top_ten
from top_ten_products
ORDER BY ranking
)

select * from final