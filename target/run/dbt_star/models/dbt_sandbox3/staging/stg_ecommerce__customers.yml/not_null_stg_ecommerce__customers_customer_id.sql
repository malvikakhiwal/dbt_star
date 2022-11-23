select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select customer_id
from `ae-recruitment-sandbox`.`dbt_sandbox16`.`stg_ecommerce__customers`
where customer_id is null



      
    ) dbt_internal_test