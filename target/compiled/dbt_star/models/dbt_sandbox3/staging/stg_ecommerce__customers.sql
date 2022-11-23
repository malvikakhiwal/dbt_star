with customers as (
        select * from `ae-recruitment-sandbox`.`raw`.`customers`
),

final as (
    SELECT
        customer_unique_id --primary key
      , customer_id
      , customer_zip_code_prefix
      , customer_city
      , customer_state

    from customers
)

select * from final