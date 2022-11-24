with date_dim as (
    select * from {{ ref('date_dim') }}
),

orders as (
    select * from {{ ref('stg_ecommerce__orders') }}
),

order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

final as (
    select
        date_day,
        product_id,
        count(order_items.order_id) as total_units_sold
    from date_dim
    left outer join orders
        on cast(date_dim.date_day as timestamp) >= orders.order_purchase_timestamp
    inner join order_items
        on order_items.order_id = orders.order_id
    group by date_day, product_id
)

select * from final
