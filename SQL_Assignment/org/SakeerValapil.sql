/*
		Sakeer Valapi
*/


# --SQL  Assignment
# --Instruction File
# --Task 0:
# --Download the data files for this assignment. Your first task is to create tables from these files. In order to do so, please follow the steps given below sequentially:
# --1. Open MySQL Workbench
# --2. Connect to your database using the connection you have created
# --3. Create a database named superstoresDB
# --4. In the Navigator pane on the left hand side, you will find the created database
# --5. Right click on the superstoresDB
# --6. You will see the option called Table Data Import Wizard. Click on it.
# --7. Follow the wizard to create tables by providing the .csv data files that you have downloaded
# --8. You need to follow the Table Data Import Wizard for each data file given for this assignment.
# --Please refer https://dev.mysql.com/doc/workbench/en/wb-admin-export-import-table.html to get more information on table data import. Once you are done with this task, attempt following tasks:
# --Task 1: Understanding the data in hand


# --A. Describe the data in hand in your own words. (Word Limit is 500)


#This Database basic structure of a store where it explains the table structures of customer , product, order  and shipment details. In addition to that the table market fact explain sales figures ,discount, qty and profit related to each shipment of the items. 
#However in my observation I have noticed that same product under same order id is shipped with different sales price / discount data,  this will create  problem with integrity of data  .
#This can be an error  unless  the organization has policy that allows to ship the same product at different rates 
#Customer_dimen table shows the data of all customers with name ,province,region and segment  , This data helps the store, retrieve and analyse data base on customer segment , province , region etc. 
#Product_dimen table shows data of all the product in the store with category and sub category . This saves product data at the store, on category level and helps it easy to analyse products on categorically .
#Order _dimen show data of all the order  ( unique_id ord id ) with order _date , priority  . In addition to that it shows another column order_id which is foreign key to shipment . This  records data at the store all order received by order date  and priority .
#Sipping_dimen shows data about shipment, with unique ID of ship_id with Ship Mode and Ship ID. This table store shipment details by various mode of shipment. 
#Market Fact shows sales amount , discount , profile , shipment cost and order qty for each shipment under each orders. This is one of the table where key information is stored such as sales , discount shipment cost etc. This will help the store management to analyse profitability and shipment fulfilment information. 

#B; 


# --B. Identify and list the Primary Keys and Foreign Keys for this dataset


#Customer_dimen  - Primary key  cust_id   -  No foreign Key 
#Product_dimen – Primary key prod_id – No foreign key 
#Orders_dimen – Primary key  ord_id 
#Shipping_dimen – Primary key  ship_id and Foreign key  Order _id on orders_dimen order_id
#Market_Data  - Foreign key ord_id on Odersdiment ord_id ,
#		Foreign key Prod_id   on  Product_dimen  Prod_id
#		Foreign key Ship_id on Shipping_dimen ship_id
#		Foreign key cust_id on customer_dimen cust_id

use superstoresdb;
# --Task 2: Basic Analysis
# --Write the SQL queries for the following:
# --A. Find the total and the average sales (display total_sales and avg_sales)
select sum(sales),avg(sales) from market_fact;
# --B. Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region, no_of_customers
Select Region , count(cust_id) as custcount from cust_dimen group by region order by custcount desc
# --C. Find the region having maximum customers (display the region name and max(no_of_customers)
#

select Region , count(cust_id) as custcount from cust_dimen group by region order by custcount desc limit 0,1


# --D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products_sold)
select prod_id , sum(order_quantity) no_of_tables purchased  as no_of_products_sold from market_fact  group by prod_id order by no_of_products_sold desc
# --E. Find all the customers from Atlantic region who have ever purchased TABLES and the number of tables purchased (display the customer name, no_of_tables purchased)
Select Customer_Name, sum(Order_quantity) from cust_dimen 
inner join market_fact on cust_dimen.cust_id =market_fact.cust_id inner join  prod_dimen on market_fact.prod_id = prod_dimen.prod_id 
 where market_fact.prod_id in ( Select Prod_id   from Prod_dimen where product_sub_category = 'TABLES' )
group by cust_dimen.cust_id 

# --Task 3: Advanced Analysis
# --Write sql queries for the following:
# --A. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
Select Product_category, sum(profit) as profits from prod_dimen 
inner join market_fact on prod_dimen.prod_id =market_fact.prod_id
group by prod_dimen.Product_category  order by profits desc

# --B. Display the product category, product sub-category and the profit within each sub-category
# in three columns. 

Select Product_category,Product_sub_category, sum(profit) as profits from prod_dimen 
inner join market_fact on prod_dimen.prod_id =market_fact.prod_id
group by prod_dimen.Product_category, Product_sub_category order by profits desc

C. Where is the least profitable product subcategory shipped the most? 
#For the least profitable product sub-category, display the region-wise no_of_shipments and
# the profit made in each region in decreasing order of profits 
#(i.e. region, no_of_shipments, profit_in_each_region)

Select Region, count(ship_id) as no_of_shipments , sum(profit) as region_profit from cust_dimen 
inner join market_fact on cust_dimen.cust_id =market_fact.cust_id inner join  prod_dimen on market_fact.prod_id = prod_dimen.prod_id 
where prod_dimen.product_sub_category='TABLES'
 
group by region ,product_category
order by region_profit desc



# --o Note: You can hardcode the name of the least profitable product sub-category
