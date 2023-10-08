{% snapshot mock_orders %}

{{
    config(
        target_schema = 'snapshots',
        unique_key = 'order_id',

        strategy = 'timestamp',
        updated_at = 'updated_at'
    )
}}

SELECT * FROM `jaffle-shop-will-dev.analytics.mock_orders`

{% endsnapshot %}