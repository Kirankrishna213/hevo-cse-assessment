# Hevo CSE Assessment – End-to-End Data Pipeline

## Overview

This project demonstrates a complete data pipeline:

PostgreSQL → Hevo (CDC) → Snowflake → Transformations (Hevo Models / dbt structure)

---


## Note on Environment Setup

Initially, I attempted to connect a local PostgreSQL instance (Docker) to Hevo using tunneling tools.

However, this approach required exposing a local database to the internet. Tools like ngrok required account verification with a credit/debit card for TCP tunnels, and Cloudflare Tunnel faced network connectivity constraints in my environment.

To ensure a stable and production-like setup, I proceeded with a managed PostgreSQL instance (Neon), which provides secure public connectivity and is better aligned with real-world data pipeline architectures.

This allowed me to focus on building a reliable CDC pipeline, transformations, and data modeling without external networking dependencies.


## Architecture

PostgreSQL (Source)
→ Hevo Data (Ingestion using CDC)
→ Snowflake (RAW Tables)
→ Hevo Models (STG → DIM → FACT → AGG)
→ Analytics-ready tables

---

## Prerequisites

* PostgreSQL (Neon or local Docker)
* Hevo account
* Snowflake account
* Git installed
* GitHub repository

---

## Step 1: Setup PostgreSQL (Source)

### Connect to PostgreSQL

```bash
psql "postgresql://<user>:<password>@<host>:5432/<database>"
```

---

### Create Tables

```sql
CREATE TABLE customers (
    id INT PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    order_date DATE
);

CREATE TABLE payments (
    id INT PRIMARY KEY,
    order_id INT,
    amount NUMERIC
);
```

---

### Insert Sample Data

```sql
INSERT INTO customers VALUES (1, 'John', 'Doe');
INSERT INTO orders VALUES (1, 1, CURRENT_DATE);
INSERT INTO payments VALUES (1, 1, 100);
```

---

### Enable CDC

```sql
CREATE PUBLICATION hevo_pub FOR ALL TABLES;
```

---

## Step 2: Create Pipeline in Hevo

Go to:

Pipelines → Create Pipeline

---

### Configure Source (PostgreSQL)

Fill:

* Host
* Port: 5432
* Database: neondb
* User
* Password
* Publication: hevo_pub
* Replication Slot: hevo_slot

---

### Configure Destination (Snowflake)

Get values from Snowflake UI:

---

#### Open Snowflake

Go to:

Worksheets → Run:

```sql\

SELECT CURRENT_ACCOUNT();
SELECT CURRENT_WAREHOUSE();
SELECT CURRENT_DATABASE();
```

---

Fill in Hevo:

* Account URL → from CURRENT_ACCOUNT
* Warehouse → COMPUTE_WH
* Database → HEVO_DB
* User → ACCOUNTADMIN
* Password → your password

---

### Destination Prefix

Use:

```
RAW
```

---

### Run Pipeline

* Select tables: customers, orders, payments
* Start pipeline

---

## Step 3: Verify Data in Snowflake

Go to:

Worksheets → Run:

```sql
SELECT COUNT(*) FROM HEVO_DB.HEVO_PUBLIC.RAW_CUSTOMERS;
SELECT COUNT(*) FROM HEVO_DB.HEVO_PUBLIC.RAW_ORDERS;
SELECT COUNT(*) FROM HEVO_DB.HEVO_PUBLIC.RAW_PAYMENTS;
```

---

## Step 4: Create Models in Hevo

Go to:

Models → Create SQL Model

---

### Important Rule

Do NOT use full names:

Correct:

```sql
SELECT * FROM STG_CUSTOMERS;
```

Wrong:

```sql
SELECT * FROM HEVO_DB.HEVO_PUBLIC.STG_CUSTOMERS;
```

---

## STG Models

### STG_ORDERS

```sql
SELECT 
    ID,
    USER_ID AS CUSTOMER_ID,
    ORDER_DATE
FROM RAW_ORDERS;
```

---

### STG_CUSTOMERS

```sql
SELECT 
    ID,
    FIRST_NAME,
    LAST_NAME
FROM RAW_CUSTOMERS;
```

---

### STG_PAYMENTS

```sql
SELECT 
    ID,
    ORDER_ID,
    AMOUNT
FROM RAW_PAYMENTS;
```

---

## DIM Model

### DIM_CUSTOMERS

```sql
SELECT 
    ID AS CUSTOMER_ID,
    FIRST_NAME,
    LAST_NAME
FROM STG_CUSTOMERS;
```

Export as: DIM_CUSTOMERS

---

## FACT Model

### FACT_ORDERS

```sql
SELECT 
    o.ID AS ORDER_ID,
    o.CUSTOMER_ID,
    p.AMOUNT,
    o.ORDER_DATE
FROM STG_ORDERS o
LEFT JOIN STG_PAYMENTS p
    ON o.ID = p.ORDER_ID;
```

---

## AGG Model

### CUSTOMER_SPEND

```sql
SELECT 
    f.CUSTOMER_ID,
    d.FIRST_NAME,
    d.LAST_NAME,
    COUNT(*) AS TOTAL_ORDERS,
    SUM(f.AMOUNT) AS TOTAL_SPENT
FROM FACT_ORDERS f
LEFT JOIN DIM_CUSTOMERS d
    ON f.CUSTOMER_ID = d.CUSTOMER_ID
GROUP BY f.CUSTOMER_ID, d.FIRST_NAME, d.LAST_NAME;
```

---

## Step 5: Data Validation

### Row Count Check

```sql
SELECT COUNT(*) FROM STG_ORDERS;
SELECT COUNT(*) FROM FACT_ORDERS;
```

---

### Duplicate Check

```sql
SELECT ORDER_ID, COUNT(*)
FROM FACT_ORDERS
GROUP BY ORDER_ID
HAVING COUNT(*) > 1;
```

---

### Null Check

```sql
SELECT COUNT(*)
FROM FACT_ORDERS
WHERE CUSTOMER_ID IS NULL;
```

---

### Aggregation Check

```sql
SELECT SUM(AMOUNT) FROM FACT_ORDERS;
```

---

## Step 6: dbt + Git (Representation)

Although transformations are implemented in Hevo, equivalent dbt-style models are stored for version control.

---

### Git Commands

```bash
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/<your-username>/hevo-cse-assessment.git
git push -u origin main
```

---

## dbt-style Test Example

```yaml
version: 2

models:
  - name: dim_customers
    columns:
      - name: customer_id
        tests:
          - not_null
          - unique
```

---

## Key Learnings

* Built CDC pipeline from PostgreSQL to Snowflake
* Implemented layered data modeling (STG → DIM → FACT → AGG)
* Ensured data quality using validation checks
* Understood dbt and Git role in production

---

## Conclusion

This project demonstrates a production-style data pipeline with ingestion, transformation, validation, and structured modeling using Hevo and Snowflake.
