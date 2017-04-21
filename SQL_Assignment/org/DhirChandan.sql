/* Name - Dhir Chandan --- Roll - DDA1710293 --- Task - SQL Graded Assignment */

/* Task 1 A - 
Data IN hand is regarding a superstore IN Canada. Various entities/stakeholders relating to a super store are elaborated using tables like cutomer data,
sales data, product data, shipping data, and Market_fact.
Customer data gives details about customer name, location and the category of customer(consumer,corporate,etc.)
Product data - details about various products that are sold and their categories/sub-categories.
orders data - details about ORDER, date and the priority ON them.
shipping data - details about which ORDER is shipped, date and the mode
market_fact - connects all the above tables - which ORDER has which product of how much quantity, its shipping info, and all the financials associated to it.*/

/* Task 1 B -
--Cust_dimen
	Primary key 	- cust_id
	Fields/COLUMNS 	- cust_id (text),Province (text), region (text), Customer_segment (text)	

--prod_dimen
	Primary key 	- Prod_id
	Fields/COLUMNS 	- Product_Category (text), product_sub_category (text), prod_id (text)

--shipping_dimen
	Primary key 	- Ship_id
	foriegn key 	- Order_id (orders_dimen)
	Fields/COLUMNS 	- Order_id (int), Ship_Mode (text), Ship_date (text), Ship_id (text)

--orders_dimen
	Primary key 	- Ord_id
	Fields/COLUMNS 	- Order_ID (int), Order_Date (datetime), Order_priority (text), Ord_id (text)

--market_fact
	Primary key 	- (Ord_id,Prod_id,Ship_id,cust_id)  ~~Composite primary key
	Foriegn key 	- Ord_id (orders_dimen) , Prod_id(prod_dimen), Ship_id(shipping_dimen), Cust_id(Cust_dimen)
	Fields/COLUMNS 	- Ord_id (text), Prod_id (text), Ship_id (text), Cust_id (text),Sales (double), 
					  discount (double), Order_quantity (int), Shipping_cost (double), Product_base_margin (double)

*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/* Task 2 A */

SELECT SUM(sales) AS total_sales, avg(sales) AS avg_sales 
FROM superstoresdb.market_fact;								/* using aggregrate functions SUM() and AVG() to get the total and avegrage of sales*/

/* Task 2 B */

SELECT Region, COUNT(Cust_id) AS no_of_customers 
FROM superstoresdb.cust_dimen 
GROUP BY Region 
ORDER BY no_of_customers DESC;						/* aggregating customer ID to COUNT and grouping based ON region */

/* Task 2 C */


SELECT Region, COUNT(Cust_id) max_no_of_customers   /* query to get region with max number of customers*/
FROM cust_dimen   
GROUP BY Region
ORDER BY mycount DESC LIMIT 1						/* sort IN descending ORDER and using LIMIT here to get region with max customers. Here TOP can also be used*/

/* Task 2 D */

SELECT prod_id, SUM(Order_Quantity) AS no_of_products_sold
FROM superstoresdb.market_fact 
GROUP BY Prod_id 
ORDER BY no_of_products_sold DESC; 								/* Grouping the result set based ON product ID and aggregating BY SUM of quantities to get the total number of each product sold and sort IN descending ORDER of COUNT*/

/* Task 2 E */

SELECT Cust_id, SUM(Order_Quantity) AS no_of_tables 
FROM superstoresdb.market_fact 
WHERE Cust_id IN (SELECT cust_id FROM cust_dimen WHERE Region='atlantic') 				/* filtering customer region AS Atlantic*/
AND Prod_id IN (SELECT Prod_id FROM prod_dimen WHERE Product_Sub_Category='tables')		/* filtering product AS table */ 
GROUP BY Cust_id 
ORDER BY no_of_tables DESC;																/* grouping BY customer id and aggregating BY SUM of ORDER quantities to get no. of tables per customer */

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/* Task 3 A */

SELECT p.Product_Category,SUM(m.Profit) AS Profits 
FROM market_fact m 
JOIN prod_dimen p ON m.prod_id=p.Prod_id									/* Joining market data with product details to get product category for each sale*/
GROUP BY Product_Category 													/* Grouping BY Product category and aggregating the SUM of Profits to get product category wise profit*/
ORDER BY Profits DESC;														/* sorting in decreasing ORDER of profits */

/* Task 3 B */

SELECT p.Product_Category,p.Product_Sub_Category,(m.Profit) AS Profits 
FROM market_fact m 
JOIN prod_dimen p ON m.prod_id=p.Prod_id									/* Joining market data with product details to get product category and sub category for each sale*/
GROUP BY Product_Sub_Category 												/* Grouping BY Product sub category and aggregating the SUM of Profits to get product sub category wise profit*/
ORDER BY Profits DESC;														/* sorting in decreasing ORDER of profits */

/* Task 3 C */

SELECT Region, COUNT(Ship_id) AS no_of_shipments, SUM(Profit) AS profit_in_each_region					/* aggregating count of shipments to get total shipments and sum of profits to get total profit*/
FROM market_fact m 
JOIN prod_dimen p ON m.prod_id=p.Prod_id JOIN cust_dimen c ON m.Cust_id=c.Cust_id 						/* joining market facts along with customer data and product data to get more details about product shipped and also more info about the customer (i.e region) */
WHERE Product_Sub_Category = 'STORAGE & ORGANIZATION'													/* Filtering by product sub category = STORAGE & ORGANIZATION, which is the least profitable */
GROUP BY Region 																						/* Grouping by region to get regionwise no. of shipments and profit for the least profitable sub category*/
ORDER BY profit_in_each_region DESC;  																	/* ordering in decreasing order of profits per region */
