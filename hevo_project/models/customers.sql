{{ config(materialized='table') }}

WITH orders AS (

    SELECT *
    FROM HEVO_DB.HEVO_PUBLIC.RAW_ORDERS

),

payments AS (

    SELECT *
    FROM HEVO_DB.HEVO_PUBLIC.RAW_PAYMENTS

),

customer_orders AS (

    SELECT
        o.user_id AS customer_id,
        MIN(o.order_date) AS first_order,
        MAX(o.order_date) AS most_recent_order,
        COUNT(o.id) AS number_of_orders
    FROM orders o
    GROUP BY o.user_id

),

customer_payments AS (

    SELECT
        o.user_id AS customer_id,
        SUM(p.amount) AS customer_lifetime_value
    FROM orders o
    LEFT JOIN payments p
        ON o.id = p.order_id
    GROUP BY o.user_id

)

SELECT
    c.id AS customer_id,
    c.first_name,
    c.last_name,
    co.first_order,
    co.most_recent_order,
    co.number_of_orders,
    cp.customer_lifetime_value

FROM HEVO_DB.HEVO_PUBLIC.RAW_CUSTOMERS c
LEFT JOIN customer_orders co
    ON c.id = co.customer_id
LEFT JOIN customer_payments cp
    ON c.id = cp.customer_id