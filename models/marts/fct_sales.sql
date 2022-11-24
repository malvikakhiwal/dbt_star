with customers as (
    select * from {{ ref('stg_ecommerce__customers') }}
),

order_items as (
    select * from {{ ref('int_order_and_order_items') }}
),

rank_product_purchased_per_customer as (
    select
        order_items.*,
        date_diff(
            cast(order_delivered_customer_date as date), cast(order_purchase_timestamp as date), day
        ) as purchase_delivery_diff,
        row_number() over(
            partition by customer_unique_id, product_id order by order_purchase_timestamp
        ) as purchase_number
    from order_items
    left join customers
        on
            order_items.customer_id = customers.customer_id
)

select
    rank_product_purchased_per_customer.*,
    case when rank_product_purchased_per_customer.purchase_number = 1 then 'New'
        else 'Repeat' end as new_or_repeat_purchase
from rank_product_purchased_per_customer
