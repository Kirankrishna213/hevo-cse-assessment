{{ config(materialized='table') }}

SELECT 
    o.id AS order_id,
    o.customer_id,
    o.order_date,
    p.amount
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_payments') }} p
    ON o.id = p.order_id;
