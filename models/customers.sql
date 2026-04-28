{{ config(materialized='table') }}

SELECT 
    c.id AS customer_id,
    c.first_name,
    c.last_name,

    MIN(o.order_date) AS first_order,
    MAX(o.order_date) AS most_recent_order,
    COUNT(DISTINCT o.id) AS number_of_orders,

    SUM(p.amount) AS customer_lifetime_value

FROM {{ ref('raw_customers') }} c
LEFT JOIN {{ ref('raw_orders') }} o 
    ON c.id = o.customer_id
LEFT JOIN {{ ref('raw_payments') }} p 
    ON o.id = p.order_id

GROUP BY c.id, c.first_name, c.last_name
