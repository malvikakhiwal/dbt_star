with date_dim as (
    select * from {{ ref('date_dim') }}
),

orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

final AS (
  SELECT date_day
       , product_id
       , count(order_items.order_id) as total_units_sold
  FROM date_dim
  LEFT OUTER JOIN orders
    ON CAST(date_dim.date_day AS TIMESTAMP)  >= orders.order_purchase_timestamp
  JOIN order_items
    ON order_items.order_id = orders.order_id
  GROUP BY date_day, product_id
)

select * from final