/*
		Anugraha Sinha
*/


## TASK 1 : Understanding the data in hand ##
   ## TABLE cust_dimen ##
   ## COLUMN Cust_id  -> VARCHAR(25) -> Primary Key
   #----------------------------------------------------------------------#
   ## TABLE prod_dimen ##
   ## COLUMN Prod_id  -> VARCHAR(25) -> Primary Key
   #----------------------------------------------------------------------#
   ## TABLE order_dimen ##
   ## COLUMN Ord_id   -> VARCHAR(25) -> Primary Key
   ## COLUMN Order_ID -> VARCHAR(25) -> INDEXED
   #----------------------------------------------------------------------#
   ## TABLE shipping_dimen ##
   ## COLUMN Ship_id  -> VARCHAR(25) -> PRIMARY KEY
   ## COLUMN Order_id -> VARCHAR(25) -> FOREIGN KEY REFER TO order_dimen.Order_ID
   #----------------------------------------------------------------------#
   ## TABLE market_fact ##
   ## COLUMN Ord_id   -> VARCHAR(25) -> FOREIGN KEY REFER TO orders_dimen.Ord_id
   ## COLUMN Prod_id  -> VARCHAR(25) -> FOREIGN KEY REFER TO prod_dimen.Prod_id
   ## COLUMN Ship_id  -> VARCHAR(25) -> FOREIGN KEY REFER TO -> shipping_dimen.Ship_id
   ## COLUMN Cust_id  -> VARCHAR(25) -> FOREIGN KEY REFER TO cust_dimen.Cust_id

## Task 2 : Basic Analysis ##
   ## Q1) Find the total and the average sales (display total_sales and avg_sales)
  SELECT 
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(AVG(Sales), 2) AS avg_sales
FROM
    market_fact;
   




SELECT 
    Region, COUNT(*) AS no_of_customer
FROM
    cust_dimen
GROUP BY Region
ORDER BY no_of_customer DESC;
   




SELECT 
    Region, COUNT(*) AS 'max(no_of_customer)'
FROM
    cust_dimen
GROUP BY Region
HAVING `max(no_of_customer)` = (SELECT 
        MAX(t1.no_of_customer)
    FROM
        (SELECT 
            Region, COUNT(*) AS 'no_of_customer'
        FROM
            cust_dimen
        GROUP BY Region) t1);
   




SELECT 
    Prod_id AS 'product id',
    SUM(Order_Quantity) AS 'no_of_products sold'
FROM
    market_fact
GROUP BY Prod_id
ORDER BY `no_of_products sold` DESC;
   




SELECT 
    t2.Customer_Name AS 'customer name',
    SUM(t1.Order_Quantity) AS 'no_of_tables'
FROM
    market_fact t1
        RIGHT JOIN
    (SELECT 
        Customer_Name, Cust_id
    FROM
        cust_dimen
    WHERE
        Region = 'Atlantic') t2 ON t1.Cust_id = t2.Cust_id
WHERE
    t1.Prod_id = (SELECT 
            Prod_id
        FROM
            prod_dimen
        WHERE
            Product_Sub_Category LIKE '%TABLES%')
GROUP BY t1.Cust_id;
   




SELECT 
    t1.Product_Category AS 'product_category',
    SUM(t2.profits) AS 'profits'
FROM
    prod_dimen t1
        LEFT JOIN
    (SELECT 
        Prod_id, ROUND(SUM(Profit), 2) AS 'profits'
    FROM
        market_fact
    GROUP BY Prod_id) t2 ON t1.Prod_id = t2.Prod_id
GROUP BY t1.Product_Category
ORDER BY `profits` DESC;
   




SELECT 
    t1.Product_Category AS 'product_category',
    t1.Product_Sub_Category AS 'product_sub_category',
    SUM(t2.profits) AS 'profits'
FROM
    prod_dimen t1
        LEFT JOIN
    (SELECT 
        Prod_id, ROUND(SUM(Profit), 2) AS 'profits'
    FROM
        market_fact
    GROUP BY Prod_id) t2 ON t1.Prod_id = t2.Prod_id
GROUP BY t1.Product_Category , t1.Product_Sub_Category;





   
SELECT 
    t2.Region AS 'region',
    COUNT(t1.Ship_id) AS 'no_of_shipment',
    ROUND(SUM(t1.Profit), 2) AS 'profit_in_each_region'
FROM
    market_fact t1
        LEFT JOIN
    cust_dimen t2 ON t1.Cust_id = t2.Cust_id
WHERE
    t1.Prod_id = (SELECT 
            Prod_id
        FROM
            prod_dimen
        WHERE
            Product_Sub_Category LIKE '%TABLE%')
GROUP BY t2.Region
ORDER BY `profit_in_each_region` DESC;
   
   