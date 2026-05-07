{{ config(materialized='view') }}

SELECT
    customer_id,

    UPPER(full_name) AS full_name,

    SPLIT_PART(email, '@', 1) || '@*****.com'
        AS masked_email,

    'XXXXXX' || RIGHT(phone, 4)
        AS masked_phone,

    'XXX-XX-' || RIGHT(ssn, 4)
        AS masked_ssn,

    INITCAP(city) AS city,

    created_at,

    __HEVO_OP_TYPE,

    CASE
        WHEN __HEVO_OP_TYPE = 'D'
        THEN TRUE
        ELSE FALSE
    END AS is_deleted

FROM HEVO_DB.RAW_PUBLIC.CUSTOMER_SECURE