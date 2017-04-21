-- Task 1: Understanding the data in hand.
-- Describe the data in hand in your own words. (Word Limit is 500).
/* There are 5 datasets at hand. Four are dimension datasets that describe all the details of the 
respective entity. For example: cust_dimen provides all attributes required to describe a customer 
and orders_dim keeps all information for orders placed. 

 All datasets ending with '_dimen' present similar information for their entities.
 The fifth dataset 'market_fact' contains keys from all other tables along with relevant facts or 
 metrics. This table acts as a single snapshot to calculate any metric.
 
 Describing the market_fact table:
 'Ord_id' --> This field references the Primary key in orders_dimen. This uniquely identifies an order and if we need to describe that order, we can join market_fact and orders_dimen to get descriptive details and metrics together.
'Prod_id' --> This field references the Primary key in prod_dimen. This uniquely identifies a Product.
'Ship_id' --> This field references the Primary key in shipling_dimen. This uniquely identifies a shippment.
'Cust_id' --> This field references the Primary key in cust_dimen. This uniquely identifies a Customer.
'Sales' --> This is a metric that gives the sale amount of a particular product(product_id) in order(order_id) shipped by(ship_id) to customer(cust_id).
'Discount' --> This is a metric that gives the discount offered for a particular product(product_id) in order(order_id) shipped by(ship_id) to customer(cust_id).
'Order_Quantity' --> This is a metric that gives the quantity of a particular product(product_id) in order(order_id) shipped by(ship_id) to customer(cust_id).
'Profit' --> This is a metric that gives the profit on a particular product(product_id) in order(order_id) shipped by(ship_id) to customer(cust_id).
'Shipping_Cost' --> This is a metric that gives the shipping cost of a particular product(product_id) in order(order_id) shipped by(ship_id) to customer(cust_id).
'Product_Base_Margin' --> This is a metric that gives the base margin of a particular product(product_id) in order(order_id) shipped by(ship_id) to customer(cust_id).

An interesting thought about orders_dimen is that it has Order_id along with Ord_id. By Naming 
convention, either can act as the primary key of this dataset, but in reality, only Ord_id is as 
Order_id has duplicates. Order_id is just used to relate to shipments made. I believe it is a 
redundant attribute.

Another observation is that there are no units available for each attribute of each dataset. 
This always leads to confusion and is a bad practice.

*/

---- Identify and list the Primary Keys and Foreign Keys for this dataset.
/*
Below are the Primary Keys
cust_dimen --> Cust_id
orders_dimen  --> Ord_id
prod_dimen --> Prod_id
shipping_dimen --> Ship_id

Foreign Keys
market_fact --> Ord_id, Prod_id, Ship_id, Cust_id
*/

-- Task 2: Basic Analysis
-- 2.A Find the total and the average sales (display total_sales and avg_sales)
SELECT 
    SUM(Sales), AVG(Sales)
FROM
    market_fact;




-- 2.B Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region, no_of_customers.
SELECT 
    Region, COUNT(cust_id) AS cust_count
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(cust_id) DESC;




-- 2.C Find the region having maximum customers (display the region name and max(no_of_customers)
SELECT 
    Region, COUNT(cust_id) AS cust_count
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(cust_id) DESC
LIMIT 1;




-- 2.D Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
SELECT 
    Prod_id, COUNT(Order_Quantity) AS no_of_products_sold
FROM
    market_fact
GROUP BY Prod_id
ORDER BY no_of_products_sold DESC;



 

-- 2.E Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)
select	
	cd.Customer_Name as Customer_Name, SUM(mf.Ord_id) as no_of_tables_purchased 
from 
	market_fact mf 
inner join 
	cust_dimen cd 
on 
	mf.cust_id=cd.cust_id and
    cd.Region = 'Atlantic'
inner join
	prod_dimen pd
on
	mf.prod_id=pd.prod_id and
    pd.Product_Sub_Category = 'TABLES'
group by 
	cd.Customer_Name;

 


-- Task 3: Advanced Analysis
--  3.A Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
select 
	pd.product_category, SUM(mf.Profit) as Profit 
from 
	market_fact mf inner join prod_dimen pd 
on 
	mf.prod_id=pd.prod_id  
group by 
	pd.product_category 
order by Profit desc;





-- 3.B Display the product category, product sub-category and the profit within each sub-category 
# in three columns.
select 
	pd.product_category,pd.Product_Sub_Category, SUM(mf.Profit) as Profit 
from 
	market_fact mf 
inner join                                            
	prod_dimen pd 
on 
	mf.prod_id=pd.prod_id  
group by 
	pd.product_category, pd.Product_Sub_Category;





-- 3.C Where is the least profitable product subcategory shipped the most? 
--    For the least profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region) o 
--    Note: You can hardcode the name of the least profitable product sub-category

-- The least profitable product sub-category is TABLES

select 
	cd.Region, count(distinct mf.ship_id) as no_of_shipments, SUM(mf.Profit) as profit_in_each_region 
from 
	market_fact mf 
inner join 
	shipping_dimen sd 
on 
	mf.Ship_id = sd.Ship_id
inner join 
	cust_dimen cd
on 
	mf.Cust_id=cd.Cust_id
where 
	mf.Prod_id in (
					select 
						a.prod_id 
					from 
						prod_dimen a 
					where 
						a.Product_Sub_Category='TABLES'
					)
group by cd.Region
order by profit_in_each_region desc;

# The least profitable product sub-category 'TABLES' is shipped the most to 'ONTARIO' Region with 79 shippments.







