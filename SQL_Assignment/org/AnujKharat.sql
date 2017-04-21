/*
		Anuj Kharat
*/

-- Task 1: Understanding the data in hand
-- A. Describe the data in hand in your own words. (Word Limit is 500)
-- Data Type -- Column Names
-- numeric   -- order_id (orders_dimen,shipping_dimen); sales,profit,discount,order_quantity,shipping_cost, product_based_margin(Market_fact)
-- character -- customer_name,region,province,customer_segment (cust_dimen); priority (orders_dimen); shipping_mode (shipping_dimen); Product_category,Product_sub_category (prod_dimen)
-- character -- cust_id, ship_id, ord_id, prod_id (These are alphanumeric)
-- Date      -- order_date(orders_dimen); shipping_date(shipping_dimen) 

--     Superstore Data contains five tables viz. cust_dimen, orders_dimen, shipping_dimen, prod_dimen 
-- & market_fact. Cust_dimen table contains customer information like customer’s name, region, province
-- (sub category of Region), segment and unique customer id. Orders_dimen table contains information 
-- about orders like order date, priority of order and two different types of order ids one which is 
-- used to tag corresponding ship id and another is unique order id (ord_id). Shipping_dimen table 
-- contains shipping informations unique ship id, shipping date, mode of shipping and same order id 
-- from orders_dimen table to map them with ship id. Prod_dimen table contains Product category, 
-- product sub category and unique product id. Market_fact table is like inventory which contains 
-- product id, customer id, ship id, order id, sales of product, discount given on product, quantity 
-- of ordered product, profit booked, shipping cost and product based margin. 

--     There are total 1832 customer ids distributed across 8 regions and 13 province. There are 
-- 17 products/product sub categories distributed across three categories (office supplies, technology
-- and furniture). There are total 7701 ship ids distributed across 3 modes of shipping viz. delivery 
-- by truck, express air and regular air. There are total 5506 orders are placed with one of the 
-- 5 types of priorities viz. critical, high, medium, low and not specified. There are total 8399 inventories
-- in market_fact where we can see if superstore booked profit or not also how much will be shipping 
-- cost also if there is discount given on products also quantities of ordered products. 
-- Market_fact table combines data from all other tables.
 
--     From this data we can do analysis about profitability of product across categories, region, 
-- province etc. Also we can also do analysis about cheapest mode of shipping. We can find which are
-- vulnerable or profitable regions.

-- B. Identify and list the Primary Keys and Foreign Keys for this dataset
-- table_name     - primary key - foregain key (to table_name)
-- cust_dimen     - cust_id     - 
-- orders_dimen   - Ord_id      - 
-- prod_dimen     - Prod_id     - 
-- shipping_dimen - ship_id     - 
-- market_fact    -             - cust_id (cust_dimen), Ord_id (orders_dimen), Prod_id (prod_dimen), ship_id (shipping_dimen)



-- Task 2: Basic Analysis
-- A. Find the total and the average sales (display total_sales and avg_sales)
select sum(Sales) as total_sales, avg(Sales) as avg_sales
from market_fact;

-- B. Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region, no_of_customers
 -- if customers are not distinct
select  region as Region, count(cust_id) as no_of_customers
from cust_dimen
group by Region
order by no_of_customers desc;

-- C. Find the region having maximum customers (display the region name and max(no_of_customers)
select a.Region , max(a.no_of_customers) as max_no_of_customers 
from ( select  region as Region, count(customer_name) as no_of_customers
from cust_dimen
group by Region
order by no_of_customers desc) a;

-- D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
select Prod_id as Product_id, sum(order_quantity) as no_of_product_sold
from market_fact
group by prod_id
order by no_of_product_sold desc;

-- E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)

select Customer_name as customer_name, order_quantity as no_of_table_purchased
from market_fact mf
inner join cust_dimen cd on mf.cust_id = cd.cust_id
where mf.prod_id = (select Prod_id from prod_dimen where Product_sub_category = 'TABLES') 
and mf.cust_id in( select cd.cust_id from cust_dimen cd where region = 'ATLANTIC');


-- Task 3: Advanced Analysis
-- A. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
select product_category as Product_Category, sum(Profit) as Profits
from market_fact mf
inner join prod_dimen pd on mf.prod_id=pd.prod_id
group by product_category
order by Profits desc;

-- B. Display the product category, product sub-category and the profit within each sub-category in three columns.
select product_category as Product_Category,  Product_sub_category as product_sub_category, sum(Profit) as Profits
from market_fact mf
inner join prod_dimen pd on mf.prod_id=pd.prod_id
group by product_sub_category
order by Product_Category, Profits desc;

-- C. Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)
-- o Note: You can hardcode the name of the least profitable product sub-category

select Region as Region , count(ship_id) as no_of_shipments, sum(Profit) as Profits
from market_fact mf
inner join cust_dimen cd on mf.cust_id = cd.cust_id
inner join prod_dimen pd on mf.Prod_id = pd.Prod_id
where pd.Product_Sub_Category =(select b.Product_Sub_Category 
from
(select a.product_sub_category, min(a.Profits) as least_profit
from 
(select product_sub_category , sum(Profit) as Profits
from  prod_dimen pd
inner join market_fact mf on pd.prod_id = mf.prod_id
group by product_sub_category
order by Profits) 
a)
b)
group by cd.Region
order by profits desc;

-- finding product category having least profit
select b.Product_Sub_Category from(
select a.product_sub_category, min(a.Profits) as least_profit
from (select product_sub_category , sum(Profit) as Profits
from  prod_dimen pd
inner join market_fact mf on pd.prod_id = mf.prod_id
group by product_sub_category
order by Profits) a ) b