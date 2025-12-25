##6. Analysis based on the payments:
-- 1. Find the month on month no. of orders placed using different payment types.
SELECT
DATE_FORMAT(o.order_purchase_timestamp,'%Y-%m')  AS year_month_ym,
payment_type,
COUNT(DISTINCT o.order_id) AS total_orders
FROM payments p
JOIN orders o
ON o.order_id = p.order_id
GROUP BY 1,2
ORDER BY 1 DESC,2 ASC
;

-- 2. Find the no. of orders placed on the basis of the payment installments that have been paid.
SELECT 
payment_installments,
COUNT(DISTINCT order_id) AS num_orders_placed
FROM payments
WHERE payment_installments IS NOT NULL -- to exclude null values
AND payment_installments > 0           -- this filter excludes incorrect 0 installments if exist in the table
GROUP BY 1
ORDER BY 1 ASC
;
