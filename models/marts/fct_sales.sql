with customers as (
    select * from {{ ref('stg_ecommerce__customers') }}
),

orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

dedupe_customers as (
    select
        customer_unique_id,
        customer_id,
        customer_city,
        customer_state,
        customer_zip_code_prefix,
        row_number()over(partition by customer_unique_id) as dedupe
    from customers
)
,
cust_orders AS (
    SELECT customer_unique_id
      , product_id
      , order_purchase_timestamp
      , order_delivered_customer_date
      , ROW_NUMBER() OVER(PARTITION BY customer_unique_id, product_id ORDER BY order_purchase_timestamp) as purchase_number
FROM dedupe_customers
LEFT JOIN orders
  ON dedupe_customers.customer_id = orders.customer_id
JOIN order_items
      ON orders.order_id = order_items.order_id
WHERE dedupe = 1
)

,
final as (
    SELECT customer_unique_id
      , product_id
      , CASE WHEN purchase_number = 1 THEN 'New'
             ELSE 'Repeat' END AS new_or_repeat_purchase
      , DATE_DIFF(CAST(order_delivered_customer_date AS DATE), CAST(order_purchase_timestamp AS DATE), day) as purchase_delivery_diff
FROM cust_orders
)

SELECT *
FROM final