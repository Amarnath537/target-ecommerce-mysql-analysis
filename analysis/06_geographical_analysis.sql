##Evolution of E-commerce orders in the Brazil region:
-- 1. Get the month on month no. of orders placed in each state.
SELECT 
c.customer_state as state,
YEAR(o.order_purchase_timestamp) AS year,
MONTH(o.order_purchase_timestamp) AS month,
COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY 1,2,3
ORDER BY 1,2,3
;

-- 2. How are the customers distributed across all the states?
SELECT 
customer_state,
COUNT(DISTINCT customer_unique_id) AS total_customers_statewise,
ROUND((COUNT(DISTINCT customer_unique_id)/(SELECT COUNT(DISTINCT customer_unique_id) FROM customers) * 100),2) AS per_total_customers
FROM customers
GROUP BY 1
ORDER BY 2 DESC
;