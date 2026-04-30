{{ config(materialized='view') }}

SELECT 
    id,
    first_name,
    last_name
FROM HEVO_DB.HEVO_PUBLIC.RAW_CUSTOMERS
