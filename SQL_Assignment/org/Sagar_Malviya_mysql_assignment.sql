/*
			Sagar Malviya
*/


/* 
-- Task 1: Understanding the data in hand
-- ------------------- ------------------------ ---------------------- ---------------------
A. Data description in my own words.

There are 5 tables used to store various details related to Orders placed in the system.
Primary table is the market_fact table, it is the fact table and other tables are all dimension tables, orders_dimen, prod_dimen, cust_dimen and shipping_dimen as they further describe the fields in market_fact.
Table orders_dimen contain order details such as order_priority (Critical, High, Low, Medium & Not specified) and Order date.
Table prod_dimen contain details about the products sold i.e. category and sub-category.
Table cust_dimen contains details such as Name of the customer, his/her location and segment.
Table shipping_dimen contains shipping information of the orders, namely date of shipment and Shipping mode( DELIVERY TRUCK, EXPRESS AIR, REGULAR AIR).

Combining these 5 tables we can fetch basic Order details such as:
When was the order placed?
When was the order shipped?
How was the order shipped?
What is the priority of the order?

Who is the Customer?
Where is the customer from?
What segment does the customer belong to?
What Category and Sub-category does the ordered item lie in?

How much was the sale of the order?
How much discount was give for the product?
What was the quantity of products ordered?
How much profit was booked on the ordered item?
How much are we spending on shipping?
What is the margin we are commanding on the various products?

In addition to these basic questions, we can also fetch aggregated details such as, 
How many orders have we received in the previous one year?
What is our best selling product?
Which product is our most profitable product?
Who is our best customer?
Which is our best customer segment?
How much are we spending on shipping?
How much revenue is generated from customers in xyz region?
Which is our best region for business?
Which is our best Category & sub-category?
When do we get the most critical orders?

And much much more questions.
 
-- ------------------------ ---------------------------- ---------------------------- 
B. Identify and list the Primary Keys and Foreign Keys for this dataset

Table market_fact: 
Primary key : 
Foreign Key : 
ord_id references orders_dimen.ord_id
prod_id references prod_dimen.prod_id
ship_id references shipping_dimen.ship_id
cust_id references cust_dimen.cust_id

Table shipping_dimen:
Primary key : ship_id
Foreign key : 
order_id references order_dimen.order_id

Table prod_dimen:
Primary key : prod_id

Table cust_dimen:
Primary key : cust_id

Table orders_dimen:
Primary key : ord_id

*/
-- ------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------------------------

-- Task 2: Basic Analysis
-- --------------- ------------------- --------------------- ------------------- ------------------
-- A. Total and the average sales
SELECT SUM(sales) total_sales, AVG(sales) avg_sales
  FROM superstoresdb.market_fact;

-- B. Number of customers in each region in decreasing order of no_of_customers. 
SELECT region, COUNT(cust_id) no_of_customers
  FROM superstoresdb.cust_dimen 
 GROUP BY region 
 ORDER BY count(cust_id) DESC;
 
-- C. The region having maximum customers
SELECT region, COUNT(cust_id) max_customer_count
  FROM superstoresdb.cust_dimen 
 GROUP BY region 
 ORDER BY count(cust_id) DESC
 LIMIT 1;
 
-- D. Number and id of products sold in decreasing order of products sold 
SELECT prod_id product_id, SUM(order_quantity) no_of_product_sold 
  FROM superstoresdb.market_fact 
 GROUP BY prod_id 
 ORDER BY no_of_product_sold DESC;
 
-- E. All the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased
SELECT cd.Customer_Name customer_name, SUM(mkf.Order_Quantity) no_of_tables_purchased
  FROM superstoresdb.market_fact mkf 
  JOIN superstoresdb.cust_dimen cd ON mkf.Cust_id = cd.Cust_id 
  JOIN superstoresdb.prod_dimen pd ON pd.Prod_id = mkf.Prod_id
WHERE region = 'ATLANTIC'
  AND pd.Product_Sub_Category = 'TABLES'
GROUP BY customer_name;

-- ----------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------

-- Task 3: Advanced Analysis
-- --------------------- ----------------------- ----------------------- ------------
-- A. Product categories in descending order of profits
SELECT product_category, SUM(profit) profits
  FROM superstoresdb.market_fact mkf
  JOIN superstoresdb.prod_dimen pd
    ON pd.Prod_id = mkf.Prod_id
GROUP BY product_category 
ORDER BY profits DESC;

-- B. Product category, product sub-category and the profit within each subcategory. 
SELECT product_category, Product_Sub_Category, SUM(profit) profits
  FROM superstoresdb.market_fact mkf
  JOIN superstoresdb.prod_dimen pd
    ON pd.Prod_id = mkf.Prod_id
 GROUP BY product_category, Product_Sub_Category;
 
-- Where is the least profitable product subcategory shipped the most? 

SELECT region, COUNT(mkf.ship_id) no_of_shipments, SUM(profit) profit_in_each_region
  FROM superstoresdb.market_fact mkf 
  JOIN superstoresdb.shipping_dimen sd 
    ON sd.Ship_id = mkf.Ship_id
  JOIN superstoresdb.cust_dimen cd 
    ON mkf.Cust_id = cd.Cust_id
 WHERE prod_id = (SELECT prod_id 
                    FROM superstoresdb.prod_dimen 
				   WHERE Product_Sub_Category = 'TABLES')
 GROUP BY region
 ORDER BY profit_in_each_region DESC;