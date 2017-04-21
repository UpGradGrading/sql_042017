/* Name - Dhir Chandan --- Roll - DDA1710293 --- Task - SQL Graded Assignment */

SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS avg_sales
FROM
    superstoresdb.market_fact;								/* using aggregrate functions SUM() and AVG() to get the total and avegrage of sales*/





SELECT 
    Region, COUNT(Cust_id) AS no_of_customers
FROM
    superstoresdb.cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC;						/* aggregating customer ID to COUNT and grouping based ON region */





/* Task 2 C */


SELECT Region, COUNT(Cust_id) max_no_of_customers   /* query to get region with max number of customers*/
FROM cust_dimen   
GROUP BY Region
ORDER BY mycount DESC LIMIT 1						/* sort IN descending ORDER and using LIMIT here to get region with max customers. Here TOP can also be used*/





/* Task 2 D */

SELECT prod_id, SUM(Order_Quantity) AS no_of_products_sold
FROM superstoresdb.market_fact 
GROUP BY Prod_id 
ORDER BY no_of_products_sold DESC;								/* Grouping the result set based ON product ID and aggregating BY SUM of quantities to get the total number of each product sold and sort IN descending ORDER of COUNT*/





SELECT 
    Cust_id, SUM(Order_Quantity) AS no_of_tables
FROM
    superstoresdb.market_fact
WHERE
    Cust_id IN (SELECT 
            cust_id
        FROM
            cust_dimen
        WHERE
            Region = 'atlantic')
        AND Prod_id IN (SELECT 
            Prod_id
        FROM
            prod_dimen
        WHERE
            Product_Sub_Category = 'tables')
GROUP BY Cust_id
ORDER BY no_of_tables DESC;																/* grouping BY customer id and aggregating BY SUM of ORDER quantities to get no. of tables per customer */





SELECT 
    p.Product_Category, SUM(m.Profit) AS Profits
FROM
    market_fact m
        JOIN
    prod_dimen p ON m.prod_id = p.Prod_id
GROUP BY Product_Category
ORDER BY Profits DESC;														/* sorting in decreasing ORDER of profits */





SELECT 
    p.Product_Category,
    p.Product_Sub_Category,
    (m.Profit) AS Profits
FROM
    market_fact m
        JOIN
    prod_dimen p ON m.prod_id = p.Prod_id
GROUP BY Product_Sub_Category
ORDER BY Profits DESC;														/* sorting in decreasing ORDER of profits */





SELECT 
    Region,
    COUNT(Ship_id) AS no_of_shipments,
    SUM(Profit) AS profit_in_each_region
FROM
    market_fact m
        JOIN
    prod_dimen p ON m.prod_id = p.Prod_id
        JOIN
    cust_dimen c ON m.Cust_id = c.Cust_id
WHERE
    Product_Sub_Category = 'STORAGE & ORGANIZATION'
GROUP BY Region
ORDER BY profit_in_each_region DESC;  																	/* ordering in decreasing order of profits per region */
