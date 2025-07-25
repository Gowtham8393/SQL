-- Create Table Statement for tbl_product
CREATE TABLE tgt.tbl_product (
    product_id INT PRIMARY KEY,
    name VARCHAR(255),
    category VARCHAR(255)
);

-- Insert Statements for tbl_product
INSERT INTO tgt.tbl_product (product_id, name, category) VALUES
(1, 'Bag', 'Education'),
(2, 'Pen', 'Education'),
(3, 'Book', 'Education'),
(4, 'Bat', 'Sports'),
(5, 'Skating', 'Sports'),
(6, 'Ball', 'Sports'),
(7, 'Chocolate', 'Food'),
(8, 'Cashew', 'Food'),
(9, 'Orange', 'Food');

-- Create Table Statement for tbl_customer
CREATE TABLE test_schema.tbl_customer (
    customer_id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Insert Statements for tbl_customer
INSERT INTO test_schema.tbl_customer (customer_id, name) VALUES
(1, 'Jikin'),
(2, 'Pariksh'),
(4, 'Chintan'),
(3, 'Hardik');

-- Create Table Statement for tbl_order
CREATE TABLE test_schema.tbl_order (
    order_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    amount INT,
    order_date DATE
);

-- Insert Statements for tbl_order
INSERT INTO test_schema.tbl_order (order_id, product_id, customer_id, amount, order_date) VALUES
(1, 1, 1, 2000, '2023-11-10'),
(2, 1, 1, 2000, '2023-11-10'),
(3, 1, 1, 2000, '2023-11-11'),
(4, 1, 1, 2000, '2023-11-12'),
(5, 1, 2, 300, '2023-11-11'),
(6, 6, 4, 100, '2023-11-12'),
(7, 6, 5, 100, '2023-11-12'),
(8, 6, 6, 100, '2023-11-12'),
(9, 6, 4, 100, '2023-11-13'),
(10, 6, 5, 100, '2023-11-13'),
(11, 6, 6, 100, '2023-11-13'),
(12, 1, 1, 2000, '2023-11-13'),
(13, 1, 1, 2000, '2023-11-13'),
(14, 7, 1, 500, '2023-11-14'),
(15, 7, 1, 500, '2023-11-15'),
(16, 7, 1, 500, '2023-11-15'),
(17, 7, 1, 500, '2023-11-16'),
(18, 7, 1, 500, '2023-11-17'),
(19, 5, 1, 2200, '2023-11-17'),
(20, 5, 1, 2200, '2023-11-19'),
(21, 5, 1, 2200, '2023-11-19'),
(22, 5, 1, 2200, '2023-11-20'),
(23, 5, 1, 2200, '2023-11-21'),
(24, 3, 4, 1100, '2023-11-21'),
(25, 3, 4, 1100, '2023-11-22'),
(26, 3, 4, 1100, '2023-11-23');

--Write a query to find all instances where sales were over 1000 for three consecutive days
SELECT order_date, amount
FROM (
    SELECT order_date, amount,
           LAG(amount, 1) OVER (ORDER BY order_date) AS previous_day,
           LAG(amount, 2) OVER (ORDER BY order_date) AS two_days_ago
    FROM tbl_order
) consecutive_sales
WHERE amount > 1000 AND previous_day > 1000 AND two_days_ago > 1000;

--Find the top-selling product by sales amount in each category
SELECT 
    category,
    product_id,
    name,
    total_sales
FROM (
    SELECT 
        p.category,
        p.product_id,
        p.name,
        SUM(o.amount) AS total_sales,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(o.amount) DESC) AS sales_rank
    FROM 
        tbl_product p
    JOIN 
        tbl_order o ON p.product_id = o.product_id
    GROUP BY 
        p.category, p.product_id, p.name
) AS ranked_sales
WHERE 
    sales_rank = 1;

--To retrieve the top two products by sales amount in each category

SELECT 
    category,
    product_id,
    name,
    total_sales
FROM (
    SELECT 
        p.category,
        p.product_id,
        p.name,
        SUM(o.amount) AS total_sales,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(o.amount) DESC) AS sales_rank
    FROM 
        tbl_product p
    JOIN 
        tbl_order o ON p.product_id = o.product_id
    GROUP BY 
        p.category, p.product_id, p.name
) AS ranked_sales
WHERE 
    sales_rank <= 2;

--Write a query to calculate the difference in the amount between consecutive orders for each customer
SELECT 
    customer_id,
    order_id,
    order_date,
    amount,
    amount - LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS amount_difference
FROM 
    tbl_order
ORDER BY 
    customer_id, order_date;

--Find the maximum, minimum, and average order amounts
SELECT 
    MAX(amount) AS max_order_amount,
    MIN(amount) AS min_order_amount,
    AVG(amount) AS avg_order_amount
FROM 
    tbl_order;

--Count the number of orders per day
SELECT 
    order_date,
    COUNT(order_id) AS orders_count
FROM 
    tbl_order
GROUP BY 
    order_date
ORDER BY 
    order_date;

--Find products that were sold more than once in a day
SELECT 
    product_id,
    order_date,
    COUNT(order_id) AS sales_count
FROM 
    tbl_order
GROUP BY 
    product_id, order_date
HAVING 
    COUNT(order_id) > 1
ORDER BY 
    order_date, sales_count DESC;  

--Write a query to calculate the day-by-day sales growth.
WITH daily_sales AS (
    SELECT 
        order_date,
        SUM(amount) AS total_sales
    FROM 
        tbl_order
    GROUP BY 
        order_date
)
SELECT 
    order_date,
    total_sales,
    LAG(total_sales) OVER (ORDER BY order_date) AS previous_day_sales,
    CASE 
        WHEN LAG(total_sales) OVER (ORDER BY order_date) IS NULL THEN NULL
        ELSE (total_sales - LAG(total_sales) OVER (ORDER BY order_date)) / LAG(total_sales) OVER (ORDER BY order_date) * 100
    END AS sales_growth_percentage
FROM 
    daily_sales
ORDER BY 
    order_date;

--Calculating the Moving Average. Scenario: You have a table stock_prices with columns date, price. Write a query to calculate. The 7-day moving average of stock prices.
SELECT date, price,
       AVG(price) OVER (ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg
FROM stock_prices;
