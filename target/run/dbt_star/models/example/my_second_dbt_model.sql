

  create or replace view `ae-recruitment-sandbox`.`dbt_sandbox16`.`my_second_dbt_model`
  OPTIONS()
  as -- Use the `ref` function to select from other models

select *
from `ae-recruitment-sandbox`.`dbt_sandbox16`.`my_first_dbt_model`
where id = 1;

