with source as (

    select * from {{ source('stripe', 'payment') }}

),

transformed as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status,

        -- `amount` is currently stored in cents, so we convert it to dollars
        round(amount/100.0,2) AS payment_amount,
        created as created_at

    from source

)

select * from transformed
