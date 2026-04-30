{{ config(materialized='table') }}

SELECT 
    id AS customer_id,
    first_name,
    last_name
FROM {{ ref('stg_customers') }};
