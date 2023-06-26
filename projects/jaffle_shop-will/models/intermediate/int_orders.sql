with
orders as (

  select * from {{ ref('stg_jaffle_shop__orders') }}

),

payments as (

  select * from {{ ref('stg_stripe__payments') }}
  where status != 'fail'

),

orders_total as (

  select

    order_id,
    status AS payment_status,
    sum(payment_amount) as order_value_dollars
  
  from payments
  group by 1, 2

),

order_values_joined as (

    select

      orders.* except (status),
      orders.status as order_status,
      orders_total.payment_status,
      orders_total.order_value_dollars
      
    from orders
    left join orders_total
      on orders.order_id = orders_total.order_id
      )

select * from order_values_joined
