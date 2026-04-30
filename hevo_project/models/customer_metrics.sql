{{ config(materialized='table') }}

WITH customer_orders AS (

    SELECT
        customer_id,
        MIN(order_date) AS first_order,
        MAX(order_date) AS most_recent_order,
        COUNT(order_id) AS number_of_orders
    FROM {{ ref('fact_orders') }}
    GROUP BY customer_id

),

customer_payments AS (

    SELECT
        customer_id,
        COALESCE(SUM(amount), 0) AS customer_lifetime_value
    FROM {{ ref('fact_orders') }}
    GROUP BY customer_id

)

SELECT
    d.customer_id,
    d.first_name,
    d.last_name,
    co.first_order,
    co.most_recent_order,
    co.number_of_orders,
    cp.customer_lifetime_value
FROM {{ ref('dim_customers') }} d
LEFT JOIN customer_orders co
    ON d.customer_id = co.customer_id
LEFT JOIN customer_payments cp
    ON d.customer_id = cp.customer_id;
