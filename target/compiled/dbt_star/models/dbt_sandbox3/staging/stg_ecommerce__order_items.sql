with order_items as (
        select * from `ae-recruitment-sandbox`.`raw`.`order_items`
),

final as (
    SELECT
        order_id --primary key
      , order_item_id
      , product_id
      , seller_id
      , shipping_limit_date
      , price
      , freight_value

    from order_items
)

select * from final