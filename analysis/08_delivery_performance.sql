##5. Analysis based on sales, freight and delivery time.
-- 1. Find the no. of days taken to deliver each order from the order’s purchase date as delivery time.
-- Also, calculate the difference (in days) between the estimated & actual delivery date of an order,(and mention delivery status if it's early, ontime or late).
-- Do this in a single query. 
-- You can calculate the delivery time and the difference between the estimated & actual delivery date using the given formula:
-- ■ time_to_deliver = order_delivered_customer_date - order_purchase_timestamp
-- ■ diff_estimated_delivery = order_delivered_customer_date - order_estimated_delivery_date
SELECT 
order_id,
DATEDIFF(order_delivered_customer_date,order_purchase_timestamp) AS time_to_deliver,
DATEDIFF(order_delivered_customer_date,order_estimated_delivery_date) AS diff_estimated_delivery,
CASE WHEN DATEDIFF(order_delivered_customer_date,order_estimated_delivery_date) < 0 THEN 'Early'
     WHEN DATEDIFF(order_delivered_customer_date,order_estimated_delivery_date) = 0 THEN 'On time'
	 ELSE 'Late'
     END AS delivery_status
FROM orders
WHERE order_delivered_customer_date IS NOT NULL        -- Filter out items which are not delivered/canceled/null 
;

-- 2. Find out the top 5 states with the highest & lowest average freight value.
WITH CTE AS (
	SELECT 
	c.customer_state AS state,
	SUM(oi.freight_value) AS total_freight_statewise,
    ROUND(SUM(oi.freight_value)/COUNT(DISTINCT o.order_id),2) AS avg_fr_value_statewise,
    DENSE_RANK() OVER(ORDER BY (SUM(oi.freight_value)/COUNT(DISTINCT o.order_id)) DESC) AS high_rnk,
    DENSE_RANK() OVER(ORDER BY (SUM(oi.freight_value)/COUNT(DISTINCT o.order_id)) ASC) AS low_rnk
	FROM order_items oi
	JOIN orders o
	ON o.order_id = oi.order_id
	JOIN customers c
	ON c.customer_id = o.customer_id
	GROUP BY 1
)
(
	SELECT
	state,
	avg_fr_value_statewise,
	'Top 5 avg_fr_value' AS category
	FROM CTE 
    WHERE high_rnk < 6
)
UNION ALL
(
	SELECT
	state,
	avg_fr_value_statewise,
	'Bottom 5 avg_fr_value' AS category
	FROM CTE 
    WHERE low_rnk < 6
)
;

-- 3. Find out the top 5 states with the highest & lowest average delivery time.
WITH CTE AS (
	SELECT  
	c.customer_state AS state,
	ROUND(SUM(TIMESTAMPDIFF(DAY, order_purchase_timestamp,o.order_delivered_customer_date))/COUNT(DISTINCT o.order_id),2) AS  avg_delivery_time,
	DENSE_RANK() OVER(ORDER BY SUM(TIMESTAMPDIFF(DAY, order_purchase_timestamp,o.order_delivered_customer_date))/COUNT(DISTINCT o.order_id) DESC) AS high_avg_delivery_time,
	DENSE_RANK() OVER(ORDER BY SUM(TIMESTAMPDIFF(DAY, order_purchase_timestamp,o.order_delivered_customer_date))/COUNT(DISTINCT o.order_id)  ASC) AS low_avg_delivery_time
	FROM orders o
	JOIN customers c
	ON c.customer_id = o.customer_id
	WHERE o.order_delivered_customer_date IS NOT NULL     -- Filter out items which are not delivered/canceled/null 
	GROUP BY 1
)
(
	SELECT 
	state,
	avg_delivery_time,
	'low avg delivery time' AS delivery_time_category
	FROM CTE
	WHERE low_avg_delivery_time <= 5
)
UNION ALL
(
	SELECT
	state,
	avg_delivery_time,
	'high avg delivery time' AS delivery_time_category
	FROM CTE
	WHERE high_avg_delivery_time <= 5
)
;

-- 4. Find out the top 5 states where the order delivery is really fast as compared to the estimated date of delivery.
-- You can use the difference between the averages of actual & estimated delivery date to figure out how fast the delivery was for each state.
WITH CTE AS (
	SELECT 
	c.customer_state AS state,
	ROUND(SUM(TIMESTAMPDIFF(DAY,o.order_purchase_timestamp,o.order_estimated_delivery_date))/COUNT(DISTINCT o.order_id),2) AS avg_est_delivery_days,
	ROUND(SUM(TIMESTAMPDIFF(DAY,o.order_purchase_timestamp,o.order_delivered_customer_date))/COUNT(DISTINCT o.order_id),2) AS avg_order_delivery_days,
	DENSE_RANK() OVER(ORDER BY SUM(TIMESTAMPDIFF(DAY,o.order_purchase_timestamp,o.order_delivered_customer_date))/COUNT(DISTINCT o.order_id) ASC) AS rnk
	FROM orders o
	JOIN customers c
	ON c.customer_id = o.customer_id
    WHERE order_delivered_customer_date IS NOT NULL          -- Filter out items which are not delivered/canceled/null 
	GROUP BY 1
)
SELECT
state,
avg_est_delivery_days,
avg_order_delivery_days
FROM CTE
WHERE rnk <= 5
;
