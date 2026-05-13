{{ config(
    materialized='table'
) }}

SELECT

    c.id AS customer_id,

    CONCAT(
        c.first_name,
        ' ',
        c.last_name
    ) AS customer_name,

    MIN(o.order_date) AS first_order,

    MAX(o.order_date) AS most_recent_order,

    COUNT(DISTINCT o.id) AS total_orders,

    SUM(p.amount) AS customer_lifetime_value

FROM HEVO_DB.RAW_PUBLIC.RAW_CUSTOMERS c

LEFT JOIN HEVO_DB.RAW_PUBLIC.RAW_ORDERS o
    ON c.id = o.user_id

LEFT JOIN HEVO_DB.RAW_PUBLIC.RAW_PAYMENTS p
    ON o.id = p.order_id

GROUP BY
    c.id,
    c.first_name,
    c.last_name