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
cust_orders as (
    select
        customer_unique_id,
        product_id,
        order_purchase_timestamp,
        order_delivered_customer_date,
        row_number() over(
            partition by customer_unique_id, product_id order by order_purchase_timestamp
        ) as purchase_number
    from dedupe_customers
    left join orders
              on dedupe_customers.customer_id = orders.customer_id
    inner join order_items
               on orders.order_id = order_items.order_id
    where dedupe = 1
)

,
final as (
    select
        customer_unique_id,
        product_id,
        case when purchase_number = 1 then 'New'
            else 'Repeat' end as new_or_repeat_purchase,
        date_diff(
            cast(order_delivered_customer_date as date), cast(order_purchase_timestamp as date), day
        ) as purchase_delivery_diff
    from cust_orders
)

select *
from final
