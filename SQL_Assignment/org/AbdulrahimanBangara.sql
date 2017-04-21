/*
		Abdul rahiman bangara
*/

--Task 1: Understanding the data in hand
--A. Describe the data in hand in your own words. (Word Limit is 500)

--The schema contains five tables.

--Order Dimensions: 

--This table contains the details of orders placed and acts as a master table of order details. The fields are order_id (to identify in the shipping dimension table), order date, order priority and Ord_ID which uniquely identify each order.

--Customer Dimensions: 

--This table has the master details of customers and their address details with Cust_ID as the unique field to identify individual record. The same customer name may have multiple records due to their presence in different region and province.

--Product Dimensions:

--This table is the master data for all the products that the company sells. Products are categorized in two categories, category and sub category and prod_id is the unique record identifier.

--Shipping Dimensions:

--This table provides the master information about individual shipping transactions. Each record is uniquely identified by ship_id column. The table also contains mode of shipment and shipping date of each transactions. This table also contains the order_ID field referenced from the order dimension table to identify what order_id was shipped in a particular shipment.

--Market Factors:

--This table contains the details of individual sales transaction. It contains the order_Id, product_id, ship_id, cust_id as foreign keys referenced from other tables and more data like sales figure, discount, profit, shipping cost and product base margin on individual transaction. 


--B. Identify and list the Primary Keys and Foreign Keys for this dataset

--1.	Order Dimensions
--	a.	Order_id 				type – int 	
--	b.	Order_Date				type - text
--	c.	Order_Priority			type - text
--	d.	Ord_id					type – text		(Primary Key)

--2.	Customer Dimensions
--	a.	Customenr_Name			type - text
--	b.	Province				type - text
--	c.	Region					type - text
--	d.	Customer_Segment		type - text
--	e.	Cust_ID 				type – text		(Primary Key)

--3.	Product Dimensions
--	a.	Product_Category		type - text
--	b.	Product_Sub_Category	type - text
--	c.	Prod_ID					type - text 	(Primary Key)

--4.	Shipping Dimensions
--	a.	Order_ID				type - int
--	b.	Ship_Mode				type - text
--	c.	Ship_Date				type - text
--	d.	Ship_ID					type - text 	(Primary Key)

--5.	Market Factors
--	a.	Ord_ID					type - text 	(Foreign Key – Order Dimensions (Ord_ID)
--	b.	Prod_ID					type - text 	(Foreign Key – Product Dimensions (Prod_ID)
--	c.	Ship_ID					type - text 	(Foreign Key – Shipping Dimensions (Ship_ID)
--	d.	Cust_ID					type - text 	(Foreign Key – Customer Dimensions (Cust_ID)
--	e.	Sales					type - double
--	f.	Discount				type - double						
--	g.	Order_Quantiy			type - int
--	h.	Profit					type - double
--	i.	Shipping_Cost			type - double
--	j.	Product_Base_Margin		type - double


--Task 2: Basic Analysis

--Write the SQL queries for the following:

--A. Find the total and the average sales (display total_sales and avg_sales)

select sum(sales), avg(sales)
from market_fact;

--B. Display the number of customers in each region in decreasing order of
--no_of_customers. The result should be a table with columns Region,
--no_of_customers

select Region, count(*) as no_of_customers
from cust_dimen
group by Region
order by count(*) desc;

--C. Find the region having maximum customers (display the region name and
--max(no_of_customers)

select sub_table.Region, max(sub_table.no_of_customers) as no_of_customers
from (select Region, count(*) as no_of_customers 
		from cust_dimen 
		group by Region 
		order by count(*) desc)
 as sub_table;

--D. Find the number and id of products sold in decreasing order of products sold (display
--product id, no_of_products sold)

select Prod_id, sum(order_quantity) as no_of_products_sold
from market_fact
group by Prod_id
order by sum(order_quantity);

--E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and
--the number of tables purchased (display the customer name, no_of_tables
--purchased) 

select cd.Customer_Name, sum(mf.Order_Quantity) as no_of_tables_purchased
from cust_dimen cd inner join market_fact mf on cd.Cust_id = mf.Cust_id 
				   inner join prod_dimen pd on mf.Prod_id=pd.Prod_id
where pd.Product_Sub_Category = "TABLES" and cd.Region = "Atlantic"
group by cd.Customer_Name;

--Task 3: Advanced Analysis
--Write sql queries for the following:
--A. Display the product categories in descending order of profits (display the product
--category wise profits i.e. product_category, profits)?

select pd.Product_Category, mf.Profit 
from prod_dimen pd inner join market_fact mf on pd.Prod_id = mf.Prod_id
group by pd.Product_Category
order by mf.Profit desc;

--B. Display the product category, product sub-category and the profit within each subcategory
--in three columns.

select pd.Product_Category, pd.Product_Sub_Category, mf.Profit 
from prod_dimen pd inner join market_fact mf on pd.Prod_id = mf.Prod_id
group by pd.Product_Category, pd.Product_Sub_Category;

--C. Where is the least profitable product subcategory shipped the most? For the least
--profitable product sub-category, display the region-wise no_of_shipments and the
--profit made in each region in decreasing order of profits (i.e. region,
--no_of_shipments, profit_in_each_region)
--o Note: You can hardcode the name of the least profitable product subcategory

select cd.region, count(sd.Ship_id) as no_of_shipments, mf.Profit
from shipping_dimen sd inner join market_fact mf on sd.Ship_id = mf.Ship_id 
					   inner join cust_dimen cd on mf.Cust_id = cd.Cust_id
                       inner join prod_dimen pd on mf.Prod_id = pd.Prod_id
where pd.Product_Sub_Category = "STORAGE & ORGANIZATION"
group by cd.Region
order by mf.Profit desc;

--Important Note:
--Submit your answers for all these tasks in a .sql file.