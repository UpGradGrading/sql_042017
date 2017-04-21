/*
		srikanth kowtha



﻿/* Task 0:

 performed all the steps  for all the files shared 


Task 1:
We  have five tables after TASK 0  ,OF which four are DIMENSION tables and ifth  is a fact TABLE
WHERE  DIMENSION TABLE refers TO the ANY OBJECT which keeps changing OVER a PERIOD OF TIME.
&&
 Fact tables are desinged IN a way TO caluclate the fact VALUES FROM the DIMENSION tables.

Thus TO maintain connectivity BETWEEN The Fact TABLE AND DIMENSION tables ,
we need TO have Refrential Integrity {PRIMARY KEY-FOREIGN KEY  relationship} BETWEEN FACT AND 
DIMENSION tables.
Nothing but to have all the primary keys of dimension tables to set as  foreign keys in FACT table.

So that the FACT TABLE will act AS Bridge TABLE AND  provide us required aggreagte and  summaries
 by doing necessary joins



DIMENSION tables :  cust_dimen , Orders_dimen,prod_dimen,shipping_dimen
Fact TABLE : Market_fact



cust_dimen : 
PRIMARY KEY : Cust_id

prod_dimen  : 
primanry KEY : Prod_id

market_fact:
PRIMARY KEY :   (Cust_id,Ord_id,Prod_id,ship_id)  
FOREIGN KEY : (Cust_id ON cust_dimen TABLE  ,Ord_id ON orders_dimen TABLE ,Prod_id ON prod_dimen TABLE,ship_id ON shipping_dimen TABLE)



Imagine a CASE WHERE there is  a shippement regeistered IN shipping_dimen
WITH NO corresponding ORDER IN order_dimen, which IS NOT correct.

Thus there  should be refrential integrity CHECK  BETWEEN orders DIMENSION AND shipping DIMENSION.
so that ONLY orders that were present IN orders_dimen will be IN shipping dimen TABLE.

So ,IF we want TO CREATE a FOREIGN KEY CONSTRAINT BETWEEN the two tables, 
the child TABLE would have TO have ALL the COLUMNS that comprise the PRIMARY KEY CONSTRAINT 
ON the PARENT TABLE

TO achieve this  we need TO have composite KEY ON {ord_id AND order_id} IN order_dimen TABLE.
also we need TO ADD ord_id COLUMN IN child TABLE shipping_dimen.
now the composite KEY FOR TABLE shipping_dimen will be {ship_id AND order_id}

orders_dimen:
PRIMARY KEY : {ord_id AND order_id}

shipping_dimen:
COLUMNS IN shipping_dimen: Order_id,Ship_Mode,Ship_Date,Ship_id,ord_id
PRIMARY KEY : {ship_id AND order_id}
FOREIGN KEY :  {order_id ON orders_dimen}

*/
SELECT 
    SUM(sales) AS total_sales,
    SUM(sales) / COUNT(sales) AS avg_sales
FROM
    market_fact;










SELECT 
    region AS Region, COUNT(cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY 1
ORDER BY 2 DESC;







SELECT 
    region AS Region, COUNT(cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;













SELECT 
    A.Region, A.no_of_customers
FROM
    (SELECT 
        region AS Region, COUNT(cust_id) AS no_of_customers
    FROM
        cust_dimen
    GROUP BY 1) A
WHERE
    A.no_of_customers = (SELECT 
            MAX(CNT) AS no_of_customers
        FROM
            (SELECT 
                region AS Region, COUNT(cust_id) AS CNT
            FROM
                cust_dimen
            GROUP BY 1) A);










SELECT 
    prod_id AS product_id, SUM(order_quantity) AS no_of_products
FROM
    market_fact
GROUP BY 1
ORDER BY 2 DESC;













SELECT 
    c.customer_name AS customer_name,
    SUM(m.order_quantity) AS no_of_tables_purchased
FROM
    cust_dimen AS c
        INNER JOIN
    market_fact AS m ON c.cust_id = m.cust_id
        AND c.region = 'Atlantic'
        INNER JOIN
    prod_dimen p ON p.prod_id = m.prod_id
        AND p.product_sub_category = 'Tables'
GROUP BY 1
ORDER BY 2 DESC;















SELECT 
    p.product_category AS product_category,
    SUM(m.profit) AS profits
FROM
    prod_dimen AS p
        INNER JOIN
    market_fact AS m ON m.prod_id = p.prod_id
GROUP BY 1
ORDER BY 2 DESC;











SELECT 
    p.product_category AS product_category,
    p.Product_Sub_Category AS product_sub_category,
    SUM(m.profit) AS profit
FROM
    prod_dimen AS p
        INNER JOIN
    market_fact AS m ON m.prod_id = p.prod_id
GROUP BY 1 , 2
ORDER BY 1 DESC , 2 DESC;






 



SELECT 
    p.Product_Sub_Category, MIN(m.profit)
FROM
    prod_dimen AS p
        INNER JOIN
    market_fact AS m ON m.prod_id = p.prod_id
GROUP BY 1
ORDER BY 2
LIMIT 1;






/*OFFICE MACHINES is the LEAST profitable product subcategory shipped the most*/








  
SELECT 
    c.region AS region,
    COUNT(m.ship_id) AS no_of_shipments,
    SUM(m.profit) AS profit_in_each_region
FROM
    market_fact AS m
        INNER JOIN
    cust_dimen AS c ON c.cust_id = m.cust_id
        INNER JOIN
    prod_dimen AS p ON p.prod_id = m.prod_id
        AND p.Product_Sub_Category = 'OFFICE MACHINES'
GROUP BY 1
ORDER BY 3 DESC;





