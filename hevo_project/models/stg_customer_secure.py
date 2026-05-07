def model(dbt, session):

    dbt.config(
        materialized="table"
    )

    df = dbt.source("raw_public", "customer_secure")

    from snowflake.snowpark.functions import (
        col,
        upper,
        concat,
        lit,
        substring
    )

    transformed_df = df.select(

        col("CUSTOMER_ID"),

        upper(col("FULL_NAME")).alias("FULL_NAME"),

        concat(
            lit("******"),
            substring(col("PHONE"), -4, 4)
        ).alias("MASKED_PHONE"),

        concat(
            lit("XXX-XX-"),
            substring(col("SSN"), -4, 4)
        ).alias("MASKED_SSN"),

        col("CITY"),
        col("CREATED_AT")

    )

    return transformed_df