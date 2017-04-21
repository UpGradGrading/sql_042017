/*
				Srinivasa Chavali
*/

/*  Task 1:  Understanding the Data in Hand    */

/* A.  Describe the data in hand in your own words 

Given sample database contains sales order data for different set of customer across the regions for several products with different shipping details.  To peform some analysis and to gain some valuable insight over this data we need OLAP mechanism by storing all the data into diffrent dimensions and facts.
 
Dim_Product dimension contains all the products (Categories) and Produt Subcategories data which are uniquely identifie by a primary key field - Prod_id.  Same field is referred to Prod_id in Market fact table as Foreign key.

Dim_Orders dimension contains all the orders information like when the order got placed and what priority has been choosen for a particular order.  In addition we have surrogate key placed on ord_id field in this Dim_Orders table which acts as identity column to have a stable environment also helps for the peformancee perspective.

Dim_Customer dimention contains all the customer information like Customer Name and Custom ID, Customre region and province and we have an important column called Customer Segment. 

Dim_Shipping dimension contains all the order shipping details includes Order ID, Order Ship date, Ship mode and the Ship Id.

All the lowest level of ID's presenting in dimension tables are placed in the Market fact table for unique identification of the entire market fact data.  These are referred to as level or grain.

Lastly we have a fact table store the fact data like profit, sales, order_quantity, Discount, Shipping_cost and the product base margin at the level of Cust ID, Prod_id, Ship_id, Order_id

Here we have choose STAR schema where we have centralized fact table called Market_Fact surrounder by Sever Dimensions like Dim_Customer, Dim_Shipping, Dim_Product, Dim_Orders
 
*/



/* B.  Identify and list the Primary Keys and Foreign Keys for this dataset   */


Primary Keys:	Order_id FROM Dim_Orders Table
				Prod_id from Dim_Product Table
                
 
Foreign Keys:   Ord_ID (FK) Referred to the Primany key column - Order_id from Dim_Orders table
				Prod_id (FK) Referred to the Primary Key Column - Prod_id from Dim_Product table
                
                
use superstoresdb;
select * from dim_customer;
select * from dim_product;
select * from market_fact;
select * from dim_shipping;
select * from dim_orders;

/* Task 2: Basic Analysis   */

/* A.  Find the total and the average sales (display total_sales and avg_sales) */

select sum(Sales) as total_Sales, avg(Sales) as avg_sales from market_fact;


/* B.  Display the number of customers in each region in decreasing order of  no_of_customers. 
The result should be a table with columns Region, no_of_customers */

select Region, count(Customer_Name) as no_of_customers from dim_customer
group by Region 
order by count(Customer_Name) desc;



/* C.  Find the region having maximum customers (display the region name and
max(no_of_customers)     */

select Region as Region_Name, count(customer_name) as Max_No_of_Customers 
from dim_customer  
group by region 
order by count(customer_name) desc
limit 1



/* D.  Find the number and id of products sold in decreasing order of products sold (display
product id, no_of_products sold)   */


select prod.Prod_id,sum(Order_Quantity) from market_fact fact 
join dim_product prod 
on fact.Prod_id=prod.Prod_id 
group by prod.Prod_id 
order by sum(order_quantity);



/* E.  Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and
the number of tables purchased (display the customer name, no_of_tables
purchased) */


select cust.Customer_Name, SUM(fact.Order_Quantity) as No_of_Tables_Purchased
from market_fact fact 
join dim_customer cust on fact.Cust_id = cust.Cust_id 
join dim_product prod on fact.Prod_id = prod.Prod_id
where cust.Region = 'ATLANTIC' and prod.Product_Sub_Category in ('TABLES')
group by cust.Customer_Name




/* Task 3: Advanced Analysis */


/* A.  Display the product categories in descending order of profits 
(display the product category wise profits i.e. product_category, profits)? */

select prod.Product_Category, sum(fact.profit) as Profits 
from Market_Fact fact join Dim_Product prod on fact.Prod_id = prod.Prod_id
group by prod.Product_Category
order by sum(fact.profit) desc;

/* B.  Display the product category, product sub-category and the profit within 
each sub-category in three columns. */

select prod.Product_Category, prod.Product_Sub_Category, sum(fact.Profit) as Profit
from market_fact fact join Dim_Product prod on  fact.Prod_id = prod.Prod_id
group by prod.Product_Category, prod.Product_Sub_Category



/*  C.  Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)
o Note: You can hardcode the name of the least profitable product sub-category  */


select c1.region,count(f1.ship_id) as no_of_shipments,sum(f1.profit) as profit
from market_fact f1 join dim_customer c1 on c1.cust_id=f1.cust_id
join dim_product p1 on p1.prod_id=f1.prod_id

where p1.Product_Sub_Category = ('select prod.Product_Sub_Category,sum(fact.profit) as profit from
market_fact fact join dim_product prod on prod.prod_id=fact.prod_id
group by prod.Product_Sub_Category
order by sum(fact.profit) limit 1')

group by c1.region
order by sum(f1.profit) desc


