# Hevo CSE Technical Assessment

## Overview
This project demonstrates an end-to-end data pipeline using PostgreSQL, Hevo, Snowflake, and dbt.

## Architecture
PostgreSQL → Hevo (Logical Replication) → Snowflake → dbt

## What I implemented
- Set up PostgreSQL using Docker and loaded raw datasets
- Configured Hevo pipeline using logical replication
- Replicated data into Snowflake warehouse
- Built dbt model to transform raw data into analytics-ready dataset
- Added data validation and tests

## dbt Model: customers
The model includes:
- customer_id
- first_name
- last_name
- first_order
- most_recent_order
- number_of_orders
- customer_lifetime_value

## Data Validation
- Row count comparison between source and model
- Duplicate detection
- Null value checks

## Assumptions
- Orders are complete and valid
- Payments correctly map to orders
- No late-arriving data

## Challenges
- Configuring logical replication for PostgreSQL
- Exposing local PostgreSQL to Hevo
- Ensuring correct joins between orders and payments

## Customer Scenarios (CSE perspective)
- Pipeline delay → Check replication lag and ingestion logs in Hevo
- Missing data → Trigger re-sync or historical load
- Schema changes → Enable auto schema mapping in Hevo
- Data mismatch → Validate source vs Snowflake and dbt outputs

## Improvements
- Incremental dbt models for performance
- Monitoring and alerting on pipeline failures
- Data quality checks at ingestion level

## How to Run
dbt run  
dbt test  

## Loom Video
(Add your Loom link here)
