/*
		Sarthak
*/

/*			TASK1 A    */
/*The schema consists of five tables namelh cust_dimen,market_fact,orders_dimen,prod_dimen,shipping_dimen.
The CUST_DIMEN has information about customer where CUST_ID is the primary key, ORDERS_DIMEN table consist of
information about orders placed and ORD_ID is the primary key, PROD_DIMEN table consists of information about the 
products of superstore PROD_ID being the primary key,SHIPPING_DIMEN table consists of information about shipping information
with SHIP_ID being the primary key.
ORDERS_DIMEN AND SHIPPING_DIMEN share many to many relationship with ORDER_ID.
MARKET_FACT consists of maily of sale and marketing information with ORD_ID,PROD_ID,CUST_ID,SHIP_ID as the foreign key.
The relationship of CUST_DIMEN,ORDERS_DIMEN,PROD_DIMEN,SHIPPING_DIMEN with MARKET_FACT is one to many relationship ie
the foreign keys in that table are not unique.
Now about the operation part of this schema.CUST_DIMEN contains information about the customer, so the customer places
the order a unique ORD_ID is generated, a customer can place more than one order so under one ORDER_ID there may be several
ORD_ID.The product that the customer buys its information is stored in PROD_DIMEN. Now talking about the shipment, 
the info about the shipping information is stored in SHIPPING_DIMEN. Against the order placed the a unique SHIP_ID 
is created. A single ORDER_ID may have multiple SHIP_ID.
Talking about the MARKET_FACT, all the transaction that is occuring is stored in this table. This table has foreign
key to rest other tables. If there is requirment of looking into the insight then this can obtained from this table as
it contains information like sales,discount,profit etc.*/

-- Good Work...!!!, All the tables has been briefly described briefly along with their fields. The way relationships 
-- among the tables are exposed is Exceptional. Ambiguous fields are well identified. A brief mention of various fields data
-- types would have made your description indisputable. (90%)

/*  			TASK 1 B 			*/
/*
PRIMARY KEY=CUST_ID-CUST_DIMEN
			ORD_ID-ORDERS_DIMEN
			PROD_ID-PROD_DIMEN
			SHIP_ID-SHIPPING_DIMEN
FOREIGN KEY=CUST_ID-MARKET_FACT TO CUST_ID-CUST_DIMEN
			PROD_ID-MARKET_FACT TO PROD_ID-PROD_DIMEN
			ORD_ID-MARKET_FACT TO ORD_ID-ORDERS_DIMEN
			SHIP_ID-MARKET_FACT TO SHIP_ID-SHIPPING_DIMEN
MANY TO MANY RELATIONSHIP=ORDER_ID-ORDER_DIMEN TO ORDER_ID-SHIPPING_DIMEN  */

-- Awesome...!!! Primary Keys are identified for all dimension tables and Foreign keys from facts table.
-- The way foreigns keys are mapped to corresponding dimension tables is "Above and Beyond" expectations.





/*				TASK 2 A 				*/
SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS avg_sales
FROM
    market_fact;

-- Satisfied, No issues with command execution. SQL query probes market_fact table for 
--  total sales and avg sales, which is inline with expecations.





/*				TASK 2 B			*/
SELECT 
    region, COUNT(*) AS no_of_customers
FROM
    cust_dimen
GROUP BY region
ORDER BY no_of_customers DESC;

-- No issues with command execution. count('field') would be prefect fit, where count(*) counts all
-- records, we are interested in number of customers.
-- compare result for marks




/*				TASK 2 C 			*/
SELECT 
    region, COUNT(cust_id) AS no_of_customers
FROM
    cust_dimen
GROUP BY region
HAVING no_of_customers = (SELECT 
        MAX(countmax)
    FROM
        (SELECT 
            COUNT(cust_id) AS countmax
        FROM
            cust_dimen
        GROUP BY region) AS new_table);

-- Well done...!!!, Query executed sucessfully. Do you think of concise query ..?
--  Hint : task 2
-- 100% marks




/*				TASK 2 D			*/
SELECT 
    prod_id, SUM(order_quantity) AS no_of_products
FROM
    market_fact
GROUP BY prod_id
ORDER BY no_of_products DESC;

-- Good Work...!!!, command executed successfully. Results produced in decending order.




/*				TASK 2 E 			*/
SELECT 
    cd.customer_name, SUM(mf.order_quantity) AS no_of_tables
FROM
    cust_dimen AS cd
        INNER JOIN
    market_fact AS mf ON cd.cust_id = mf.cust_id
        INNER JOIN
    prod_dimen AS pd ON mf.Prod_id = pd.Prod_id
WHERE
    cd.Region = 'ATLANTIC'
        AND pd.Product_Sub_Category = 'TABLES'
GROUP BY mf.cust_id;

-- You nailed it...!!! you poked right tables with appropriate fields to generate this
-- summary. Food for thought..!!! can you give it a a try with out inner joins.




/*				TASK 3 A 			*/
SELECT 
    product_category, SUM(profit) AS profits
FROM
    prod_dimen AS pd
        INNER JOIN
    market_fact AS mf ON pd.Prod_id = mf.Prod_id
GROUP BY pd.Product_Category
ORDER BY profits DESC;

-- Good work...!!!, good to see you query prod_dimen and market_fact for desired results.
-- 100%




/*				TASK 3 B 		*/
SELECT 
    product_category,
    Product_Sub_Category,
    SUM(profit) AS profits
FROM
    prod_dimen AS pd
        INNER JOIN
    market_fact AS mf ON pd.Prod_id = mf.Prod_id
GROUP BY pd.Product_Category , pd.Product_Sub_Category;

-- Good work...!!! appropriate tables were queried for sub_category level profits.
-- 100%




/*				TASK 3 C 		*/
SELECT 
    cd.region,
    COUNT(mf.ship_id) AS no_of_shipments,
    SUM(mf.profit) AS profit_in_each_region
FROM
    market_fact AS mf
        INNER JOIN
    prod_dimen AS pd ON mf.Prod_id = pd.Prod_id
        INNER JOIN
    shipping_dimen AS sd ON mf.Ship_id = sd.Ship_id
        INNER JOIN
    cust_dimen AS cd ON mf.Cust_id = cd.Cust_id
WHERE
    pd.Product_Sub_Category = 'TABLES'
GROUP BY cd.Region
ORDER BY profit_in_each_region DESC;


-- Impressive...!!! you did it single query. command executed successfully and results produce are just as expected.
-- what's next...!!!, do you think you can give it a shot with out using inner joins.





/* Comments :  0%
		No comments were written, along with brief insights of results obtained with SQL Query, it would be
        good to have Question as header. Comments/Headers would always help to recite your work in future.

	New Variables : 
		Good work...!!! New variables created has unambiguous names.
        
	Code Concisely : 70%
		Satisfied, Its extremely important to be as precise as possible for complex analysis, for your
        reference, please refer below reference for task 3.c
        
    Code Redability : 50%
		Could do better. Its always better to indent code for better redability. if you are using SQL workbench 
        you can use shortcuts like 'ctrl+b' for indentation and 'ctrl+/' for commenting. you can give it a try
        and see the difference for your self
        
		
*/
