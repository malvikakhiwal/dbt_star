

  create or replace view `ae-recruitment-sandbox`.`dbt_sandbox16`.`stg_ecommerce__orders`
  OPTIONS()
  as with orders as (
        select * from `ae-recruitment-sandbox`.`raw`.`orders`
),

final as (
    SELECT
        order_id --primary key
      , customer_id
      , order_status
      , order_purchase_timestamp
      , order_approved_at
      , order_delivered_carrier_date
      , order_delivered_customer_date
      , order_estimated_delivery_date

    from orders
)

select * from final;

