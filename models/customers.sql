WITH customers AS (
    SELECT * FROM {{ ref('raw_customers') }}
),

orders AS (
    SELECT * FROM {{ ref('raw_orders') }}
),

payments AS (
    SELECT * FROM {{ ref('raw_payments') }}
),

customer_orders AS (
    SELECT
        user_id AS customer_id,
        MIN(order_date) AS first_order,
        MAX(order_date) AS most_recent_order,
        COUNT(*) AS number_of_orders
    FROM orders
    GROUP BY user_id
),

customer_payments AS (
    SELECT
        o.user_id AS customer_id,
        SUM(p.amount) AS customer_lifetime_value
    FROM payments p
    JOIN orders o ON p.order_id = o.id
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
FROM customers c
LEFT JOIN customer_orders co ON c.id = co.customer_id
LEFT JOIN customer_payments cp ON c.id = cp.customer_id