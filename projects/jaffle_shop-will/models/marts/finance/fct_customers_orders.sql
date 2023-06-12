{{
  config(
    enabled = true
  )
}}

with
-- import ctes
orders as (

  select * from {{ ref('int_orders') }}

),

customers as (

  select * from {{ ref('stg_jaffle_shop__customers') }}

),

-- marts
customer_order_history as (

  select

    c.customer_id,
    c.full_name,
    c.surname,
    c.givenname,

    min(o.order_date) as first_order_date,

    min(o.valid_order_date) as first_non_returned_order_date,

    max(o.valid_order_date) as most_recent_non_returned_order_date,

    coalesce(max(o.user_order_seq),0) as order_count,

    coalesce(count(o.valid_order_date),0) as non_returned_order_count,

    sum(case
      when o.valid_order_date is not null
      then o.order_value_dollars else 0
    end) as total_lifetime_value,

    sum(case
      when o.valid_order_date is not null
      then o.order_value_dollars else 0
    end) /
    nullif(count(case
      when o.valid_order_date is not null
      then 1
    end),0) as avg_non_returned_order_value,

    array_agg(distinct o.order_id) as order_ids

  from orders o

  join customers c
  on o.customer_id = c.customer_id

  where o.order_status not in ('pending')

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
    o.order_value_dollars,
    o.order_status,
    o.payment_status,

    coh.first_order_date,
    coh.order_count,
    coh.total_lifetime_value,
    coh.first_non_returned_order_date,
    coh.most_recent_non_returned_order_date,
    coh.non_returned_order_count,

  from orders o

  join customer_order_history coh
  on o.customer_id = coh.customer_id
)

-- simple select statement

select * from final
