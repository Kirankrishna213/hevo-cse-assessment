# Hevo CSE Assessment – End-to-End Data Pipeline with dbt

## Overview

This project demonstrates an end-to-end data pipeline that ingests data from PostgreSQL, loads it into Snowflake using Hevo, and transforms it using dbt into analytics-ready models.

---

## Note on Environment Setup

Initially, I attempted to connect a local PostgreSQL instance (Docker) to Hevo using tunneling tools.

However, this approach required exposing a local database to the internet. Tools like ngrok required account verification with a credit/debit card for TCP tunnels, and Cloudflare Tunnel faced connectivity constraints in my environment.

To ensure a stable and production-like setup, I proceeded with a managed PostgreSQL instance (Neon), which provides secure public connectivity and aligns with real-world data pipeline practices.

---

## Architecture

PostgreSQL (Source)
→ Hevo Data (CDC Ingestion)
→ Snowflake (RAW Layer)
→ dbt (Transformations)
→ STG → DIM → FACT → MART

---

## Tech Stack

* PostgreSQL (Neon) – Source database
* Hevo Data – Data ingestion (CDC)
* Snowflake – Data warehouse
* dbt – Transformation and testing
* GitHub – Version control

---

## Data Pipeline Flow

1. Data is ingested from PostgreSQL into Snowflake using Hevo CDC.
2. RAW tables are created in Snowflake.
3. dbt models transform data into structured layers:

   * Staging (STG)
   * Dimension (DIM)
   * Fact (FACT)
   * Mart (Final aggregated tables)
4. dbt tests validate data quality.


---

## Setup Instructions

### 1. Clone Repository

```bash
git clone https://github.com/<your-username>/hevo-cse-assessment.git
cd hevo-cse-assessment/hevo_project
```

---

### 2. Install dbt

```bash
pip install dbt-snowflake
```

---

### 3. Configure dbt Profile

Create file:

```text
~/.dbt/profiles.yml
```

Add:

```yaml
hevo_project:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: <your_account>
      user: <your_user>
      password: <your_password>
      role: ACCOUNTADMIN
      database: HEVO_DB
      warehouse: COMPUTE_WH
      schema: HEVO_PUBLIC
```

---

### 4. Validate Connection

```bash
dbt debug
```

---

### 5. Run Models

```bash
dbt run
```

---

### 6. Run Tests

```bash
dbt test
```

---

## Data Models

### Staging Layer (STG)

* Cleans raw data
* Standardizes column names
* Removes unnecessary metadata

Tables:

* STG_ORDERS
* STG_CUSTOMERS
* STG_PAYMENTS

---

### Dimension Layer (DIM)

* Stores descriptive attributes

Table:

* DIM_CUSTOMERS

---

### Fact Layer (FACT)

* Stores transactional data

Table:

* FACT_ORDERS

---

### Mart Layer (Final)

* Aggregated business metrics

Table:

* CUSTOMER_METRICS

Metrics:

* First order date
* Most recent order
* Number of orders
* Customer lifetime value

---

## Data Quality Testing

dbt tests are defined in `schema.yml`:

* Not Null checks
* Unique constraints

Example:

```yaml
models:
  - name: dim_customers
    columns:
      - name: customer_id
        tests:
          - not_null
          - unique
```

---

## Validation Performed

* Verified row counts across layers
* Validated joins between tables
* Introduced duplicate records to test dbt validation
* Confirmed dbt test failures for data quality issues
* Resolved duplicates using aggregation logic

---

## Key Learnings

* Built an end-to-end data pipeline using Hevo and Snowflake
* Implemented layered data modeling using dbt
* Used dbt tests for automated data validation
* Understood join-related duplication issues and resolution
* Demonstrated reproducibility using dbt run

---

## Security Note

No credentials, connection strings, or sensitive information are included in this repository. Users must configure their own environment before running the project.

---

## Conclusion

This project demonstrates a production-style data pipeline with ingestion, transformation, testing, and structured data modeling using modern data engineering practices.
