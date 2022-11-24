{{
    config(
        materialized='incremental',
        unique_key=['snapshot_day','product_id']
    )
}}

with date_dim as (
    select *
    from {{ ref('date_dim') }}
    {% if is_incremental() %}

        -- this filter will only be applied on an incremental run
        where cast(date_day as date) > (select max(snapshot_day) from {{ this }})

    {% endif %}
)
,

date_dim_product as (
    select
        cast(date_day as date) as snapshot_day,
        product_id
    from {{ ref('date_dim') }}
    cross join {{ ref('dim_products') }}

)
,

fct_sales as (
    select *
    from {{ ref('fct_sales') }}
    {% if is_incremental() %}

        -- this filter will only be applied on an incremental run
        where cast(order_purchase_timestamp as date) > (select max(snapshot_day) from {{ this }})

    {% endif %}
)

select
    snapshot_day,
    date_dim_product.product_id,
    count(order_id) as total_units_sold
from
    date_dim_product
left join
    fct_sales
    on
        snapshot_day = cast(order_purchase_timestamp as date)
    and date_dim_product.product_id = fct_sales.product_id
where
    -- Filter the date dimension to give it a relevant time window
    snapshot_day >= (
        select min(cast(order_purchase_timestamp as date))
        from
            fct_sales)
group by
    snapshot_day,
    product_id
