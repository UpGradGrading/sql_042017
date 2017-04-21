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
SELECT 
    SUM(sales), AVG(sales)
FROM
    market_fact;





SELECT 
    Region, COUNT(cust_id) AS custcount
FROM
    cust_dimen
GROUP BY region
ORDER BY custcount DESC;




# --C. Find the region having maximum customers (display the region name and max(no_of_customers)


select Region , count(cust_id) as custcount from cust_dimen group by region order by custcount desc limit 0,1





# --D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products_sold)
select prod_id , sum(order_quantity) no_of_tables purchased  as no_of_products_sold from market_fact  group by prod_id order by no_of_products_sold desc;




SELECT 
    Customer_Name, SUM(Order_quantity)
FROM
    cust_dimen
        INNER JOIN
    market_fact ON cust_dimen.cust_id = market_fact.cust_id
        INNER JOIN
    prod_dimen ON market_fact.prod_id = prod_dimen.prod_id
WHERE
    market_fact.prod_id IN (SELECT 
            Prod_id
        FROM
            Prod_dimen
        WHERE
            product_sub_category = 'TABLES')
GROUP BY cust_dimen.cust_id;





SELECT 
    Product_category, SUM(profit) AS profits
FROM
    prod_dimen
        INNER JOIN
    market_fact ON prod_dimen.prod_id = market_fact.prod_id
GROUP BY prod_dimen.Product_category
ORDER BY profits DESC;





SELECT 
    Product_category,
    Product_sub_category,
    SUM(profit) AS profits
FROM
    prod_dimen
        INNER JOIN
    market_fact ON prod_dimen.prod_id = market_fact.prod_id
GROUP BY prod_dimen.Product_category , Product_sub_category
ORDER BY profits DESC;





SELECT 
    Region,
    COUNT(ship_id) AS no_of_shipments,
    SUM(profit) AS region_profit
FROM
    cust_dimen
        INNER JOIN
    market_fact ON cust_dimen.cust_id = market_fact.cust_id
        INNER JOIN
    prod_dimen ON market_fact.prod_id = prod_dimen.prod_id
WHERE
    prod_dimen.product_sub_category = 'TABLES'
GROUP BY region , product_category
ORDER BY region_profit DESC;



# --o Note: You can hardcode the name of the least profitable product sub-category
