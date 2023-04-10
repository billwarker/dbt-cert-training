with customers as (
    select * from {{ref('dim_customers')}}
)

select
    customer_id

from customers

where
    first_order_date > most_recent_order_date