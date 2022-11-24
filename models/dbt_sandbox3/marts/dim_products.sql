with products as (
    select * from {{ ref('stg_ecommerce__products') }}
),


order_items as (
    select * from {{ ref('stg_ecommerce__order_items') }}
),

products_orders as (
    select
        products.product_id,
        order_id,
        price,
        product_length_cm,
        product_width_cm,
        product_height_cm
    from products
    left join order_items
        on products.product_id = order_items.product_id
)
,

aggregated as (
    select
        product_id,
        coalesce(round((product_length_cm * product_width_cm * product_height_cm), 2), 0) as product_volume_cu_cm,
        count(order_id) as total_units_sold,
        round(sum(price), 2) as revenue
    from products_orders
    group by product_id, coalesce(round((product_length_cm * product_width_cm * product_height_cm), 2), 0)
)
,
top_ten_products as (
    select
        product_id,
        total_units_sold,
        revenue,
        product_volume_cu_cm,
        dense_rank()over(order by total_units_sold desc) as ranking
    from aggregated
),

final as (select
    product_id,
    total_units_sold,
    revenue,
    product_volume_cu_cm,
    case when ranking <= 10 then 'true'
        else 'false' end as in_top_ten
    from top_ten_products
    order by ranking
)

select * from final
