/*

			Naga Shaktidhar
*/


#--Task 1: Understanding the data in hand
#--A. Describe the data in hand in your own words. (Word Limit is 500)
#-- The data has 4 Dimenssion tables with master data and 1 fact table with transaciton data
#-- Market_fact is the transaction data; there are few  NA Values in this table
#-- All the Dimession tables Product, Customer, Orders and shipments are having master data with more attributes
#--
#--B. Identify and list the Primary Keys and Foreign Keys for this dataset
#-- Cust_dimen - Primary Key - cust_id ; 
#-- Orders_dimen - Primary Key - ord_id 
#-- Prod_dimen - Primary Key - Prod_id 
#-- shipping_dimen - Primary Key - Ship_id
#-- market_fact - Primary Key - Combination of (Ord_id, Prod_id, Ship_id, Cust_id,Order_Quantity) 
#-- market_fact - Foreign Keys -  Ord_id (Table Orders_dimen), Prod_id (Table Prod_dimen), Ship_id (Table shipping_dimen), ord_id (table ord_id) 
#--



#--Task 2: Basic Analysis
#--Write the SQL queries for the following:
#--A. Find the total and the average sales (display total_sales and avg_sales)

SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS avg_sales
FROM
    market_fact;





SELECT 
    Region, COUNT(cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC;





SELECT 
    Region, MAX(no_of_customers)
FROM
    (SELECT 
        Region, COUNT(cust_id) AS no_of_customers
    FROM
        cust_dimen
    GROUP BY Region
    ORDER BY no_of_customers DESC) AS RegionCustomers;






SELECT 
    Prod_id AS 'product id',
    SUM(Order_Quantity) AS no_of_products_sold
FROM
    market_fact
GROUP BY Prod_id
ORDER BY no_of_products_sold DESC;





SELECT 
    cd.Customer_Name, SUM(mf.Order_Quantity) AS no_of_tables
FROM
    market_fact mf
        INNER JOIN
    prod_dimen pd ON mf.prod_id = pd.prod_id
        INNER JOIN
    cust_dimen cd ON mf.Cust_id = cd.Cust_id
WHERE
    pd.Product_Sub_Category = 'TABLES'
        AND cd.Region = 'ATLANTIC'
GROUP BY cd.Customer_Name;
                        
   



                     
SELECT 
    pd.Product_Category, SUM(mf.Profit) AS Profits
FROM
    market_fact mf
        INNER JOIN
    prod_dimen pd ON mf.prod_id = pd.prod_id
GROUP BY pd.Product_Category
ORDER BY Profits;





SELECT 
    pd.Product_Category,
    pd.Product_Sub_Category,
    SUM(mf.Profit) AS Profits
FROM
    market_fact mf
        INNER JOIN
    prod_dimen pd ON mf.prod_id = pd.prod_id
GROUP BY pd.Product_Category , pd.Product_Sub_Category
ORDER BY Profits;





SELECT 
    cd.Region,
    COUNT(sd.Ship_id) AS no_of_shipments,
    SUM(mf.Profit) AS profit_in_each_region
FROM
    market_fact mf
        INNER JOIN
    prod_dimen pd ON mf.prod_id = pd.prod_id
        INNER JOIN
    cust_dimen cd ON mf.Cust_id = cd.Cust_id
        INNER JOIN
    shipping_dimen sd ON mf.Ship_id = sd.Ship_id
WHERE
    pd.Product_Sub_Category = 'TABLES'
GROUP BY cd.Region
ORDER BY profit_in_each_region;
                  

