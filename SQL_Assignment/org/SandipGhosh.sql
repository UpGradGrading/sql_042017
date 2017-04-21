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

select sum(sales) as total_sales, avg(sales) as average_sales
from market_fact; 

B. Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region, no_of_customers 

select region as region, count(*) as no_of_customers
from cust_dimen
group by region
order by no_of_customers desc;

C. Find the region having maximum customers (display the region name and max(no_of_customers) 

select region as region_name , count(cust_id) as no_of_customers
from cust_dimen
group by region having count(cust_id) = 
(select max(mycount) from (select count(cust_id) as mycount from cust_dimen group by region)
mytable);

D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold) 

select prod_id as product_id, sum(order_quantity) as no_of_products_sold
from market_fact
group by product_id
order by no_of_products_sold desc;

E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)  

select cust.customer_name as customer_name, sum(fact.order_quantity) as no_of_tables_purchased
from market_fact fact
inner join cust_dimen cust on cust.cust_id = fact.cust_id
inner join prod_dimen prod on prod.prod_id = fact.prod_id
where cust.region = 'atlantic'
and prod.product_sub_category = 'tables'
group by customer_name;

Task 3: Advanced Analysis 
Write sql queries for the following:

A. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)? 

select prod.product_category as product_category, sum(fact.profit) as profits
from market_fact fact
inner join prod_dimen prod on prod.prod_id = fact.prod_id
group by product_category
order by profits desc;

B. Display the product category, product sub-category and the profit within each subcategory in three columns.

select prod.product_category as product_category, prod.product_sub_category as product_sub_category, sum(fact.profit) as profits
from market_fact fact
inner join prod_dimen prod on prod.prod_id = fact.prod_id
group by product_category, product_sub_category
order by product_category, profits desc, product_sub_category; 

C. Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the  region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region) 
o Note: You can hardcode the name of the least profitable product subcategory

select cust.region as region, count(distinct fact.ship_id) as no_of_shipments, sum(fact.profit) 
as profit_in_each_region
from market_fact fact
inner join cust_dimen cust on cust.cust_id = fact.cust_id
inner join prod_dimen prod on prod.prod_id = fact.prod_id
where 
prod.product_sub_category = 'tables'
group by region
order by profit_in_each_region desc;


