
  
    

    create or replace table `ae-recruitment-sandbox`.`dbt_sandbox16`.`dim_customers`
    
    
    OPTIONS()
    as (
      

with cust_orders AS (
    SELECT customer_unique_id
      , customer_city
      , customer_state
      , customer_zip_code_prefix
      , order_id
      , order_status
      , order_purchase_timestamp
      , order_approved_at
      , order_delivered_carrier_date
      , order_delivered_customer_date
      , order_estimated_delivery_date
FROM `ae-recruitment-sandbox.raw.customers` customers
LEFT JOIN `ae-recruitment-sandbox.raw.orders` orders
  ON customers.customer_id = orders.customer_id
)
,
final AS (
    SELECT customer_unique_id
      , customer_city
      , customer_state
      , customer_zip_code_prefix
      , COUNT(DISTINCT order_id) AS num_orders
      , MIN(order_purchase_timestamp) AS earliest_order
      , MAX(order_purchase_timestamp) AS recent_order
FROM cust_orders
GROUP BY customer_unique_id
      , customer_city
      , customer_state
      , customer_zip_code_prefix
        )

SELECT * FROM final
    );
  