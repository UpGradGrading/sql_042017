/*
	Sandip Gosh
*/

Task 1: Understanding the data in hand 
A. Describe the data in hand in your own words. (Word Limit is 500)

Answer: 
There are four dimension tables (cust_dimen, order_dimen, prod_dimen, shipping_dimen) and one fact table (market_fact). All the dimension tables have one primary key and it is their respective IDs (for example cust_dimen has primary key cust_id, order_dimen has primary key ord_id, prod_dimen has primary key prod_id and shipping_dimen has primary key ship_id). These dimension tables also have additional attributes. These Primary Keys are used as foreign key in market_fact which work as referential constraint. Also market_fact table has a composite primary key.


B. Identify and list the Primary Keys and Foreign Keys for this dataset.

Answer: 
1.cust_dimen table has primary key cust_id
2.order_dimen table has primary key ord_id
3.prod_dimen table has primary key prod_id
4.shipping_dimen table has primary key ship_id
5. market_fact table has a composite primary key comprising of four fields(ord_id, prod_id, ship_id, cust_id, Order_Quantity)
6. market_fact table has  four foreign keys ord_id, prod_id, ship_id, cust_id refencing to order_dimen, prod_dimen, shipping_dimen, cust_dimen tables respectively.

Task 2: Basic Analysis 
Write the SQL queries for the following:  
A. Find the total and the average sales (display total_sales and avg_sales) 

SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS average_sales
FROM
    market_fact;





/*B. Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region, no_of_customers */

SELECT 
    region AS region, COUNT(*) AS no_of_customers
FROM
    cust_dimen
GROUP BY region
ORDER BY no_of_customers DESC;





/*C. Find the region having maximum customers (display the region name and max(no_of_customers) */

SELECT 
    region AS region_name, COUNT(cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY region
HAVING COUNT(cust_id) = (SELECT 
        MAX(mycount)
    FROM
        (SELECT 
            COUNT(cust_id) AS mycount
        FROM
            cust_dimen
        GROUP BY region) mytable);





/*D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)*/ 

SELECT 
    prod_id AS product_id,
    SUM(order_quantity) AS no_of_products_sold
FROM
    market_fact
GROUP BY product_id
ORDER BY no_of_products_sold DESC;





/*E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)*/  

SELECT 
    cust.customer_name AS customer_name,
    SUM(fact.order_quantity) AS no_of_tables_purchased
FROM
    market_fact fact
        INNER JOIN
    cust_dimen cust ON cust.cust_id = fact.cust_id
        INNER JOIN
    prod_dimen prod ON prod.prod_id = fact.prod_id
WHERE
    cust.region = 'atlantic'
        AND prod.product_sub_category = 'tables'
GROUP BY customer_name;





/*Task 3: Advanced Analysis 
Write sql queries for the following:

A. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)? */

SELECT 
    prod.product_category AS product_category,
    SUM(fact.profit) AS profits
FROM
    market_fact fact
        INNER JOIN
    prod_dimen prod ON prod.prod_id = fact.prod_id
GROUP BY product_category
ORDER BY profits DESC;





/*B. Display the product category, product sub-category and the profit within each subcategory in three columns.*/

SELECT 
    prod.product_category AS product_category,
    prod.product_sub_category AS product_sub_category,
    SUM(fact.profit) AS profits
FROM
    market_fact fact
        INNER JOIN
    prod_dimen prod ON prod.prod_id = fact.prod_id
GROUP BY product_category , product_sub_category
ORDER BY product_category , profits DESC , product_sub_category;





/*C. Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the  region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region) 
o Note: You can hardcode the name of the least profitable product subcategory */

SELECT 
    cust.region AS region,
    COUNT(DISTINCT fact.ship_id) AS no_of_shipments,
    SUM(fact.profit) AS profit_in_each_region
FROM
    market_fact fact
        INNER JOIN
    cust_dimen cust ON cust.cust_id = fact.cust_id
        INNER JOIN
    prod_dimen prod ON prod.prod_id = fact.prod_id
WHERE
    prod.product_sub_category = 'tables'
GROUP BY region
ORDER BY profit_in_each_region DESC;


