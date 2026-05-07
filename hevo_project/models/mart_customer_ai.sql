{{ config(materialized='table') }}

SELECT
    customer_id,
    first_name,
    customer_lifetime_value,

    SNOWFLAKE.CORTEX.COMPLETE(
        'llama3-8b',

        CONCAT(
            'Classify this customer into business tier based on lifetime value: ',
            customer_lifetime_value
        )

    ) AS ai_customer_tier

FROM {{ ref('customer_metrics') }}