{{ config(materialized='table') }}

SELECT
    dc.customer_id,
    dc.first_name,
    dc.last_name,
    cm.first_order,
    cm.most_recent_order,
    cm.number_of_orders,
    cm.customer_lifetime_value

FROM {{ ref('dim_customers') }} dc
LEFT JOIN {{ ref('customer_metrics') }} cm
    ON dc.customer_id = cm.customer_id
