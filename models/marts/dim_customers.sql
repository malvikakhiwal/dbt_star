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
        count(distinct orders.order_id) as num_orders,
        min(order_purchase_timestamp) as earliest_order,
        max(order_purchase_timestamp) as recent_order,
        round(sum(price), 2) as total_orders_value,
        max(price) as most_expensive_order_value
    from customers
    left join orders
              on customers.customer_id = orders.customer_id
    left join order_items
               on orders.order_id = order_items.order_id
    group by customer_unique_id
)



select 
    customers.customer_unique_id
    ,customers.customer_city
    ,customers.customer_state
        ,customers.customer_zip_code_prefix
            ,num_orders
            , earliest_order
            ,recent_order
            ,total_orders_value
            ,most_expensive_order_value
from customers
    left JOIN cust_orders 
    ON customers.customer_unique_id = cust_orders.customer_unique_id