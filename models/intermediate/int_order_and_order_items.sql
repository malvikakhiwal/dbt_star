with orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
)


SELECT 
    orders.order_id
    ,orders.customer_id
   ,orders.order_status
    ,orders.order_purchase_timestamp
    ,orders.order_approved_at
    ,orders.order_delivered_carrier_date
    ,orders.order_delivered_customer_date
    ,orders.order_estimated_delivery_date
    ,order_items.order_item_id
    ,order_items.product_id
    ,order_items.seller_id

    ,order_items.shipping_limit_date
    ,order_items.price
    ,order_items.freight_value

    from orders
             
    left join order_items
               on orders.order_id = order_items.order_id
