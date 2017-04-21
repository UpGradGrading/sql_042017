/*
		Abdul rahiman bangara
*/





SELECT 
    SUM(sales), AVG(sales)
FROM
    market_fact;






-- B. Display the number of customers in each region in decreasing order of
-- no_of_customers. The result should be a table with columns Region,
-- no_of_customers

SELECT 
    Region, COUNT(*) AS no_of_customers
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(*) DESC;






-- C. Find the region having maximum customers (display the region name and
-- max(no_of_customers)

SELECT 
    sub_table.Region,
    MAX(sub_table.no_of_customers) AS no_of_customers
FROM
    (SELECT 
        Region, COUNT(*) AS no_of_customers
    FROM
        cust_dimen
    GROUP BY Region
    ORDER BY COUNT(*) DESC) AS sub_table;






-- D. Find the number and id of products sold in decreasing order of products sold (display
-- product id, no_of_products sold)

SELECT 
    Prod_id, SUM(order_quantity) AS no_of_products_sold
FROM
    market_fact
GROUP BY Prod_id
ORDER BY SUM(order_quantity);






-- E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and
-- the number of tables purchased (display the customer name, no_of_tables
-- purchased) 

SELECT 
    cd.Customer_Name,
    SUM(mf.Order_Quantity) AS no_of_tables_purchased
FROM
    cust_dimen cd
        INNER JOIN
    market_fact mf ON cd.Cust_id = mf.Cust_id
        INNER JOIN
    prod_dimen pd ON mf.Prod_id = pd.Prod_id
WHERE
    pd.Product_Sub_Category = 'TABLES'
        AND cd.Region = 'Atlantic'
GROUP BY cd.Customer_Name;






-- Task 3: Advanced Analysis
-- Write sql queries for the following:
-- A. Display the product categories in descending order of profits (display the product
-- category wise profits i.e. product_category, profits)?

SELECT 
    pd.Product_Category, mf.Profit
FROM
    prod_dimen pd
        INNER JOIN
    market_fact mf ON pd.Prod_id = mf.Prod_id
GROUP BY pd.Product_Category
ORDER BY mf.Profit DESC;






-- B. Display the product category, product sub-category and the profit within each subcategory
-- in three columns.

SELECT 
    pd.Product_Category, pd.Product_Sub_Category, mf.Profit
FROM
    prod_dimen pd
        INNER JOIN
    market_fact mf ON pd.Prod_id = mf.Prod_id
GROUP BY pd.Product_Category , pd.Product_Sub_Category;






-- C. Where is the least profitable product subcategory shipped the most? For the least
-- profitable product sub-category, display the region-wise no_of_shipments and the
-- profit made in each region in decreasing order of profits (i.e. region,
-- no_of_shipments, profit_in_each_region)
-- o Note: You can hardcode the name of the least profitable product subcategory

SELECT 
    cd.region, COUNT(sd.Ship_id) AS no_of_shipments, mf.Profit
FROM
    shipping_dimen sd
        INNER JOIN
    market_fact mf ON sd.Ship_id = mf.Ship_id
        INNER JOIN
    cust_dimen cd ON mf.Cust_id = cd.Cust_id
        INNER JOIN
    prod_dimen pd ON mf.Prod_id = pd.Prod_id
WHERE
    pd.Product_Sub_Category = 'STORAGE & ORGANIZATION'
GROUP BY cd.Region
ORDER BY mf.Profit DESC;






-- Important Note:
-- Submit your answers for all these tasks in a .sql file.