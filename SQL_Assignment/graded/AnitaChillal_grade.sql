/*
		Anita Chillal
*/

## Task 1
## This is a database for superstore.
## Fact table- Market
## Dimentions- 1) Cust Primary key- Cust_id
## 			   2) Product Primary key-Prod_id
##			   3) Shipping Primary key- Ship_id using order_id from orders dimension
##			   4) Orders Primary key-Ord_id Order_id column is foreign key for shipping dimension
## All these are used as foreign keys in Market fact table.


use superstoresdb;
describe cust_dimen;
describe orders_dimen;
describe shipping;

SELECT 
    SUM(Sales) AS total_sales, AVG(sales) AS avg_sales
FROM
    Market_fact;
    



    
SELECT 
    region, COUNT(cust_id) AS Number_of_customers
FROM
    cust_dimen
GROUP BY region
ORDER BY Number_of_customers DESC;





SELECT 
    region, MAX(Number_of_customers)
FROM
    (SELECT 
        region, COUNT(cust_id) AS Number_of_customers
    FROM
        cust_dimen
    GROUP BY region) Customer_count;






SELECT 
    prod_id, SUM(order_quantity) Num_of_products_sold
FROM
    market_fact
GROUP BY prod_id
ORDER BY Num_of_products_sold DESC;





SELECT 
    cust.customer_name,
    SUM(order_quantity) AS Number_of_tables_purchased
FROM
    market_fact mar
        INNER JOIN
    cust_dimen cust ON mar.cust_id = cust.cust_id
        INNER JOIN
    prod_dimen prod ON mar.prod_id = prod.prod_id
WHERE
    cust.region = 'ATLANTIC'
        AND prod.product_sub_category = 'TABLES'
GROUP BY cust.customer_name;





SELECT 
    prod.product_category, SUM(profit) profit_made
FROM
    market_fact mar
        INNER JOIN
    prod_dimen prod ON mar.prod_id = prod.prod_id
GROUP BY prod.product_category
ORDER BY profit_made DESC;





SELECT 
    prod.product_category,
    prod.product_sub_category,
    SUM(profit) profit
FROM
    market_fact mar
        INNER JOIN
    prod_dimen prod ON mar.prod_id = prod.prod_id
GROUP BY prod.product_sub_category;





SELECT 
    product_sub_category, MIN(profit) least_profit
FROM
    (SELECT 
        prod.product_category,
            prod.product_sub_category,
            SUM(profit) profit
    FROM
        market_fact mar
    INNER JOIN prod_dimen prod ON mar.prod_id = prod.prod_id
    GROUP BY prod.product_sub_category) sub_category_wise_profit;




SELECT 
    cust.region,
    COUNT(mar.ship_id) No_of_shipments,
    SUM(profit) AS profit_made
FROM
    market_fact mar
        INNER JOIN
    cust_dimen cust ON mar.cust_id = cust.cust_id
        INNER JOIN
    shipping_dimen ship ON mar.ship_id = ship.ship_id
GROUP BY cust.region
ORDER BY profit_made DESC;

