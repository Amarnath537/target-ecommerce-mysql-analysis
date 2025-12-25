##In-depth Exploration:
-- 1. Is there a growing trend in the no. of orders placed over the past years?
SELECT 
YEAR(order_purchase_timestamp) AS year_month_wise,
MONTH(order_purchase_timestamp) AS month_month_wise,
COUNT(order_id) AS num_orders
FROM orders
GROUP BY 1,2
ORDER BY 2,1 DESC
;

-- 2. Can we see some kind of monthly seasonality in terms of the no. of orders being placed?
SELECT 
MONTH(order_purchase_timestamp) AS month_month_wise,
COUNT(order_id) AS num_orders
FROM orders
GROUP BY 1
ORDER BY 2 DESC
;

-- 3. During what time of the day, do the Brazilian customers mostly place their orders? (Dawn, Morning, Afternoon or Night)
-- 0-6 hrs : Dawn
-- 7-12 hrs : Mornings
-- 13-18 hrs : Afternoon
-- 19-23 hrs : Night
WITH CTE AS
(
  SELECT CASE WHEN HOUR(order_purchase_timestamp) BETWEEN  0 AND  6 THEN 'Dawn'
			  WHEN HOUR(order_purchase_timestamp) BETWEEN  7 AND 12 THEN 'Morning'
			  WHEN HOUR(order_purchase_timestamp) BETWEEN 13 AND 18 THEN 'Afternoon'
			  WHEN HOUR(order_purchase_timestamp) BETWEEN 19 AND 23 THEN 'Night'
			  END AS time_of_purchase
FROM orders
)
SELECT 
time_of_purchase,
COUNT(*) AS count_of_time_of_purchase
FROM CTE
GROUP BY time_of_purchase
ORDER BY 2 DESC
;
