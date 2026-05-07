{{ config(
    materialized='table'
) }}

WITH ranked_sales AS (

    SELECT
        sale_id,
        car_brand,
        model,
        amount,
        updated_at,
        __hevo_op_type,

        ROW_NUMBER() OVER (
            PARTITION BY sale_id
            ORDER BY updated_at DESC
        ) AS rn

    FROM HEVO_DB.RAW_PUBLIC.CAR_SALES

)

SELECT
    sale_id,
    car_brand,
    model,
    amount,
    updated_at

FROM ranked_sales

WHERE rn = 1
AND __hevo_op_type != 'D'