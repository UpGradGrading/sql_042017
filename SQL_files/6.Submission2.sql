-- -----------------------------------------------------------------
				-- Task 1: Understanding the data in hand
-- -----------------------------------------------------------------

-- A. Describe the data in hand in your own words. (Word Limit is 500)

/*   On a very high level the superstore database (schema) consist of 
	 four dimension tables and a fact table.  The four dimension tables 
	 are having a entities for customer, orders, product and shipping. 
	 The fact table is containing data about business facts (measures) 
	 like product sales, profit , discount , shipping cost etc.
	 On this data we can apply basic analytics and find out some of 
	 very interesting trends likes the like which category of products 
	 is doing really well, and which has some opportunities. 
	 This transitional data is very helpful for “Descriptive analytics”.
*/

-- B. Identify and list the Primary Keys and Foreign Keys for this dataset
/*
	Table ->cust_dimen
	Primary Keys -> Cust_Id
	Foreign Keys -> NA


	Table ->orders_dimen
	Primary Keys -> Ord_id (Note - In orders_dimen table I can see two unique  keys 
	Order_ID and Ord_id and hence any one of them can be a primary key. For alter
	a consistency purpose  I have chosen ord_Id over order_ID).
	Foreign Keys -> NA

	Table ->prod_dimen
	Primary Keys -> Prod_id
	Foreign Keys -> NA

	Table ->shipping_dimen
	Primary Keys -> Ship_id
	Foreign Keys -> NA

	Table ->market_fact
	Primary Keys -> surrogate key, I believe we don’t have any Primary key 
	and hence will suggest to create one "Auto generated" column as 
	Primary Keys.
	Foreign Keys -> Cust_id, Ord_Id, Prod_Id and Ship_id

*/

-- -----------------------------------------------------------------
				-- Task 2: Basic Analysis
-- -----------------------------------------------------------------
-- A. Find the total and the average sales 
-- (display total_sales and avg_sales)
SELECT 
    SUM(sales) AS total_sales, AVG(Sales) AS avg_sales
FROM
    market_fact;

-- B. Display the number of customers in each region in decreasing order 
-- of no_of_customers. The result should be a table with columns 
-- Region, no_of_customers
SELECT 
    Region, COUNT(*) AS no_of_customers
FROM
    cust_dimen
		GROUP BY Region
		ORDER BY no_of_customers DESC;

-- C. Find the region having maximum customers 
-- (display the region name and max(no_of_customers)
SELECT 
    Region, COUNT(*) AS no_of_customers
FROM
    cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC
LIMIT 1; 


-- D. Find the number and id of products sold in decreasing order of 
-- products sold (display product id, no_of_products sold)
SELECT 
    Prod_id, COUNT(1) AS no_of_products
FROM
    market_fact
GROUP BY prod_id
ORDER BY no_of_products DESC;

-- E. Find all the customers from Atlantic region who have ever purchased 
-- ‘TABLES’ and the number of tables purchased 
-- (display the customer name, no_of_tables purchased)
SELECT 
    cd.Customer_Name, cd.Region, COUNT(1) AS no_of_tables
FROM
    market_fact AS mf
        INNER JOIN
    prod_dimen AS pd ON mf.Prod_id = pd.Prod_id
        INNER JOIN
    cust_dimen AS cd ON cd.Cust_id = mf.Cust_id
WHERE
    pd.Product_Sub_Category = 'TABLES'
        AND cd.Region = 'Atlantic'
GROUP BY cd.Customer_Name, cd.Region
ORDER BY no_of_tables DESC;


-- -----------------------------------------------------------------
				-- Task 3: Advanced Analysis
-- -----------------------------------------------------------------

-- A. Display the product categories in descending order of 
-- profits (display the product category wise profits i.e. product_category, profits)?

SELECT 
    pd.Product_Category as product_category, 
    sum(mf.Profit) as Profits
FROM
    market_fact AS mf
INNER JOIN
    prod_dimen AS pd ON mf.Prod_id = pd.Prod_id
    GROUP BY pd.Product_Category
	ORDER BY mf.Profit desc;
 
 -- B. Display the product category, product sub-category and 
 -- the profit within each sub-category in three columns. 

SELECT 
    pd.Product_Category AS product_category,
    pd.Product_Sub_Category AS sub_category,
    SUM(mf.Profit) AS Profits
FROM
    market_fact AS mf
        INNER JOIN
    prod_dimen AS pd ON mf.Prod_id = pd.Prod_id
GROUP BY pd.Product_Sub_Category
ORDER BY pd.Product_Category , mf.Profit DESC;

-- C. Where is the least profitable product subcategory shipped the most?
-- For the least profitable product sub-category, 
-- display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits 
-- (i.e. region, no_of_shipments, profit_in_each_region)
-- Note: You can hardcode the name of the least profitable product sub-category

SELECT 
    cd.region, 
    COUNT(mf.ship_id) as no_of_shipment, 
    SUM(mf.Profit) as profit
FROM
    market_fact mf
        INNER JOIN cust_dimen cd 
			ON cd.Cust_id = mf.Cust_id
		INNER JOIN prod_dimen pd
			ON mf.PROD_id = pd.prod_id
    WHERE pd.Product_Sub_Category = 
		(SELECT pd.Product_Sub_Category AS Product_Sub_Category
		from  market_fact mf
		INNER JOIN prod_dimen pd
		ON mf.PROD_id = pd.prod_id
        GROUP BY pd.Product_Sub_Category
        ORDER BY sum(mf.profit) LIMIT 1)
GROUP BY region
order by profit;

-- Subquery to find least profitable subcategory
SELECT pd.Product_Sub_Category AS Product_Sub_Category
	from  market_fact mf
    INNER JOIN prod_dimen pd
		ON mf.PROD_id = pd.prod_id
        GROUP BY pd.Product_Sub_Category
        ORDER BY sum(mf.profit) LIMIT 1;
