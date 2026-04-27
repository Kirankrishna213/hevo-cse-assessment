-- Row count check
SELECT COUNT(*) FROM raw_customers;
SELECT COUNT(*) FROM customers;

-- Duplicate check
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Null check
SELECT *
FROM customers
WHERE customer_lifetime_value IS NULL;