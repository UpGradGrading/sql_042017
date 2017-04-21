/*
				Srivastavan Varadharajan
*/

show tables;
# The data contains information from a North American company which sells office equipments for corporate/Small businesses and home office needs.
# All the orders by customers along with product and shipping information are stored in market_fact table The order_dimen table contains data on 
# order priority and dates. The product_dimen table contains the product information and shipping_dimen has information on how and when the order 
# was shipped to the customer. cust_dimen contains master data of the customer. The orders between 2009-2012 have been maintained in the data
# Fields for which the default datatype was changed
# Order_Date from orders_dimen - Datetime
# Order_ID from orders_dimen - Text
# Order_ID from shipping_dimen - Text
# ship_ID from shipping_diman - Datetime


# Primary and secondary keys
# Cust_dimen - Primary key - Cust_id, Secondary key - None
# Market_face - Primary key - None, Secondary key - Ord_id, Prod_id, Ship_id,Cust_id
# prod_dimen - Primary key - Prod id, Secondary key - None
# orders_dimen - Primary key - Ord_id, Secondary key - None
# shipping_dimen - Primary key - Ship_id, Secondary key - None
# All fields which were made as primary key and foriegn key were changed to Varchar(255)


use superstoredb;
# Task 2: Basic Analysis

# A. Find the total and the average sales (display total_sales and avg_sales) 
Select Sum(Sales) as Total_Sales,Avg(Sales) as Average_Sales
from market_fact;

# B. Display the number of customers in each region in decreasing order of no_of_customers. 
# The result should be a table with columns Region,no_of_customers
Select Region,count(Cust_id) as no_of_customers from cust_dimen
group by Region;
# C. Find the region having maximum customers (display the region name and max(no_of_customers)

Select Region,count(Cust_id) as 'max(no of customers)' from cust_dimen
group by Region 
order by count(Cust_id) DESC limit 1;

# D. Find the number and id of products sold in decreasing order of products sold (display
# product id, no_of_products sold)
select prod_id,count(*) as no_of_products_sold from market_fact
group by Prod_id
order by no_of_products_sold DESC;

# E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and
# the number of tables purchased (display the customer name, no_of_tables purchased) 
select c.Customer_Name,m.Order_Quantity as no_of_tables_purchased from market_fact m left outer join prod_dimen p on m.Prod_id=p.Prod_id 
left outer join cust_dimen c on m.Cust_id=c.Cust_id
where p.Product_Sub_Category='TABLES' and c.Region='ATLANTIC';


# Task 3: Advanced Analysis

# A. Display the product categories in descending order of profits (display the product
# category wise profits i.e. product_category, profits)?

select p.Product_Category,m.Profit as profits from market_fact m left outer join prod_dimen p on m.Prod_id = p.Prod_id
group by p.Product_Category
order by profits DESC;

# B. Display the product category, product sub-category and the profit within each subcategory
# in three columns. 
select p.Product_Category,p.Product_Sub_Category,m.Profit as profits from market_fact m left outer join prod_dimen p on m.Prod_id = p.Prod_id
group by p.Product_Category,p.Product_Sub_Category;



# C. Where is the least profitable product subcategory shipped the most? For the least
# profitable product sub-category, display the region-wise no_of_shipments and the
# profit made in each region in decreasing order of profits (i.e. region,no_of_shipments, profit_in_each_region)

select c.Region,count(distinct(s.Ship_id)) as no_of_shipments,sum(m.Profit) as profit_in_each_region from market_fact m left outer join prod_dimen p on m.Prod_id = p.Prod_id left outer join shipping_dimen s on m.Ship_id=s.Ship_id
left outer join cust_dimen c on m.Cust_id=c.Cust_id
where p.Product_Sub_Category='STORAGE & ORGANIZATION'
group by c.Region
order by profit_in_each_region DESC;
