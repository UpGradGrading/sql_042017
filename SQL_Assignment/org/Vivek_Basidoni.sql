/*
				Vivek Basidoni
*/

/*
Describe the data in hand in your own words.
	In the provided superstoredb we have four dimension(cust_dimen,orders_dimen,prod_dimen,shipping_dimen) 
    tables and one fact table (market_fact).
    Fact Table : Fact table consuists of facts of business. Facts are represented by number. This table
    be updated after each transaction. 
    Dimension Table: Fact table are linked to the dimensions using foreign keys to Dimension tables.
    Dimension table are represented by varchar values with when we join with fact tables get complete
    picture.
    All customer related,order related ,product related and shipping related  data is 
    maintained in Cust_dimen, order_dimen,prod_dimen and shipping_dimen respectively. Any change in the 
    data reflects in corresponding tables. 
    Market_fact table constains all data related to the transactions mostly numbers and ids 
    (Foreign keys ) of dimension table.
	

*/

/*
market_fact: Ord_id,Prod_id,Ship_id and Cust_id  composite primary key
and Ord_id is foreign key refereing orders_dimen.Ord_id,
Prod_id is foreign_key refering prod_dimen.Prod_id,
Ship_id is foreign_key refering shipping_dimen.Ship_id,
Cust_id is foreign_key refreing cust_dimen.Cust_id

cust_dimen : Cust_id is primary key

orders_dimen : Ord_id and Order_id is composite primary key
Order_id is foreign key refreing shipping_dimen Order_id

prod_dimen: Prod_id is primary key

shipping_dimen : ship_id is and Order_id is composite primary key

*/



/*
Find the total and the average sales (display total_sales and avg_sales)  
*/
SELECT sum(Sales) as total_sale ,avg(Sales) as avg_sale FROM superstoresdb.market_fact;

/*
Display the number of customers in each region in decreasing order of no_of_customers.
 The result should be a table with columns Region, no_of_customer
*/
SELECT count(*) no_of_customers ,Region FROM superstoresdb.cust_dimen group by Region order by no_of_customers desc; 

/*
Find the region having maximum customers (display the region name and max(no_of_customers)
*/
(select count(*) as no_of_customers,Region  from cust_dimen group by Region order by no_of_customers desc 
limit 0,1);

/*
Find the number and id of products sold in decreasing order of products sold 
(display product id, no_of_products sold
*/
select Prod_id as product_id,count(Prod_id) as no_of_products from market_fact group by Prod_id
order by no_of_products desc;

/*
Find all the customers from Atlantic region who have ever purchased 
‘TABLES’ and the number of tables purchased (display the customer name, no_of_tables purchased)
*/
(select CD.Customer_Name,count(*) as no_of_tables_purchased from market_fact  MF
inner join prod_dimen  PD on
MF.Prod_id=PD.Prod_id
inner join cust_dimen CD on
MF.Cust_id=CD.Cust_id
where PD.Product_Sub_Category='Tables'
and CD.Region='Atlantic'
group by CD.Customer_Name order by no_of_tables_purchased desc);

/*
Display the product categories in descending order of profits 
(display the product category wise profits i.e. product_category, profits)
*/
(SELECT PD.Product_Category,sum(Profit) profits FROM 
market_fact MF 
inner join  superstoresdb.prod_dimen PD 
on
MF.Prod_id=PD.Prod_id 
group by PD.Product_Category
order by profits desc);

/*
Display the product category, product sub-category and the profit within each subcategory in three column
*/
(SELECT PD.Product_Category,PD.Product_Sub_Category,(Profit) profits FROM 
market_fact MF 
inner join  superstoresdb.prod_dimen PD 
on
MF.Prod_id=PD.Prod_id 
group by PD.Product_Category,PD.Product_Sub_Category
order by profits desc);

/*
Where is the least profitable product subcategory shipped the most?
 For the least profitable product sub-category, display the 
 region-wise no_of_shipments and the profit made in each region in decreasing order of profits 
 (i.e. region, no_of_shipments, profit_in_each_region
*/
(SELECT sum(MF.Profit) as profit,PD.Product_Sub_Category,CD.Region FROM superstoresdb.market_fact MF
inner join cust_dimen CD on
MF.Cust_id=CD.Cust_id
inner join prod_dimen PD on
MF.Prod_id=PD.Prod_id
group by PD.Product_Sub_Category order by profit asc);


(select CD.Region,count(*) as no_of_shipments,sum(Profit) as profit_in_each_region from market_fact MF
inner join cust_dimen CD on
MF.Cust_id=CD.Cust_id
inner join prod_dimen PD on
MF.Prod_id=PD.Prod_id
where PD.Product_Sub_Category='TABLES'
group by Region);

