-- M4.S4. Graded Assignment exercise
-- 
-- Task 0 is complete, data exported as tables into superstores_db
-- 
-- Task 1: A. Describe the data in hand in your own words.
-- Task 1: B. Identify and list the Primary Keys and Foreign Keys for this dataset
-- 
-- Ans:
-- 
-- The schema is called superstore_db, which has 5 tables. The five tables mentioned are namely cust_dimen, market_fact, orders_dimen, prod_dimen and shipping_dimen.
-- I will talk about each table (describe), the fields in data, number of data points and primary/foreign keys. 
-- 
-- 1.cust_dimen: This table has 5 columns, namely customer_name (text), province(text), 
-- region(text), customer_segment(text) and cust_id(text). The columns contain values 
-- pertaining to the name of the customer, his geographical location, customer segment 
-- and the uniquely identifiable customer id. The table has 1832 records. 

-- The primary key for the table is cust_id and the foreign key is customer_segment.
-- 
-- 2.	market_fact: The table has 10 columns, namely ord_id(text), prod_id(text), 
-- ship_id(text), cust_id(text), sales(double), discount(double), order_quantity(int(11)),
-- profit(double), shipping_cost(double), product_base_margin(double). The columns contain
-- values pertaining to each specific order, the product sold, shipment details, customer details,
-- sales, discount offered, quantity ordered, profits, shipping cost and product base margin. 
-- The table has 8336 records.
-- 
-- The foreign keys are cust_id, ord_id, ship_id, prod_id.
-- 
-- 3. orders_dimen: The table has 4 columns, namely order_id(int(11)), order_date(text), 
-- order_priority(text), ord_id(text). The table contains details about all the orders. 
-- The table has 5506 records.
-- 
-- The primary key is ord_id and the foreign key is order_id.
-- 
-- 4. prod_dimen: The table has 3 columns, namely product_category(text), 
-- product_sub_category(text) and prod_id(text). The table contains details about all the 
-- products available in the superstore. The table has only 17 records.
-- 
-- The primary key is prod_id.
-- 
-- 5. shipping_dimen: The table has 4 columns, order_id(int(11)), ship_mode(text), 
-- ship_date(text), ship_id(text). The file has shipping details for all orders. The table 
-- has 7701 records.
-- 
-- The primary key is ship_id and foreign key is order_id.
-- 
-- Task2: Basic Analysis
-- A. Find the total and the average sales (display total_sales and avg_sales)



SELECT 
    SUM(sales) AS 'Total Sales', AVG(sales) AS 'Average Sales'
FROM
    market_fact;




--
-- B. Display the number of customers in each region in decreasing order of
--    no_of_customers. The result should be a table with columns Region,
--    no_of_customers
SELECT 
    region AS 'Region', COUNT(Cust_id) AS 'No_of_Customers'
FROM
    cust_dimen
GROUP BY region
ORDER BY COUNT(cust_id) DESC;




--
-- C. Find the region having maximum customers (display the region name and
-- max(no_of_customers)
SELECT 
    y.region AS 'Region',
    MAX(y.number) AS 'max(no_of_customers)'
FROM
    (SELECT 
        region, COUNT(cust_id) AS number
    FROM
        cust_dimen x
    GROUP BY region
    ORDER BY COUNT(cust_id) DESC) y;




--
-- D. Find the number and id of products sold in decreasing order of products sold (display
-- product id, no_of_products sold)
SELECT 
    prod_id AS 'Product id',
    SUM(Order_Quantity) AS 'no_of_products_sold'
FROM
    market_fact
GROUP BY Prod_id
ORDER BY SUM(Order_Quantity) DESC;




--
-- E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and
-- the number of tables purchased (display the customer name, no_of_tables
-- purchased)
-- 
SELECT 
    cd.customer_name AS 'Customer Name',
    SUM(Order_Quantity) AS 'No_of_Tables_Purchased'
FROM
    cust_dimen cd
        INNER JOIN
    market_fact mf ON cd.cust_id = mf.cust_id
WHERE
    mf.prod_id = 'Prod_11'
        AND cd.region = 'Atlantic'
GROUP BY cd.Customer_Name
ORDER BY cd.Customer_name ASC;



--
-- Task3: Advanced Analysis
-- A. Display the product categories in descending order of profits (display the product
-- category wise profits i.e. product_category, profits)?
SELECT 
    pd.product_category AS 'Product Category',
    SUM(profit) AS 'Profits'
FROM
    prod_dimen pd
        INNER JOIN
    market_fact mf ON pd.Prod_id = mf.Prod_id
GROUP BY pd.Product_Category
ORDER BY SUM(profit) DESC;




--
-- B. Display the product category, product sub-category and the profit within each 
--    subcategory in three columns.
SELECT 
    pd.product_category AS 'Product Category',
    pd.Product_Sub_Category AS 'Product Sub-Category',
    SUM(profit) AS 'Profits'
FROM
    prod_dimen pd
        INNER JOIN
    market_fact mf ON pd.Prod_id = mf.Prod_id
GROUP BY pd.Product_Category , pd.Product_Sub_Category;
# ORDER BY Profits DESC;




-- 
-- C. Where is the least profitable product subcategory shipped the most? For the least
--    profitable product sub-category, display the region-wise no_of_shipments and the
--    profit made in each region in decreasing order of profits (i.e. region,
--    no_of_shipments, profit_in_each_region)
--    Note: You can hardcode the name of the least profitable product subcategory
SELECT 
    cd.region AS 'Region',
    COUNT(ship_id) AS 'No of shipments',
    SUM(profit) AS 'Profits'
FROM
    cust_dimen cd
        INNER JOIN
    market_fact mf ON cd.Cust_id = mf.Cust_id
WHERE
    mf.prod_id = 'Prod_11'
GROUP BY cd.region
ORDER BY SUM(profit) DESC;