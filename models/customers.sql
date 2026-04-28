WITH customers AS (

    SELECT
        id AS customer_id,
        first_name,
        last_name
    FROM {{ ref('raw_customers') }}

),

orders AS (

    SELECT
        id AS order_id,
        user_id AS customer_id,
        order_date,
        status
    FROM {{ ref('raw_orders') }}

),

payments AS (

    SELECT
        id AS payment_id,
        order_id,
        payment_method,
        amount
    FROM {{ ref('raw_payments') }}

),

customer_orders AS (

    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        o.order_id,
        o.order_date,
        o.status,
        p.payment_method,
        p.amount
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
    LEFT JOIN payments p
        ON o.order_id = p.order_id

)

SELECT *
FROM customer_orders
