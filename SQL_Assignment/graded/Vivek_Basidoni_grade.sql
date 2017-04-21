/*
				Vivek Basidoni
*/

SELECT 
    SUM(Sales) AS total_sale, AVG(Sales) AS avg_sale
FROM
    superstoresdb.market_fact;






/*
Display the number of customers in each region in decreasing order of no_of_customers.
 The result should be a table with columns Region, no_of_customer
*/
SELECT 
    COUNT(*) no_of_customers, Region
FROM
    superstoresdb.cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC;





/*
Find the region having maximum customers (display the region name and max(no_of_customers)
*/
(SELECT 
    COUNT(*) AS no_of_customers, Region
FROM
    cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC
LIMIT 0 , 1);





/*
Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold
*/
SELECT 
    Prod_id AS product_id, COUNT(Prod_id) AS no_of_products
FROM
    market_fact
GROUP BY Prod_id
ORDER BY no_of_products DESC;





/*
Find all the customers from Atlantic region who have ever purchased 
‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)
*/
(SELECT 
    CD.Customer_Name, COUNT(*) AS no_of_tables_purchased
FROM
    market_fact MF
        INNER JOIN
    prod_dimen PD ON MF.Prod_id = PD.Prod_id
        INNER JOIN
    cust_dimen CD ON MF.Cust_id = CD.Cust_id
WHERE
    PD.Product_Sub_Category = 'Tables'
        AND CD.Region = 'Atlantic'
GROUP BY CD.Customer_Name
ORDER BY no_of_tables_purchased DESC);





/*
Display the product categories in descending order of profits 
(display the product category wise profits i.e. product_category, profits)
*/
(SELECT 
    PD.Product_Category, SUM(Profit) profits
FROM
    market_fact MF
        INNER JOIN
    superstoresdb.prod_dimen PD ON MF.Prod_id = PD.Prod_id
GROUP BY PD.Product_Category
ORDER BY profits DESC);





/*
Display the product category, product sub-category and the profit within each subcategory in three column
*/
(SELECT 
    PD.Product_Category,
    PD.Product_Sub_Category,
    (Profit) profits
FROM
    market_fact MF
        INNER JOIN
    superstoresdb.prod_dimen PD ON MF.Prod_id = PD.Prod_id
GROUP BY PD.Product_Category , PD.Product_Sub_Category
ORDER BY profits DESC);





/*
Where is the least profitable product subcategory shipped the most?
 For the least profitable product sub-category, display the 
 region-wise no_of_shipments and the profit made in each region in decreasing order of profits 
 (i.e. region, no_of_shipments, profit_in_each_region
*/
(SELECT 
    SUM(MF.Profit) AS profit, PD.Product_Sub_Category, CD.Region
FROM
    superstoresdb.market_fact MF
        INNER JOIN
    cust_dimen CD ON MF.Cust_id = CD.Cust_id
        INNER JOIN
    prod_dimen PD ON MF.Prod_id = PD.Prod_id
GROUP BY PD.Product_Sub_Category
ORDER BY profit ASC);






(SELECT 
    CD.Region,
    COUNT(*) AS no_of_shipments,
    SUM(Profit) AS profit_in_each_region
FROM
    market_fact MF
        INNER JOIN
    cust_dimen CD ON MF.Cust_id = CD.Cust_id
        INNER JOIN
    prod_dimen PD ON MF.Prod_id = PD.Prod_id
WHERE
    PD.Product_Sub_Category = 'TABLES'
GROUP BY Region);

