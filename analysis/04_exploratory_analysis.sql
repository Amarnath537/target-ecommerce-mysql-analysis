##Import the dataset and do usual exploratory analysis steps like checking the structure & characteristics of the dataset:

-- 1. Data type of all columns in the "customers" table.
DESC customers;

-- 2. Get the time range between which the orders were placed.
SELECT 
MIN(order_purchase_timestamp) AS start_purchase_time,
MAX(order_purchase_timestamp) AS end_purchase_time
FROM orders
;


-- 3. Count the Cities & States of customers who ordered during the given period
-- (From jan 2018 to jun 2018).
SELECT
COUNT(DISTINCT c.customer_city) AS total_cities,
COUNT(DISTINCT c.customer_state) AS total_states
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_purchase_timestamp >= '2018-01-01 00:00:00'
AND o.order_purchase_timestamp < '2018-07-01 00:00:00'
;