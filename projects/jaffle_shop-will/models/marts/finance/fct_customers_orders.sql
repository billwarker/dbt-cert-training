{{
  config(
    enabled = true
  )
}}

with
-- import ctes
orders as (

  select * from {{ ref('stg_jaffle_shop__orders') }}

),

customers as (

  select * from {{ ref('stg_jaffle_shop__customers') }}

),

payments as (

  select * from {{ ref('stg_stripe__payments') }}

),

-- marts
customer_order_history as (

  select

    c.customer_id,
    c.full_name,
    c.surname,
    c.givenname,

    min(o.order_date) as first_order_date,

    min(case
      when o.status not in ('returned','return_pending')
      then o.order_date
    end) as first_non_returned_order_date,

    max(case
      when o.status not in ('returned','return_pending')
      then o.order_date
    end) as most_recent_non_returned_order_date,

    coalesce(max(user_order_seq),0) as order_count,

    coalesce(count(case
      when o.status != 'returned'
      then 1
    end),0) as non_returned_order_count,

    sum(case
      when o.status not in ('returned','return_pending')
      then p.payment_amount else 0
    end) as total_lifetime_value,

    sum(case
      when o.status not in ('returned','return_pending')
      then p.payment_amount else 0
    end) /
    nullif(count(case
      when o.status not in ('returned','return_pending')
      then 1
    end),0) as avg_non_returned_order_value,

    array_agg(distinct o.order_id) as order_ids

  from orders o

  join customers c
  on o.customer_id = c.customer_id

  left outer join payments p
  on o.order_id = p.order_id

  where o.status not in ('pending') and p.status != 'fail'

  group by c.customer_id, c.full_name, c.surname, c.givenname

),

-- final cte

final as (
  select

    o.order_id,
    o.order_date,
    o.customer_id,
    coh.surname,
    coh.givenname,
    p.payment_amount as order_value_dollars,
    o.status as order_status,
    p.status as payment_status,

    coh.first_order_date,
    coh.order_count,
    coh.total_lifetime_value,

  from orders o

  join customer_order_history coh
  on o.customer_id = coh.customer_id

  left outer join payments p
  on o.order_id = p.order_id

  where p.status != 'fail'
)

-- simple select statement

select * from final
