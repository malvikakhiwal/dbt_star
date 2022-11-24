with customers as (
    select * from {{ ref('stg_ecommerce__customers') }}
),

orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

cust_orders as (
    select
        customer_unique_id,
        customer_city,
        customer_state,
        customer_zip_code_prefix,
        orders.order_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        price
    from customers
    left join orders
              on customers.customer_id = orders.customer_id
    inner join order_items
               on orders.order_id = order_items.order_id
)

,

aggregation as (
    select
        customer_unique_id,
        count(distinct order_id) as num_orders,
        min(order_purchase_timestamp) as earliest_order,
        max(order_purchase_timestamp) as recent_order,
        round(sum(price), 2) as total_orders_value,
        max(price) as most_expensive_order_value
    from cust_orders
    group by customer_unique_id
)

select * from aggregation
