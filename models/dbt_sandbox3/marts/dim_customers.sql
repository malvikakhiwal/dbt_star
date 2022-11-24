with customers as (
    select * from {{ ref('stg_ecommerce__customers') }}
),

orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

cust_orders AS (
    select customer_unique_id
      , customer_city
      , customer_state
      , customer_zip_code_prefix
      , orders.order_id
      , order_status
      , order_purchase_timestamp
      , order_approved_at
      , order_delivered_carrier_date
      , order_delivered_customer_date
      , order_estimated_delivery_date
      , price
from customers
left join orders
  on customers.customer_id = orders.customer_id
join order_items
      ON orders.order_id = order_items.order_id
)

,

aggregation as (
  select customer_unique_id
      , COUNT(DISTINCT order_id) AS num_orders
      , MIN(order_purchase_timestamp) AS earliest_order
      , MAX(order_purchase_timestamp) AS recent_order
      , ROUND(SUM(price),2) as total_orders_value
      , MAX(price) as most_expensive_order_value
from cust_orders
group by customer_unique_id
      )

select * from aggregation