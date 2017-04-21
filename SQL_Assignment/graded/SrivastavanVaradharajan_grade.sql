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




SELECT 
    SUM(Sales) AS Total_Sales, AVG(Sales) AS Average_Sales
FROM
    market_fact;





SELECT 
    Region, COUNT(Cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY Region;





SELECT 
    Region, COUNT(Cust_id) AS 'max(no of customers)'
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(Cust_id) DESC
LIMIT 1;





SELECT 
    prod_id, COUNT(*) AS no_of_products_sold
FROM
    market_fact
GROUP BY Prod_id
ORDER BY no_of_products_sold DESC;





SELECT 
    c.Customer_Name, m.Order_Quantity AS no_of_tables_purchased
FROM
    market_fact m
        LEFT OUTER JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
        LEFT OUTER JOIN
    cust_dimen c ON m.Cust_id = c.Cust_id
WHERE
    p.Product_Sub_Category = 'TABLES'
        AND c.Region = 'ATLANTIC';






SELECT 
    p.Product_Category, m.Profit AS profits
FROM
    market_fact m
        LEFT OUTER JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
GROUP BY p.Product_Category
ORDER BY profits DESC;





SELECT 
    p.Product_Category,
    p.Product_Sub_Category,
    m.Profit AS profits
FROM
    market_fact m
        LEFT OUTER JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
GROUP BY p.Product_Category , p.Product_Sub_Category;





SELECT 
    c.Region,
    COUNT(DISTINCT (s.Ship_id)) AS no_of_shipments,
    SUM(m.Profit) AS profit_in_each_region
FROM
    market_fact m
        LEFT OUTER JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
        LEFT OUTER JOIN
    shipping_dimen s ON m.Ship_id = s.Ship_id
        LEFT OUTER JOIN
    cust_dimen c ON m.Cust_id = c.Cust_id
WHERE
    p.Product_Sub_Category = 'STORAGE & ORGANIZATION'
GROUP BY c.Region
ORDER BY profit_in_each_region DESC;
