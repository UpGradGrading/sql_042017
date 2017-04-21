/*
		Sarthak
*/

SELECT 
    SUM(sales) AS total_sales, AVG(sales) AS avg_sales
FROM
    market_fact;

-- Satisfied, No issues with command execution. SQL query probes market_fact table for 
--  total sales and avg sales, which is inline with expecations.





SELECT 
    region, COUNT(*) AS no_of_customers
FROM
    cust_dimen
GROUP BY region
ORDER BY no_of_customers DESC;

-- No issues with command execution. count('field') would be prefect fit, where count(*) counts all
-- records, we are interested in number of customers.
-- compare result for marks




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




SELECT 
    prod_id, SUM(order_quantity) AS no_of_products
FROM
    market_fact
GROUP BY prod_id
ORDER BY no_of_products DESC;

-- Good Work...!!!, command executed successfully. Results produced in decending order.




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
