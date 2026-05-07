{{ config(materialized='incremental') }}

SELECT
    customer_id,
    full_name,
    masked_email,
    masked_phone,
    masked_ssn,
    city,
    created_at,
    is_deleted

FROM {{ ref('stg_customer_secure') }} 