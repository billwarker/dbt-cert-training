{{
  config(
    partition_by={
      "field": "payment_date",
      "data_type": "date",
      "granularity": "day"
    }
  )
}}


{% set payment_methods = dbt_utils.get_column_values(ref('stg_stripe__payments'), 'payment_method') %}

with
payments as (
    select
        date(created_at) as payment_date,
        payment_method,
        payment_amount
    from {{ ref('stg_stripe__payments') }}
    ),

daily_revenue_by_payment_type as (
    select
        payment_date,

        {{- dbt_utils.pivot(
        'payment_method',
        payment_methods,
        then_value='payment_amount'
        ) -}}
    from payments
    group by
        1
        )

select * from daily_revenue_by_payment_type
