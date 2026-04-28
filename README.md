# Hevo Data Engineering Assessment

## Overview

This project demonstrates an end-to-end data pipeline built using Hevo.
The goal was to replicate data from PostgreSQL to Snowflake in near real-time and validate successful ingestion.

---

## Architecture

PostgreSQL (Neon) → Hevo Pipeline (CDC using WAL) → Snowflake

---

## Tech Stack

* PostgreSQL (Neon)
* Snowflake
* Hevo Data
* SQL

---

## Dataset

The following tables were used:

* raw_customers
* raw_orders
* raw_payments

These tables simulate transactional data for customers, orders, and payments.

---

## Step 1: Source Setup (PostgreSQL)

Used Neon (cloud PostgreSQL) to avoid networking limitations.

Enabled logical replication:

```sql
CREATE PUBLICATION hevo_pub FOR ALL TABLES;
SELECT * FROM pg_create_logical_replication_slot('hevo_slot', 'pgoutput');
```

Verified:

```sql
SHOW wal_level;
```

---

## Step 2: Destination Setup (Snowflake)

Configured Snowflake with:

* Database: HEVO_DB
* Schema: HEVO_PUBLIC
* Warehouse: COMPUTE_WH

Connection was established using account URL and credentials.

---

## Step 3: Hevo Pipeline Configuration

### Source Configuration

* Source Type: PostgreSQL
* Mode: Logical Replication (WAL)
* Publication: hevo_pub
* Replication Slot: hevo_slot

### Destination Configuration

* Destination: Snowflake
* Load Mode: Merge
* Schema Evolution: Enabled
* Replication: Historical + Incremental

---

## Step 4: Pipeline Execution

* Pipeline executed successfully
* Records ingested and loaded without failures

Example job summary:

* Events Ingested: 312
* Events Loaded: 312
* Failures: 0

---

## Step 5: Validation in Snowflake

Tables created in:
HEVO_DB.HEVO_PUBLIC

```sql
USE DATABASE HEVO_DB;
USE SCHEMA HEVO_PUBLIC;

SELECT COUNT(*) FROM RAW_CUSTOMERS;
SELECT COUNT(*) FROM RAW_ORDERS;
SELECT COUNT(*) FROM RAW_PAYMENTS;
```

All tables successfully replicated.

---

## Step 6: Networking Attempt (Local PostgreSQL)

Attempted to connect a local Docker PostgreSQL instance to Hevo.

Approach:

* Used Cloudflare Tunnel to expose localhost
* Configured PostgreSQL for logical replication

Challenge:

* Cloudflare quick tunnels support HTTP-based routing
* TCP-based PostgreSQL connections were not reliably supported

Conclusion:
For production-grade pipelines, a stable cloud-hosted database is preferred.

---

## Key Learnings

* Logical replication (WAL) is required for real-time CDC
* Hevo simplifies ingestion and schema evolution
* Snowflake automatically handles scalable storage and querying
* Networking is a critical factor when connecting local systems to cloud services

---

## Final Outcome

* Successfully built an end-to-end data pipeline
* Achieved near real-time replication
* Validated data integrity in Snowflake

---

## Notes

This implementation prioritizes reliability and scalability by using cloud-hosted PostgreSQL instead of local instances.

---

## Author

Kiran Krishna
