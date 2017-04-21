/*
		Leela RaviShankar
*/

### Task 1: Understanding the data

## A. Describe the data

# superstoredb has 5 tables: 'cust_dimen', 'market_fact', 'orders_dimen', 'prod_dimen' and 'shipping_dimen'

# The list of feilds and data types for 'cust_dimen' table:
 # 'Customer_Name` text,   `Province` text,   `Region` text,   `Customer_Segment` text,   `Cust_id` text

# The list of feilds and data types for 'market_fact' table:
 #  `Ord_id` text,  `Prod_id` text,   `Ship_id` text,   `Cust_id` text,   `Sales` double,   `Discount` double, `Order_Quantity` int(11),  `Profit` double,   `Shipping_Cost` double,   `Product_Base_Margin` double 

# The list of feilds and data types for 'orders_dimen' table:
 # `Order_ID` int(11) ,   `Order_Date` text,   `Order_Priority` text,   `Ord_id` text

# The list of feilds and data types for 'prod_dimen' table:
 #  `Product_Category` text,   `Product_Sub_Category` text,   `Prod_id` text
 
# The list of feilds and data types for 'shipping_dimen' table:
 #  `Order_ID` int(11) ,   `Ship_Mode` text,   `Ship_Date` text,   `Ship_id` text

## B. Identify and list the Primary Keys and Foreign Keys 

# List of Primary Keys: cust_dimen.Cust_id, orders_dimen.Order_ID, prod_dimen.Prod_id, shipping_dimen.Ship_ID
# List of Foreign Keys: market_fact.Ord_id, market_fact.Prod_id, market_fact.Ship_id, market_fact.Cust_id, orders_dimen.Ord_id, shipping_dimen.Order_ID

use superstoresdb;
show tables;

### Task 2: Basic Analysis

## A. Find the total and the average sales (display total_sales and avg_sales)

SELECT Sum(Sales) as 'Total Sales', Avg(Sales) as 'Average Sales'
    FROM `superstoresdb`.`market_fact`;

## B. Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region, no_of_customers
CREATE TEMPORARY TABLE max_customers 
(SELECT  Region, Count(Customer_Name) as No_of_Customers
FROM `superstoresdb`.`cust_dimen`
group by Region
order by Count(Customer_Name) desc);


## C. Find the region having maximum customers (display the region name and max(no_of_customers)
select Region, no_of_customers
from max_customers
having Max(no_of_customers); 

## D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
SELECT Prod_id, sum(Order_Quantity) as no_of_products_sold
FROM `superstoresdb`.`market_fact`
group by Prod_id
order by Sum(Order_Quantity) desc;

## E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)

select Product_Sub_Category, Region
from market_fact m inner join prod_dimen p on m.Prod_id = p.Prod_id
inner join cust_dimen c on m.Cust_id=c.Cust_id
   where Region = "Atlantic" 
   and Product_Sub_Category = "Tables"


SELECT `market_fact`.`Ord_id`,
    `market_fact`.`Prod_id`,
    `market_fact`.`Ship_id`,
    `market_fact`.`Cust_id`,
    `market_fact`.`Sales`,
    `market_fact`.`Discount`,
    `market_fact`.`Order_Quantity`,
    `market_fact`.`Profit`,
    `market_fact`.`Shipping_Cost`,
    `market_fact`.`Product_Base_Margin`
FROM `superstoresdb`.`market_fact`;
SELECT `cust_dimen`.`Customer_Name`,
    `cust_dimen`.`Province`,
    `cust_dimen`.`Region`,
    `cust_dimen`.`Customer_Segment`,
    `cust_dimen`.`Cust_id`
FROM `superstoresdb`.`cust_dimen`;
SELECT `prod_dimen`.`Product_Category`,
    `prod_dimen`.`Product_Sub_Category`,
    `prod_dimen`.`Prod_id`
FROM `superstoresdb`.`prod_dimen`;
SELECT `shipping_dimen`.`Order_ID`,
    `shipping_dimen`.`Ship_Mode`,
    `shipping_dimen`.`Ship_Date`,
    `shipping_dimen`.`Ship_id`
FROM `superstoresdb`.`shipping_dimen`;


### Task 3: Advanced Analysis

## A. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
SELECT Product_Category, Profit
 FROM market_fact m inner join prod_dimen p on m.Prod_id = p.Prod_id
ORDER BY Product_Category, Profit desc;

         
## B. Display the product category, product sub-category and the profit within each sub-category in three columns. 
SELECT Product_Category, Product_Sub_Category, Profit
 FROM market_fact m inner join prod_dimen p on m.Prod_id = p.Prod_id
ORDER BY Product_Sub_Category, Profit desc;


## C. Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)

## least profitable product sub-category
SELECT Product_Sub_Category, min(Profit)
 FROM market_fact m inner join prod_dimen p on m.Prod_id = p.Prod_id
ORDER BY Profit desc;

select Region, count(*) as 'No_of_Shipments', Profit
from market_fact m inner join prod_dimen p on m.Prod_id = p.Prod_id
inner join cust_dimen c on m.Cust_id=c.Cust_id
inner join shipping_dimen s on m.Ship_id=s.Ship_id
where Product_Sub_Category = "SCISSORS, RULERS AND TRIMMERS"
group by Region
ORDER BY Profit desc;