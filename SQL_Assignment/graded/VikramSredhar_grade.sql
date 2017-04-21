/*
					VikramSredhar
*/


 # Understanding Data Task 1 - A

# The database represents sales data of a retail chain super stores.  Database has 5 tables which have customer data
# Order sales and Profitablity in Market fact, Orders priority, date in orders dimension, product category & sub category 
# and shipping data relating to shipping mode and date of shipping.  In Cust_dimen table all fields are text, In Market_fact
# table primary keys are numbers with double decimel and Foreign keys are text. In Orders_dimen table Order ID is an integer
# of 11 numbers and other fields are text. In Prod_dimen and Shipping_dimen table all primary keys are text  

 # Understanding Data Task 1 - B
 
 # Table `cust_dimen` - Primary Key (Cust_Id, Customer_Segment, Customer_Name, Province & Region)
 # Table `market_fact`- Primary Key (Order_Quantity, Sales, Discount, Profit, Shipping_Cost, Product_Base Margin)
 # Table `market_fact`- Foreign Key (Ord_id,Prod_id,Ship_id,Cust_id)
 # Table `orders_dimen` - Primary Key (Order_ID, Order_Date, Order_Priority, Ord_id)
 # Table `prod_dimen` - Primary Key (Prod_id, Product_Sub_Category, Product_Category)
 # Table `shipping_dimen` - Primary Key (Ship_Mode, Ship_Date, Ship_id)
 # Table `shipping_dimen` - Foreign Key (Order_ID)
 
# Basic Analysis - A

SELECT 
    SUM(Sales) AS total_sales
FROM
    market_fact;






  
SELECT 
    AVG(Sales) AS avg_sales
FROM
    market_fact;





# Basic Analysis - B
    
SELECT 
    Region, COUNT(Cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC;





# Basic Analysis - C

SELECT 
    Region, COUNT(Cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC
LIMIT 1;





#Basic Analysis - D

SELECT 
    Prod_id, SUM(Order_Quantity) AS no_of_Products
FROM
    market_fact
GROUP BY Prod_id
ORDER BY no_of_Products DESC;





# Basic Analysis - E

SELECT 
    T2.Customer_Name, SUM(Order_Quantity) AS no_of_tables
FROM
    market_fact AS T1
        INNER JOIN
    cust_dimen AS T2 ON T1.Cust_id = T2.Cust_id
        INNER JOIN
    prod_dimen AS T3 ON T1.Prod_id = T3.Prod_id
WHERE
    T3.Product_Sub_Category = 'TABLES'
GROUP BY T2.Customer_Name;





# Advanced Analysis - A

SELECT 
    T2.Product_Category, SUM(T1.Profit) AS Profits
FROM
    market_fact AS T1
        INNER JOIN
    prod_dimen AS T2 ON T1.Prod_id = T2.Prod_id
GROUP BY T2.Product_Category
ORDER BY Profits DESC;





# Advanced Analysis - B

SELECT 
    T2.Product_Category,
    T2.Product_Sub_Category,
    SUM(T1.Profit) AS Profits
FROM
    market_fact AS T1
        INNER JOIN
    prod_dimen AS T2 ON T1.Prod_id = T2.Prod_id
GROUP BY T2.Product_Category , T2.Product_Sub_Category;





# Advanced Analysis - C 

SELECT 
    T3.Region,
    SUM(T1.Profit) AS Profits,
    COUNT(Ship_Mode) AS no_of_shipments
FROM
    market_fact AS T1
        INNER JOIN
    prod_dimen AS T2 ON T1.Prod_id = T2.Prod_id
        INNER JOIN
    cust_dimen AS T3 ON T1.Cust_id = T3.Cust_id
        INNER JOIN
    shipping_dimen AS T4 ON T1.Ship_id = T4.Ship_id
WHERE
    Product_Sub_Category = 'TABLES'
GROUP BY T3.Region
ORDER BY Profits DESC;