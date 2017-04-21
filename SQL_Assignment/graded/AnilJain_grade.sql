/*
		Anil Jain
*/

/**CREATE SCHEMA `superstoresdb` ;**/
use superstoresdb;

/**  Task 1: Understanding the data in hand  **/
/**	---------------------------------------  **/
/**  Unserstanding the data **/
/**	 The data in the csv files are from the superstores sales data **/
/**  The data used contains information about the customers, orders placed by them, the products, shipping details etc.**/
/**  There are five files respectivly: cust_dimen.csv, orders_dimen.csv, prod_dimen.csv, shipping_dimen.csv and market_fact.csv **/
/**  The above files are categorized into two categories: Dimensions and Measures **/
/**  	--> Dimensions files are: cust_dimen.csv, orders_dimen.csv, prod_dimen.csv **/
/**		--> Measure file is only one: shipping_dimen.csv **/
/**	 Using mysql workbench load all the above csv files **/
/**		--> When we load the csv files, we observe that all the text fields are imported as  text data type **/
/**		--> primary key or foriegn key can not created on text data type as the length is not fixed **/
/**		--> All those field on which primary key and foreign keys need to be created are converted to VARCHAR datatype of fixed length**/
/**		--> This is accomplished by Step 1 of Task 1**/
/** Identify Primary Key **/
/**		--> Primary keys are created for on unique identifiers on Dimensions tables **/
/** 	--> Primary keys are created on fields (Cust_id, Ord_id, Prod_id, Ship_id) of tables  cust_dimen, orders_dimen, prod_dimen, shipping_dimen **/
/** 	--> This is accomplished by Step 2 of Task 1**/
/** Idenify Foriegn Key **/
/**		--> Here Foreign Keys are identified for the fields Cust_id, Ord_id, Prod_id, Ship_id in table of table market_fact**/
/** 	--> This is accomplished by Step 3 of Task 1**/


/** Step 1: First change the text data type to varchar of column on which PK has to be created **/

ALTER TABLE prod_dimen modify Prod_id varchar(255);
ALTER TABLE orders_dimen modify Ord_id varchar(255);
ALTER TABLE shipping_dimen modify Ship_id varchar(255);
ALTER TABLE shipping_dimen modify Ship_Date varchar(20);
ALTER TABLE cust_dimen modify Cust_id varchar(255);
ALTER TABLE market_fact modify  Ord_id varchar(255);
ALTER TABLE market_fact modify  Prod_id varchar(255);
ALTER TABLE market_fact modify  Ship_id varchar(255);
ALTER TABLE market_fact modify  Cust_id varchar(255);

/** Step 2: PRIMARY KEY for the tables **/

ALTER TABLE cust_dimen ADD PRIMARY KEY (Cust_id);
ALTER TABLE orders_dimen ADD PRIMARY KEY (Ord_id);
ALTER TABLE prod_dimen ADD PRIMARY KEY (Prod_id);
ALTER TABLE shipping_dimen ADD PRIMARY KEY (Ship_id);

/** Step 3: Add Foriegn key **/
ALTER TABLE market_fact ADD FOREIGN KEY (Ord_id) REFERENCES orders_dimen(Ord_id);
ALTER TABLE market_fact ADD FOREIGN KEY (Prod_id) REFERENCES prod_dimen(Prod_id);
ALTER TABLE market_fact ADD FOREIGN KEY (Ship_id) REFERENCES shipping_dimen(Ship_id);
ALTER TABLE market_fact ADD FOREIGN KEY (Cust_id) REFERENCES cust_dimen(Cust_id);






/** Task 2: Basic Analysis **/
SELECT 
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(AVG(sales), 2) AS avg_sales
FROM
    market_fact;






/** B. Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region,
 **    no_of_customers **/
SELECT 
    COUNT(*) AS num_customers, Region
FROM
    cust_dimen
GROUP BY Region
ORDER BY num_customers DESC;






/** C. Find the region having maximum customers (display the region name and max(no_of_customers) **/
SELECT 
    COUNT(*) AS no_of_customers, Region
FROM
    cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC
LIMIT 1;






/** D. Find the number and id of products sold in decreasing order of products sold 
** (display product id, no_of_products sold) **/

SELECT 
    prod.Prod_id, COUNT(*) AS no_of_products
FROM
    prod_dimen prod
        INNER JOIN
    market_fact market ON prod.Prod_id = market.Prod_id
GROUP BY Prod_id
ORDER BY no_of_products DESC;






/** E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ 
**  Product_Sub_Categoryand the number of tables purchased (display the customer name, no_of_tables purchased)
**/
SELECT 
    cust.Customer_Name AS 'customer name',
    COUNT(*) AS 'no_of_tables'
FROM
    cust_dimen cust
        INNER JOIN
    market_fact market ON cust.Cust_id = market.Cust_id
        INNER JOIN
    prod_dimen prod ON market.Prod_id = prod.Prod_id
WHERE
    cust.Region = 'Atlantic'
        AND prod.Product_Sub_Category = 'Tables'
GROUP BY cust.Customer_Name;

 
 
 
 
 
/** Task 3: Advanced Analysis **/
SELECT 
    prod.Product_category AS product_category,
    ROUND(SUM(market.Profit), 2) AS profits
FROM
    market_fact market
        INNER JOIN
    prod_dimen prod ON market.Prod_id = prod.Prod_id
GROUP BY prod.Product_category
ORDER BY profits DESC;






/** B. Display the product category, product sub-category and the profit within 
** each sub-category in three columns. */

SELECT 
    prod.Product_category,
    prod.Product_Sub_Category,
    ROUND(SUM(market.Profit), 2) AS profits
FROM
    market_fact market
        INNER JOIN
    prod_dimen prod ON market.Prod_id = prod.Prod_id
GROUP BY prod.Product_category , prod.Product_Sub_Category
ORDER BY prod.Product_category , prod.Product_Sub_Category , profits DESC;






/** C. Where is the least profitable product subcategory shipped the most? 
**  For the least profitable product sub-category, display the region-wise no_of_shipments 
**  and the profit made in each region in decreasing order of profits 
**  (i.e. region, no_of_shipments, profit_in_each_region)
o** Note: You can hardcode the name of the least profitable product sub-category **/

SELECT 
    least_profitable_result.prod_sub_category
FROM
    (SELECT 
        prod.Product_Sub_Category AS prod_sub_category,
            ROUND(SUM(market.Profit), 2) AS profits
    FROM
        market_fact market
    INNER JOIN prod_dimen prod ON market.Prod_id = prod.Prod_id
    GROUP BY prod.Product_Sub_Category
    ORDER BY profits ASC
    LIMIT 1) least_profitable_result;






/**Second step is to get the region wise no_of_shipments for the value least
** profitable sub category value obtained in previous step which is 'TABLES'

**/
SELECT 
    region_name, no_of_shipments, profit_in_each_region
FROM
    (SELECT 
        cust.Region AS region_name,
            COUNT(*) AS no_of_shipments,
            ROUND(SUM(market.profit), 2) AS profit_in_each_region
    FROM
        prod_dimen prod
    JOIN market_fact market ON market.Prod_id = prod.Prod_id
    JOIN cust_dimen cust ON cust.Cust_id = market.Cust_id
    WHERE
        prod.Product_Sub_Category = 'TABLES'
    GROUP BY cust.Region) regionwise_shipments
ORDER BY no_of_shipments DESC
LIMIT 1;

