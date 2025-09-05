create database pizza_sales;
-- Table Rules
CREATE TABLE orders (
    order_id int PRIMARY KEY,
    date date,
    time time
);

CREATE TABLE pizza_type (
    pizza_type_id VARCHAR(50) PRIMARY KEY,
    pizza_type_name VARCHAR(100),
    pizza_type_category VARCHAR(50),
    pizza_type_ingredients TEXT
);

CREATE TABLE pizzas (
    pizza_id VARCHAR(50) PRIMARY KEY,
    pizza_type_id VARCHAR(50),
    size VARCHAR(10),
    price DECIMAL(10, 2),
    FOREIGN KEY (pizza_type_id) REFERENCES pizza_type(pizza_type_id)
);

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY,
    order_id INT,
    pizza_id VARCHAR(50),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizzas(pizza_id)
);

-- Join 4 Table and Build New Table As One
CREATE TABLE sales_data AS
SELECT
    t1.order_id,
    t1.date,
    t1.time,
    t2.quantity,
    t3.size,
    t3.price,
    t4.pizza_type_name,
    t4.pizza_type_category,
    t4.pizza_type_ingredients
FROM
    orders AS t1
JOIN
    order_details AS t2 ON t1.order_id = t2.order_id
JOIN
    pizzas AS t3 ON t2.pizza_id = t3.pizza_id
JOIN
    pizza_type AS t4 ON t3.pizza_type_id = t4.pizza_type_id;
    
-- Add Coloumn Total_Price
ALTER TABLE sales_data
ADD COLUMN total_price DECIMAL(10,2) GENERATED ALWAYS AS (price * quantity) VIRTUAL;

select*from sales_data;

-- Key Findings and Analysis

select sum(total_price) as Total_Revenue from sales_data;

select sum(total_price) / count(DISTINCT order_id) as Avg_Revenue from sales_data;

select sum(quantity) as Total_pizza_sold from sales_data;

SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM sales_data;

SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10,2)) AS DECIMAL(10,2))
AS Avg_Pizzas_per_order
FROM sales_data;

SELECT
    DAYNAME(date) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    sales_data
GROUP BY
    DAYNAME(date);

SELECT
    monthname(date) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM
    sales_data
GROUP BY
    monthname(date)
order by total_orders desc;

SELECT
    pizza_type_category,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM sales_data) AS DECIMAL(10,2)) AS percentage
FROM
    sales_data
GROUP BY
    pizza_type_category
ORDER BY
    total_revenue DESC;
    
SELECT
    size,
    CAST(SUM(total_price) AS DECIMAL(10,2)) AS total_revenue,
    CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM sales_data) AS DECIMAL(10,2)) AS percentage
FROM
    sales_data
GROUP BY
    size
ORDER BY
    total_revenue DESC;


SELECT
    pizza_type_category,                 
    SUM(quantity) AS Total_Quantity_Sold  
FROM
    sales_data                  
WHERE
    MONTH(date) = 2           
GROUP BY
    pizza_type_category
ORDER BY
    Total_Quantity_Sold DESC;       
    
SELECT 
	pizza_type_name, 
	SUM(total_price) AS Total_Revenue
FROM 
	sales_data
GROUP BY 
	pizza_type_name
ORDER BY 
	Total_Revenue DESC
limit 5;

SELECT 
	pizza_type_name, 
	SUM(total_price) AS Total_Revenue
FROM 
	sales_data
GROUP BY 
	pizza_type_name
ORDER BY 
	Total_Revenue asc
limit 5;

SELECT 
	pizza_type_name, 
	SUM(quantity) AS Total_Quantity
FROM 
	sales_data
GROUP BY 
	pizza_type_name
ORDER BY 
	Total_Quantity DESC
limit 5;

SELECT 
	pizza_type_name, 
	SUM(quantity) AS Total_Quantity
FROM 
	sales_data
GROUP BY 
	pizza_type_name
ORDER BY 
	Total_Quantity ASC
limit 5;

SELECT 
	pizza_type_name, 
	COUNT(DISTINCT order_id) AS Total_Orders
FROM 
	sales_data
GROUP BY 
	pizza_type_name
ORDER BY 
	Total_Orders desc
limit 5;

SELECT 
	pizza_type_name, 
	COUNT(DISTINCT order_id) AS Total_Orders
FROM 
	sales_data
GROUP BY 
	pizza_type_name
ORDER BY 
	Total_Orders asc
limit 5;
