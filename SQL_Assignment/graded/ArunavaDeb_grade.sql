/*
		ArunavaDeb
*/

					  /*TASK 1*/
                      
/*

cust_dimen is the customer master table having the customer details of customers, their locations and customer segments. Data Type of Cust_id is “Varchar(10)”, whereas Customer_Name, Province, Region, Customer_Segment have “Character” data type. Cust_id is the unique Identifier for every customer. Cust_id is the Primary Key for the cust_dimen table.
prod_dimen is the Product data table having details of the Products, product categories and subcategories. Data type of Prod_id is “Varchar(10)” where as Product_Category and Product_Sub_Category have “Character” data types. Prod_id is the unique identifier given to each Product Sub-category. Prod_id is the Primary key for the prod_dimen Table.
orders_dimen is the Table having the details of the Orders Placed. Ord_id has data type “Varchar(10)”, Order_ID and Order_Priority have data type “Character” and Order_Date has data type “Date”. Since Order_ID is not unique and has duplicate values, the field Ord_id is the unique identifier given to every order place. Hence Ord_id is the Primary Key for the orders_dimen table. Though the Order_ID is numeric, we are not assigning the data type “integer” to the Field – Order_ID as it is an identifier and no arithmetic operations can be performed on the Order_ID. 
shipping_dimen is the Table containing the details of the all the shipments made by the company. The Data type for the Ship_id is “varchar(10)” whereas the Data type for Order_id and Ship_mode is “Character” and Ship_date has the data type “Date”. Every Shipment made by the company has a unique Ship_id. Hence, every distinct Ship_id corresponds to a separate shipment in the company. 
               Ship_id is the Primary key for the shipping_dimen table.

market_fact is the main table for the Superstore as it stores the record of every sale made by the company, keeping data like Sales, Discount, Quantity, Profit, Shipping cost and the Product base margin. 
The most important fields in the market_fact table are :
1.	Ord_id – This identifies the order placed by a customer. Data type is “Varchar(10)”
2.	Prod_id – This identifies the product ordered by the customer in the Ord_id. Data type is “Varchar(10)”
3.	Ship_id – This identifies the shipment created for the particular order. 
4.	Cust_id – This identifies the Customer corresponding to the order placed. Data type for this field is also “Varchar(10)”
5.	Profit – This identifies the Profit earned on that particular Sale Item. Data type of the field Profit is “Double”
6.	Sales –  The Data type is “Double”
7.	Order_Quantity- The Data type is “Integer”


The Primary key and the foreign key on the Tables are as follows:- 
Table Name       Primary key      Foreign key                         Data Type
cust_dimen         Cust_id           NA                              Varchar(10) Not Null
prod_dimen         Prod_id           NA                              Varchar(10) Not Null
order_dimen        Ord_id            NA                              Varchar(10) Not Null
shipping_dimen     Ship_id           NA                              Varchar(10) Not Null
market_fact                        Ord_id (Ord_id - order_dimen)     Varchar(10) Not Null
								   Prod_id(Prod_id- prof_dimen)      Varchar(10) Not Null
	                               Ship_id(Ship_id- shipping_dimen)  Varchar(10) Not Null
								   Cust_id(Cust_id - cust_dimen)	 Varchar(10) Not Null


*/

                      /* TASK 2*/
                      
/*A. Query to retrive Total Sales and Average Sales from market_fact*/

SELECT 
    SUM(Sales) AS 'Total Sale', AVG(Sales) AS 'Average Sales'
FROM
    market_fact;





/* B. Query to display number of customers in each region*/
SELECT 
    Region, COUNT(DISTINCT Cust_id) AS 'No of customers'
FROM
    cust_dimen
GROUP BY Region
ORDER BY COUNT(DISTINCT Cust_id) DESC;





/* C. Query to find the region having maximum customers*/
SELECT 
    Region, COUNT(DISTINCT Cust_id) Customers
FROM
    cust_dimen
GROUP BY Region
HAVING Customers >= ALL (SELECT 
        COUNT(DISTINCT Cust_id)
    FROM
        cust_dimen
    GROUP BY Region);





/* D. Query to find the product ID and the no of products sold*/
SELECT 
    Prod_id, SUM(Order_Quantity) AS 'No of products sold'
FROM
    market_fact
GROUP BY Prod_id
ORDER BY SUM(Order_Quantity) DESC;





/* E. Query to find the Customers from Atlantic region who have purchased tables and the no of tables purchased */
SELECT 
    c.Customer_Name,
    SUM(m.Order_Quantity) AS 'No of tables Purchased'
FROM
    cust_dimen c
        INNER JOIN
    market_fact m ON c.Cust_id = m.Cust_id
        INNER JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
WHERE
    p.Product_Sub_Category = 'TABLES'
        AND c.Region = 'ATLANTIC'
GROUP BY c.Cust_id
ORDER BY c.Customer_Name;





                          /* TASK 3 */
				
SELECT 
    p.Product_Category Product_category, SUM(m.Profit) Profit
FROM
    prod_dimen p
        INNER JOIN
    market_fact m ON p.Prod_id = m.Prod_id
GROUP BY p.Product_Category
ORDER BY Profit DESC;





/* B. Query displaying the product categories, product sub category and the profit */
SELECT 
    p.Product_Category,
    p.Product_Sub_Category,
    SUM(m.Profit) Profit
FROM
    prod_dimen p
        INNER JOIN
    market_fact m ON p.Prod_id = m.Prod_id
GROUP BY p.Product_Category , Product_Sub_Category
ORDER BY Product_Category;






/* C. Query displaying the region-wise no_of_shipments and the profit made in each region in decreasing order of profits */
SELECT 
    c.Region,
    COUNT(DISTINCT m.Ship_id) No_of_Shipments,
    SUM(m.Profit) Profits,
    p.Product_Sub_Category
FROM
    prod_dimen p
        INNER JOIN
    market_fact m ON p.Prod_id = m.Prod_id
        INNER JOIN
    cust_dimen c ON m.Cust_id = c.Cust_id
WHERE
    m.Prod_id = (SELECT 
            Prod_id
        FROM
            (SELECT 
                Prod_id, SUM(Profit) profit1
            FROM
                market_fact
            GROUP BY Prod_id) tempo1
        WHERE
            profit1 = (SELECT 
                    MIN(profit2)
                FROM
                    (SELECT 
                        Prod_id, SUM(Profit) profit2
                    FROM
                        market_fact
                    GROUP BY Prod_id) tempo2))
GROUP BY c.Region
ORDER BY Profits DESC;




/*The least profitable product subcategory is shipped the most to Ontario*/
