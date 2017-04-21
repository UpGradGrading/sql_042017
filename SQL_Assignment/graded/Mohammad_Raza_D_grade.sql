/**
			Mohammad Raza

*/


/*Task 1: Understanding the data in hand
A. Describe the data in hand in your own words. (Word Limit is 500)

The superstoresdb database gives an insight about a superstore, the database stores the data for customers, orders,
products, shipping details, sales and profit details, this data is stored in 5 tables, cust_dimen, orders_dimen, 
shipping_dimen, prod_dimen stores are the dimensions and  and market_fact has all the measures defined for the 
superstore database. Below is the brief description for the tables:
cust_dimen has data for all the customers with Customer name, province, region and customer segment that tells the category. There are 1832 customers is the superstore with 376 with category CONSUMER, 662 with category CORPORATE, 420 with category HOME OFFICE and 374 with category.
SMALL BUSINESS column cust_id has unique values and is not null and can become the primary key for the table.
orders_dimen table has the order date and order priority, there are 5506 orders details in the superstore and ord_id column has unique and not null values and qualifies for primary key.
product_dimen has product category and subcategory details, there are 17 unique products in the super, prod_id is unique and not null and qualifies for primary key.
shipping_dimen keeps the record of order details, date and the mode of shipment if the order will be shipped via DELIVERY TRUCK, EXPRESS AIR, REGULAR AIR and date. There are 7701 records in the table, ship_id can be the primary key for the table.
market fact is the master table for the superstore database, it is linked to all the other tables, cust_id, ship_id, prod_id, and ord_id columns are added as a referential key constraint and refer all the above four tables, the table stores all the measures like sales value, ordered quantity, profit details, discount, shipping cost and product base margin information. There are 8336 records in the table.


B. Identify and list the Primary Keys and Foreign Keys for this dataset
As the quetion is only to identify the primary and foreign keys, hence identified the same*/
cust_dimen: cust_id  Primary Key(If Unique and Not NULL)
orders_dimen: ord_id Primary Key(If Unique and Not NULL)
prod_dimen: prod_id Primary Key(If Unique and Not NULL)
shipping_dimen: ship_id Primary Key(If Unique and Not NULL)
market_fact: ord_id, prod_id, ship_id, cust_id Foreign Key(all the columns are primary keys of other tables and are refrred in this table, referential key constraint.)


/*Task 2: Basic Analysis
Write the SQL queries for the following:*/

#A. Find the total and the average sales (display total_sales and avg_sales)

SELECT 
    SUM(sales) total_sales, AVG(sales) avg_sales
FROM
    market_fact;





/*B. Display the number of customers in each region in decreasing order of
no_of_customers. The result should be a table with columns Region,
no_of_customers*/
SELECT 
    region, COUNT(1) no_of_customers
FROM
    cust_dimen
GROUP BY region
ORDER BY no_of_customers DESC;





/*C. Find the region having maximum customers (display the region name and
max(no_of_customers)*/
SELECT 
    a.region, MAX(a.cust_count)
FROM
    (SELECT 
        region, COUNT(customer_name) cust_count
    FROM
        cust_dimen
    GROUP BY region , customer_name) a;






/*D. Find the number and id of products sold in decreasing order of products sold (display
product id, no_of_products sold)*/

SELECT 
    prod_id 'product id',
    SUM(order_quantity) 'no_of_products sold'
FROM
    market_fact
GROUP BY prod_id
ORDER BY SUM(order_quantity) DESC;






/*E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and
the number of tables purchased (display the customer name, no_of_tables
purchased)*/
SELECT 
    cd.customer_name,
    SUM(mf.order_quantity) no_of_tables_purchased
FROM
    cust_dimen cd,
    prod_dimen pd,
    market_fact mf
WHERE
    cd.cust_id = mf.cust_id
        AND pd.prod_id = mf.prod_id
        AND cd.region = 'ATLANTIC'
        AND pd.product_sub_category = 'TABLES'
GROUP BY cd.customer_name;
SELECT 
    pd.product_category, SUM(mf.profit) profits
FROM
    prod_dimen pd,
    market_fact mf
WHERE
    pd.prod_id = mf.prod_id
GROUP BY pd.product_category
ORDER BY profits DESC;





/*B. Display the product category, product sub-category and the profit within each subcategory
in three columns.*/

SELECT 
    pd.product_category,
    pd.product_sub_category,
    SUM(mf.profit) profits
FROM
    prod_dimen pd,
    market_fact mf
WHERE
    pd.prod_id = mf.prod_id
GROUP BY pd.product_category , pd.product_sub_category
ORDER BY profits DESC;






/*C. Where is the least profitable product subcategory shipped the most? For the least
profitable product sub-category, display the region-wise no_of_shipments and the
profit made in each region in decreasing order of profits (i.e. region,
no_of_shipments, profit_in_each_region)
o Note: You can hardcode the name of the least profitable product subcategory*/

SELECT 
    pd.product_category,
    pd.product_sub_category,
    SUM(mf.profit) profits
FROM
    prod_dimen pd,
    market_fact mf
WHERE
    pd.prod_id = mf.prod_id
GROUP BY pd.product_category , pd.product_sub_category
ORDER BY profits ASC;





SELECT 
    cd.region, SUM(mf.profit), COUNT(1)
FROM
    cust_dimen cd,
    prod_dimen pd,
    market_fact mf
WHERE
    cd.cust_id = mf.cust_id
        AND pd.prod_id = mf.prod_id
        AND pd.product_sub_category = 'TABLES'
GROUP BY cd.region
ORDER BY mf.profit DESC;





SELECT 
    cd.region, SUM(mf.profit), COUNT(1)
FROM
    cust_dimen cd,
    prod_dimen pd,
    market_fact mf
WHERE
    cd.cust_id = mf.cust_id
        AND pd.prod_id = mf.prod_id
        AND pd.product_sub_category IN (SELECT 
            pd.product_sub_category
        FROM
            prod_dimen pd,
            market_fact mf
        WHERE
            pd.prod_id = mf.prod_id
        GROUP BY pd.product_category , pd.product_sub_category
        HAVING SUM(mf.profit) <= (SELECT 
                MIN(a.profit1)
            FROM
                (SELECT 
                    prod_id, SUM(profit) profit1
                FROM
                    market_fact
                GROUP BY prod_id) a))
GROUP BY cd.region
ORDER BY mf.profit DESC;









