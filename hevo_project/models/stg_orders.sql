{{ config(materialized='view') }}

SELECT 
    id,
    user_id AS customer_id,
    order_date
FROM HEVO_DB.HEVO_PUBLIC.RAW_ORDERS
