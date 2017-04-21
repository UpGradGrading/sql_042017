/*
		Anita Chillal
*/

## Task 1
## This is a database for superstore.
## Fact table- Market
## Dimentions- 1) Cust Primary key- Cust_id
## 			   2) Product Primary key-Prod_id
##			   3) Shipping Primary key- Ship_id using order_id from orders dimension
##			   4) Orders Primary key-Ord_id Order_id column is foreign key for shipping dimension
## All these are used as foreign keys in Market fact table.


use superstoresdb;
describe cust_dimen;
describe orders_dimen;
describe shipping;

##Task 2
## 1
Select sum(Sales) as total_sales,
		avg(sales) as avg_sales from Market_fact;
        
##2
select region,count(cust_id) as Number_of_customers 
from cust_dimen
group by region
order by Number_of_customers desc;

##3
select region,max(Number_of_customers) from
(select region,count(cust_id) as Number_of_customers 
from cust_dimen
group by region
) Customer_count;


##4
select prod_id,sum(order_quantity) Num_of_products_sold
from market_fact
group by prod_id
order by Num_of_products_sold desc;

##5
select cust.customer_name,sum(order_quantity) as Number_of_tables_purchased
from market_fact mar
inner join cust_dimen cust
on mar.cust_id=cust.cust_id
inner join prod_dimen prod
on mar.prod_id=prod.prod_id
where cust.region='ATLANTIC'
and prod.product_sub_category='TABLES'
group by cust.customer_name;

##TASK 3

##1
select prod.product_category,sum(profit) profit_made
from market_fact mar
inner join prod_dimen prod
on mar.prod_id=prod.prod_id
group by prod.product_category
order by profit_made desc;

##2
select prod.product_category,prod.product_sub_category,sum(profit) profit
from market_fact mar
inner join prod_dimen prod
on mar.prod_id=prod.prod_id
group by prod.product_sub_category;

##3
select product_sub_category,min(profit) least_profit from
(select prod.product_category,prod.product_sub_category,sum(profit) profit
from market_fact mar
inner join prod_dimen prod
on mar.prod_id=prod.prod_id
group by prod.product_sub_category
) sub_category_wise_profit;
##Answer=APPLIANCES

select cust.region,count(mar.ship_id) No_of_shipments,sum(profit) as profit_made
from market_fact mar
inner join cust_dimen cust
on mar.cust_id=cust.cust_id
inner join shipping_dimen ship
on mar.ship_id=ship.ship_id
group by cust.region
order by profit_made desc;

