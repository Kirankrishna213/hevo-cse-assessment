{{ config(materialized='view') }}

SELECT 
    id,
    order_id,
    amount
FROM HEVO_DB.HEVO_PUBLIC.RAW_PAYMENTS
