{{ config(
    materialized='incremental',
    unique_key='sale_id'
) }}

SELECT
    sale_id,
    car_brand,
    model,
    amount,
    updated_at
FROM {{ ref('stg_car_sales') }}

{% if is_incremental() %}

WHERE updated_at > (
    SELECT MAX(updated_at)
    FROM {{ this }}
)

{% endif %}