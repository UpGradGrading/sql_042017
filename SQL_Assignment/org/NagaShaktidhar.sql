/*

			Naga Shaktidhar
*/


#Task 1: Understanding the data in hand
#A. Describe the data in hand in your own words. (Word Limit is 500)
# The data has 4 Dimenssion tables with master data and 1 fact table with transaciton data
# Market_fact is the transaction data; there are few  NA Values in this table
# All the Dimession tables Product, Customer, Orders and shipments are having master data with more attributes
#
#B. Identify and list the Primary Keys and Foreign Keys for this dataset
# Cust_dimen - Primary Key - cust_id ; 
# Orders_dimen - Primary Key - ord_id 
# Prod_dimen - Primary Key - Prod_id 
# shipping_dimen - Primary Key - Ship_id
# market_fact - Primary Key - Combination of (Ord_id, Prod_id, Ship_id, Cust_id,Order_Quantity) 
# market_fact - Foreign Keys -  Ord_id (Table Orders_dimen), Prod_id (Table Prod_dimen), Ship_id (Table shipping_dimen), ord_id (table ord_id) 
#



#Task 2: Basic Analysis
#Write the SQL queries for the following:
#A. Find the total and the average sales (display total_sales and avg_sales)

select sum(sales) as total_sales, avg(sales) as avg_sales from market_fact

#B. Display the number of customers in each region in decreasing order of no_of_customers. The result should be a table with columns Region, no_of_customers
select Region, count(cust_id) as no_of_customers from cust_dimen group by Region order by no_of_customers desc

#C. Find the region having maximum customers (display the region name and max(no_of_customers)
select Region, max(no_of_customers) from 
(select Region, count(cust_id) as no_of_customers from cust_dimen group by Region order by no_of_customers desc) as RegionCustomers 


#D. Find the number and id of products sold in decreasing order of products sold (display product id, no_of_products sold)
select Prod_id as "product id", sum(Order_Quantity) as no_of_products_sold from market_fact group by Prod_id order by no_of_products_sold desc

#E. Find all the customers from Atlantic region who have ever purchased ‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)
select  cd.Customer_Name , sum(mf.Order_Quantity) as no_of_tables from market_fact mf 
							   inner join prod_dimen pd on mf.prod_id = pd.prod_id 
                               inner join cust_dimen cd  on mf.Cust_id = cd.Cust_id 
						where pd.Product_Sub_Category = 'TABLES' and cd.Region = 'ATLANTIC'
						GROUP BY cd.Customer_Name
                        
                        
#Task 3: Advanced Analysis
#A. Display the product categories in descending order of profits (display the product category wise profits i.e. product_category, profits)?
select  pd.Product_Category,  sum(mf.Profit) as Profits from market_fact mf 
							   inner join prod_dimen pd on mf.prod_id = pd.prod_id 
						GROUP BY pd.Product_Category
                        ORDER BY Profits

#B. Display the product category, product sub-category and the profit within each sub-category in three columns.
select  pd.Product_Category, pd.Product_Sub_Category,  sum(mf.Profit) as Profits from market_fact mf 
							   inner join prod_dimen pd on mf.prod_id = pd.prod_id 
						GROUP BY pd.Product_Category, pd.Product_Sub_Category
                        ORDER BY Profits

#C. Where is the least profitable product subcategory shipped the most? For the least profitable product sub-category, display the region-wise no_of_shipments and the profit made in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)

select  cd.Region, count(sd.Ship_id) as no_of_shipments  , sum(mf.Profit) as profit_in_each_region from market_fact mf 
							   inner join prod_dimen pd on mf.prod_id = pd.prod_id 
                               inner join cust_dimen cd  on mf.Cust_id = cd.Cust_id 
                               inner join shipping_dimen sd on mf.Ship_id = sd.Ship_id
						where pd.Product_Sub_Category = 'TABLES' 
						GROUP BY cd.Region
                        ORDER BY profit_in_each_region
                  

