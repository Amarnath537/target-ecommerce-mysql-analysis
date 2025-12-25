##Impact on Economy: Analyze the money movement by e-commerce by looking at order prices, freight and others.
-- 1. Get the % increase in the cost of orders from year 2017 to 2018(include months between Jan to Aug only).
-- You can use the "payment_value" column in the payments table to get the cost of orders.
WITH CTE AS(
	SELECT 
	YEAR(o.order_purchase_timestamp) AS year_yr,
	MONTH(o.order_purchase_timestamp) AS month_mn,
	SUM(p.payment_value) AS monthly_total
	FROM orders o
	JOIN payments p
	ON p.order_id = o.order_id
	WHERE YEAR(o.order_purchase_timestamp) IN (2017, 2018)
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
	GROUP BY 1,2
),
CTE2 AS (
	SELECT 
	year_yr,
	month_mn,
	monthly_total,
	LAG(monthly_total) OVER(PARTITION BY month_mn ORDER BY year_yr) AS prev_year_monthly_total
	FROM CTE
)
SELECT
year_yr,
month_mn,
monthly_total,
ROUND(((monthly_total - prev_year_monthly_total)/prev_year_monthly_total)*100,2) AS per_change
FROM CTE2
ORDER BY 2,1
;

-- 2. Calculate the Total & Average value of order price for each state.
SELECT
c.customer_state,
SUM(p.payment_value) AS total_orderprice_statewise,
ROUND(SUM(payment_value)/COUNT(DISTINCT p.order_id),2) AS average_orderprice_statewise
FROM customers c
JOIN orders o
ON o.customer_id = c.customer_id
JOIN payments p
ON p.order_id = o.order_id
GROUP BY 1
ORDER BY 3 DESC
;

-- 3. Calculate the Total & Average value of order freight for each state.
SELECT 
c.customer_state AS state,
ROUND(SUM(oi.freight_value),2) AS satewise_total_fr_value,
ROUND(SUM(freight_value)/COUNT(DISTINCT o.order_id),2) AS statewise_avg_freight_value
FROM order_items oi
JOIN orders o
ON o.order_id = oi.order_id
JOIN customers c
ON c.customer_id = o.customer_id
GROUP BY 1
ORDER BY 3 DESC
;