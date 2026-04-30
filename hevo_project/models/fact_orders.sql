WITH payments_agg AS (

    SELECT
        order_id,
        SUM(amount) AS amount
    FROM {{ ref('stg_payments') }}
    GROUP BY order_id

)

SELECT 
    o.id AS order_id,
    o.customer_id,
    o.order_date,
    p.amount
FROM {{ ref('stg_orders') }} o
LEFT JOIN payments_agg p
    ON o.id = p.order_id