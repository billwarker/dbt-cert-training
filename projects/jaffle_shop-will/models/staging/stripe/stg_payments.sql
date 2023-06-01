with source as (

    select * from {{ source('stripe', 'payment') }}

),

renamed as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status,

        -- `amount` is currently stored in cents, so we convert it to dollars
        amount / 100 as amount,
        created as created_at

    from source

)

select * from renamed
