-- to load data file into created customers file 
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','            -- Each column (field) in a row is separated by a comma.
ENCLOSED BY '"'                     -- Fields may be wrapped in double quotes, especially useful when: commas, line breaks, spaces
LINES TERMINATED BY '\n'            -- Each row ends with a newline character.
IGNORE 1 ROWS                       -- ignores 1st row header of the file
;


-- to load data file into geolocation table
LOAD DATA INFILE 
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/geolocation.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;


-- load csv datafile into created table
/* order_items table has a date + time value column. 
When loading non-ISO date formats via LOAD DATA INFILE, 
MySQL requires user variables and STR_TO_DATE for proper DATETIME conversion.
*/
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(                        -- MySQL reads the CSV left-to-right, and it must know where each CSV value goes.
 order_id,               -- If you don’t mention the other columns, MySQL can’t align the data correctly.
 order_item_id,
 product_id,
 seller_id,
 @shipping_limit_date, -- Temporary variable. need to use @
 price,
 freight_value
)
SET shipping_limit_date = STR_TO_DATE(@shipping_limit_date,'%d/%m/%Y %H:%i:%s') -- to convert str to date and time format. To correctly populate DATETIME columns
;


-- load data file into created order_reviews file 
/* order_items table has a date + time value column. 
When loading non-ISO date formats via LOAD DATA INFILE, 
MySQL requires user variables and STR_TO_DATE for proper DATETIME conversion.
*/

LOAD DATA INFILE 
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_reviews.csv'  -- single \ is used to escape in sql.
INTO TABLE order_reviews
CHARACTER SET latin1           -- CRITICAL FIX
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(                              -- MySQL reads the CSV left-to-right, and it must know where each CSV value goes.
 review_id,                    -- If you don’t mention the other columns, MySQL can’t align the data correctly.
 order_id,
 review_score,
 @skip_review_comment_title,   -- this column has currupted values, we won't be uploading
 @review_creation_date,        -- Temporary variable. need to use @
 @review_answer_timestamp      -- Temporary variable. need to use @
)
SET
review_creation_date    = STR_TO_DATE(@review_creation_date,'%d/%m/%Y %H:%i:%s'),          -- to convert str to date and time format. To correctly populate DATETIME columns
review_answer_timestamp = STR_TO_DATE(@review_answer_timestamp,'%d/%m/%Y %H:%i:%s')    -- to convert str to date and time format. To correctly populate DATETIME columns
;


-- load data file into created orders file 
/* orders table has a date + time value column. 
When loading non-ISO date formats via LOAD DATA INFILE, 
MySQL requires user variables and STR_TO_DATE for proper DATETIME conversion.
*/

LOAD DATA INFILE 
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders (1).csv'  -- single \ is used to escape in sql.
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(                              -- MySQL reads the CSV left-to-right, and it must know where each CSV value goes.
                               -- If you don’t mention the other columns, MySQL can’t align the data correctly.
 order_id,
 customer_id,
 order_status,
 @order_purchase_timestamp,
 @order_approved_at,
 @order_delivered_carrier_date,
 @order_delivered_customer_date,
 @order_estimated_delivery_date 
)
SET                                         -- to convert str to date and time format. We have date in two format. To correctly populate DATETIME columns
order_purchase_timestamp      = CASE WHEN @order_purchase_timestamp      LIKE '%/%' THEN STR_TO_DATE(@order_purchase_timestamp,'%d/%m/%Y %H:%i:%s')
									 WHEN @order_purchase_timestamp      LIKE '%-%' THEN STR_TO_DATE(@order_purchase_timestamp,'%Y-%m-%d %H:%i:%s')
                                     ELSE NULL END,          
order_approved_at             = CASE WHEN @order_approved_at             LIKE '%/%' THEN STR_TO_DATE(@order_approved_at,'%d/%m/%Y %H:%i:%s')
									 WHEN @order_approved_at             LIKE '%-%' THEN STR_TO_DATE(@order_approved_at,'%Y-%m-%d %H:%i:%s')
                                     ELSE NULL END,
order_delivered_carrier_date  = CASE WHEN @order_delivered_carrier_date  LIKE '%/%' THEN STR_TO_DATE(@order_delivered_carrier_date,'%d/%m/%Y %H:%i:%s')
									 WHEN @order_delivered_carrier_date  LIKE '%-%' THEN STR_TO_DATE(@order_delivered_carrier_date,'%Y-%m-%d %H:%i:%s')
                                     ELSE NULL END,
order_delivered_customer_date = CASE WHEN @order_delivered_customer_date LIKE '%/%' THEN STR_TO_DATE(@order_delivered_customer_date,'%d/%m/%Y %H:%i:%s')
									 WHEN @order_delivered_customer_date LIKE '%-%' THEN STR_TO_DATE(@order_delivered_customer_date,'%Y-%m-%d %H:%i:%s')
                                     ELSE NULL END, 
order_estimated_delivery_date = CASE WHEN @order_estimated_delivery_date LIKE '%/%' THEN STR_TO_DATE(@order_estimated_delivery_date,'%d/%m/%Y %H:%i:%s')
									 WHEN @order_estimated_delivery_date LIKE '%-%' THEN STR_TO_DATE(@order_estimated_delivery_date,'%Y-%m-%d %H:%i:%s')
                                     ELSE NULL END									
;


-- load data into payments table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payments.csv'
INTO TABLE payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;


-- to load data into products table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS
(
 product_id,
 product_category,
 @product_name_length,
 @product_description_length,
 @product_photos_qty,
 @product_weight_g,
 @product_length_cm,
 @product_height_cm,
 @product_width_cm
)
SET
product_name_length       = NULLIF(TRIM(@product_name_length),''),         -- To avoid NULL using NULLIF and extra space unsing TRIM
product_description_length= NULLIF(TRIM(@product_description_length),''),
product_photos_qty        = NULLIF(TRIM(@product_photos_qty),''),
product_weight_g          = NULLIF(TRIM(@product_weight_g),''),
product_length_cm         = NULLIF(TRIM(@product_length_cm),''),
product_height_cm         = NULLIF(TRIM(@product_height_cm),''),
product_width_cm          = CASE WHEN TRIM(@product_width_cm) REGEXP '^[0-9]+$' THEN @product_width_cm -- this column has empty/currupted values, hence using CASE statement
                            ELSE NULL
							END
;


-- to load data into sellers table
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sellers.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','            -- Each column (field) in a row is separated by a comma.
ENCLOSED BY '"'                     -- Fields may be wrapped in double quotes, especially useful when: commas, line breaks, spaces
LINES TERMINATED BY '\n'            -- Each row ends with a newline character.
IGNORE 1 ROWS                       -- ignores 1st row header of the file
;