select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select order_id
from `ae-recruitment-sandbox`.`dbt_sandbox16`.`stg_ecommerce__orders`
where order_id is null



      
    ) dbt_internal_test