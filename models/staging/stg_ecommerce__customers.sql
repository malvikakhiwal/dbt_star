with customers as (
    select * from {{ source('stg_ecommerce', 'customers') }}
),

final as (
    select
        customer_unique_id,
        customer_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,
        row_number()over(partition by customer_unique_id) as dedupe

    from customers
)

select
    customer_unique_id,
    customer_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from final
where dedupe = 1
