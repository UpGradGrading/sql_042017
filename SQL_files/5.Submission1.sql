# Task 1: Understanding the data in hand 
#__________________________________________
#Describe the data in hand in your own words. (Word Limit is 500)
#________________________________________________________________________
 
-- #This data is basically about the functionality of a superstore.We have cust_dimen,
-- #prod_dimen,ord_dimen,ship_dimen and market_fact in superstoredb schema.
-- #The cust_dimen contains the information about the customers whoever visited
-- #the supermarket. It has Customer Name,Province,Region,Customer Segment,Cust id.
-- 
-- # cust_dimen     Data type
-- # Customer_Name	varchar(45)
-- # Province	varchar(45)
-- # Region	varchar(45)
-- # Customer_Segment	varchar(45)
-- # Cust_id	varchar(9)
-- 
#The prod_dimen contains the information about the products available in the supermarket.
#It has Prod id,Product Sub Category and Product Category.

# prod_dimen         Data Type
# Product_Category	varchar(45)
# Product_Sub_Category	varchar(45)
# Prod_id	varchar(7)

#The orders_dimen  contains the information of orders placed by the customers.
#It has Order date,priority,Ord id and Order ID.Ord id has sequentially generated
# unique values whereas Order ID has repeated values due to different priority.

# orders_dimen Data Type
# Order_ID	int(10)
# Order_Date	date
# Order_Priority	varchar(45)
# Ord_id	varchar(10)
 
#The shipping_dimen provides the information about shipping of orders.
# It contains Ship_id,Ship_mode,Ship date and Ship id.Ship id has unique values. 

# shipping_dimen Data Type
# Order_ID	int(10)
# Ship_Mode	varchar(45)
# Ship_Date	date
# Ship_id	varchar(10)
 
# market_fact contains the information about the different orders placed by the customers.
#It contains Ord id,Prod id,Ship id,Cust id,Sales,Discount,Order Quantity,Profit,
#Shipping cost,Product Base Margin. The data is repeating.

# market_fact Data type
# Ord_id	varchar(10)
# Prod_id	varchar(7)
# Ship_id	varchar(10)
# Cust_id	varchar(9)
# Sales	double
# Discount	double
# Order_Quantity	int(10)
# Profit	double
# Shipping_Cost	double
# Product_Base_Margin	double

#__________________________________________________________________________
#B. Identify and list the Primary Keys and Foreign Keys for this dataset
# _________________________________________________________________________

# Cust-dimen
# _______________
# It contains detalils of customers.Cust_id has unique value.I consider 
# Cust_id to be Primary key.

# prod_dimen
# ___________
# It contains details of products.Prod_id has unique values.I consider 
# Prod_id to be Primary key.

# Ord_dimen
# _________
# This contains the detail of orders.It has two Order_ID and Ord_id.Ord_id is unique sequentially 
# generated number.Order_ID has repeated values.The two together can form composite primary key,
# which uniquely identifies the row.

# Shipping_dimen
#_________________
#  The Ship_id having unique values  can act as primary key.
#  I feel a need of addition of a column Ord_id.So Order_ID and Ord_id can act as forign key
#  which will reference to composite primary key(Order_ID,Ord_id) of order_dimen.

# market_fact
# ______________  
# It has repeated data.If we see the combination of Cust_id,Prod_id,Ship_id,Ord_id,
# are not unique.I feel a need of addition of a column say fact_id which will be
# unique and sequentially generated number .
# The fact_id can act as primary key of market_fact table.
# The Cust_id is foreign key referencing to Cust_id of cust_dimen.
# The Prod_id is foreign key referencing to Prod_id of prod_dimen.
# The Ship_id is foreign key referencing to Ship_id of shipping_dimen.
# I feel a need of addition of another column Order_ID similar to Order_ID of order_dimen.
# So Order_ID and Ord_id act as foreign key refrences to primary composite key(Order_ID,Ord_id) of order_dimen.



# ______________________________________________________________________________
# Task 2: Basic Analysis
# _________________________________ 
#Write the SQL queries for the following:  
#A. Find the total and the average sales (display total_sales and avg_sales) 
 
SELECT 
    SUM(Sales) AS Total_Sales,
    SUM(Sales) / COUNT(Sales) AS Average_Sales
FROM
    superstoredb.market_fact;     




# B. Display the number of customers in each region in decreasing order of no_of_customers.
#The result should be a table with columns Region, no_of_customers 
 SELECT 
    Region, COUNT(Cust_id) AS no_of_customers
FROM
    superstoredb.cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC;
 



#C. Find the region having maximum customers (display the region name and max(no_of_customers) 
 SELECT 
    Region, COUNT(Cust_id) AS no_of_customers
FROM
    superstoredb.cust_dimen
GROUP BY Region
ORDER BY no_of_customers DESC
LIMIT 1;
 
 
 
 
 #D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
 SELECT 
    prod_id, SUM(Order_Quantity) AS no_of_products_sold
FROM
    superstoredb.market_fact
GROUP BY Prod_id
ORDER BY no_of_products_sold DESC;




# E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased
SELECT 
    c.Customer_Name, SUM(m.order_quantity) AS no_of_tables
FROM
    cust_dimen c
        INNER JOIN
    market_fact m ON m.Cust_id = c.Cust_id
WHERE
    c.Region = 'ATLANTIC'
        AND m.Prod_id = (SELECT 
            Prod_id
        FROM
            prod_dimen
        WHERE
            Product_Sub_Category = 'TABLES')
GROUP BY c.Customer_name;




# _____________________________________________________________________________________________                                              
#                                               
#		Task 3: Advanced Analysis
#__________________________________________________________________________________________________        
#Write sql queries for the following:
# A. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?

SELECT 
    p.Product_Category, m.Profit
FROM
    prod_dimen p
        INNER JOIN
    market_fact m ON p.Prod_id = m.Prod_id
ORDER BY m.Profit DESC;



# B. Display the product category, product sub-category and the profit within each subcategory in three columns. 
SELECT 
    p.Product_Category, p.Product_Sub_Category, m.Profit
FROM
    prod_dimen p
        INNER JOIN
    market_fact m ON p.Prod_id = m.Prod_id
GROUP BY p.Product_Sub_Category;




#C. Where is the least profitable product subcategory shipped the most? 
#    For the least profitable product sub-category, display the  region-wise no_of_shipments
#    and the profit made in each region in decreasing order of profits 
# (i.e. region, no_of_shipments, profit_in_each_region) o
# Note: You can hardcode the name of the least profitable product subcategory
#first find the name of the least profitable product subcategory
SELECT 
    p.Prod_id, p.Product_Sub_Category, m.Profit
FROM
    market_fact m
        INNER JOIN
    prod_dimen p ON m.Prod_id = p.Prod_id
ORDER BY m.Profit ASC
LIMIT 1;




#   Prod_Sub_Category= PENS & ART SUPPLIES and Prod_id=Prod_13	
SELECT 
    c.Region,
    COUNT(DISTINCT m.ship_id) AS no_of_shipments,
    m.Profit
FROM
    market_fact m
        INNER JOIN
    cust_dimen c ON m.Cust_id = c.Cust_id
        INNER JOIN
    shipping_dimen s ON m.ship_id = s.ship_id
WHERE
    m.Prod_id = 'Prod_13'
GROUP BY c.Region
ORDER BY m.Profit DESC;
                                      
 
                                               
