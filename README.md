# Real-Time Data Pipeline using PostgreSQL, Hevo, Snowflake and dbt

---

## Project Overview

This project demonstrates an end-to-end real-time data pipeline that captures data changes from PostgreSQL and loads them into Snowflake using Change Data Capture (CDC). The ingested raw data is then transformed into analytics-ready models using dbt.

The objective is to showcase practical understanding of modern data engineering workflows, including ingestion, replication, transformation, and validation.

---

## Architecture

PostgreSQL (Neon)
→ Hevo Data (CDC via Logical Replication)
→ Snowflake (Raw Layer - HEVO_PUBLIC)
→ dbt (Transformation Layer)
→ Analytics-ready models

---

## Key Concepts

* Change Data Capture (CDC)
* PostgreSQL Logical Replication
* Publications and Replication Slots
* Incremental Data Pipelines
* Cloud Data Warehousing (Snowflake)
* Data Transformation using dbt

---

## Technology Stack

* Source Database: PostgreSQL (Neon)
* Data Pipeline: Hevo Data
* Data Warehouse: Snowflake
* Transformation Tool: dbt
* Language: SQL

---

## How CDC Works in This Project

1. PostgreSQL records changes in the Write-Ahead Log (WAL)
2. A publication (`hevo_pub`) exposes these changes
3. A replication slot (`hevo_slot`) tracks consumption
4. Hevo reads changes incrementally using logical replication
5. Data is loaded into Snowflake in near real-time

---

## Setup Steps

### PostgreSQL Setup

```sql
CREATE PUBLICATION hevo_pub FOR ALL TABLES;

SELECT * 
FROM pg_create_logical_replication_slot('hevo_slot', 'pgoutput');
```

---

### Hevo Pipeline Configuration

* Source: PostgreSQL (Neon)

* Mode: Logical Replication

* Publication: `hevo_pub`

* Replication Slot: `hevo_slot`

* Destination: Snowflake

* Load Mode: Merge (to prevent duplicates)

* Schema Evolution: Enabled

---

### Snowflake Setup

```sql
USE DATABASE HEVO_DB;
USE SCHEMA HEVO_PUBLIC;

SHOW TABLES;
```

---

## Data Ingestion

Tables ingested via Hevo:

* RAW_CUSTOMERS
* RAW_ORDERS
* RAW_PAYMENTS

---

## Data Transformation using dbt

dbt is used to transform raw data into clean, analytics-ready models.

---

### dbt Models

#### stg_customers.sql

```sql
SELECT
    id AS customer_id,
    first_name,
    last_name
FROM HEVO_DB.HEVO_PUBLIC.RAW_CUSTOMERS
```

---

#### stg_orders.sql

```sql
SELECT
    id,
    customer_id,
    order_date
FROM HEVO_DB.HEVO_PUBLIC.RAW_ORDERS
```

---

#### stg_payments.sql

```sql
SELECT
    id,
    order_id,
    amount
FROM HEVO_DB.HEVO_PUBLIC.RAW_PAYMENTS
```

---

#### fact_orders.sql

```sql
SELECT
    o.id,
    o.customer_id,
    p.amount
FROM HEVO_DB.HEVO_PUBLIC.RAW_ORDERS o
LEFT JOIN HEVO_DB.HEVO_PUBLIC.RAW_PAYMENTS p
ON o.id = p.order_id
```

---

### Running dbt

```bash
dbt run
dbt test
```

---

## Data Layers

* Raw Layer: Hevo ingestion (HEVO_PUBLIC)
* Staging Layer: Cleaned data (dbt staging models)
* Analytics Layer: Final business models (fact tables)

---

## Validation

* Verified row counts between PostgreSQL and Snowflake
* Inserted new records in PostgreSQL and confirmed CDC replication
* Ensured no duplicate records using Merge mode
* Validated transformed outputs using dbt

---

## Challenges Faced

* IPv4 connectivity limitations with Supabase
* Logical replication configuration issues
* Duplicate data during initial setup
* Exposing local databases for testing

---

## Solutions

* Switched to Neon for better connectivity
* Configured publication and replication slot correctly
* Used Merge mode to prevent duplication
* Enabled schema evolution
* Validated ingestion using Snowflake queries

---

## Sample Validation Queries

```sql
SELECT COUNT(*) FROM HEVO_DB.HEVO_PUBLIC.RAW_CUSTOMERS;
SELECT COUNT(*) FROM HEVO_DB.HEVO_PUBLIC.RAW_ORDERS;
SELECT COUNT(*) FROM HEVO_DB.HEVO_PUBLIC.RAW_PAYMENTS;
```

---

## Future Improvements

* Add dbt tests and documentation
* Implement incremental dbt models
* Build dashboards using BI tools
* Add monitoring and alerting for pipeline health

---

## Conclusion

This project demonstrates a complete modern data pipeline using CDC, cloud data warehousing, and transformation tools. It reflects practical experience in building reliable pipelines, handling data ingestion challenges, and delivering analytics-ready datasets.
