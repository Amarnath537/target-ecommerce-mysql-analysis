-- to create customers table 
CREATE TABLE customers
( 
 customer_id VARCHAR(50),
 customer_unique_id VARCHAR(50),
 customer_zip_code_prefix INT,
 customer_city VARCHAR(100),
 customer_state VARCHAR(10),
 PRIMARY KEY (customer_id)
);


-- to create geolocation table
CREATE TABLE geolocation
( 
 geolocation_zip_code_prefix INT,
 geolocation_lat VARCHAR(25),
 geolocation_lng VARCHAR(25),
 geolocation_city VARCHAR(100),
 geolocation_state VARCHAR(10)
);


-- to create order items table 
CREATE TABLE order_items
(
 order_id VARCHAR(32),
 order_item_id INT,
 product_id VARCHAR(32),
 seller_id VARCHAR(32),
 shipping_limit_date DATETIME,
 price DECIMAL(10,2),
 freight_value DECIMAL(10,2),
 PRIMARY KEY (order_id, order_item_id)
);


-- to create order reviews table
CREATE TABLE order_reviews
(
 review_id VARCHAR(50),
 order_id VARCHAR(50),
 review_score VARCHAR(2),
 review_comment_title VARCHAR(250),
 review_creation_date DATETIME,
 review_answer_timestamp DATETIME,
 PRIMARY KEY (review_id, order_id)
);


-- to create orders table
CREATE TABLE orders
(
 order_id VARCHAR(50),
 customer_id VARCHAR(50),
 order_status VARCHAR(25),
 order_purchase_timestamp DATETIME,
 order_approved_at DATETIME,
 order_delivered_carrier_date DATETIME,
 order_delivered_customer_date DATETIME,
 order_estimated_delivery_date DATETIME,
 PRIMARY KEY (order_id, customer_id)
);


-- create table payments
CREATE TABLE payments
(
 order_id VARCHAR(50),
 payment_sequential VARCHAR(15),
 payment_type VARCHAR(25),
 payment_installments INT,
 payment_value DECIMAL(10,2)
);


-- to create table products
CREATE TABLE products
(
 product_id VARCHAR(50),
 product_category VARCHAR(50),
 product_name_length INT,
 product_description_length INT,
 product_photos_qty INT,
 product_weight_g INT,
 product_length_cm INT,
 product_height_cm INT,
 product_width_cm INT,
 PRIMARY KEY (product_id)
);


-- to create sellers table
CREATE TABLE sellers
(
 seller_id VARCHAR(50),
 seller_zip_code_prefix INT,
 seller_city VARCHAR(100),
 seller_state VARCHAR(10),
 PRIMARY KEY (seller_id)
);
