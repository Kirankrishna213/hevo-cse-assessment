{{ config(materialized='view') }}

SELECT
    sale_id,
    car_brand,
    model,
    amount,
    updated_at
FROM HEVO_DB.RAW_PUBLIC.CAR_SALES