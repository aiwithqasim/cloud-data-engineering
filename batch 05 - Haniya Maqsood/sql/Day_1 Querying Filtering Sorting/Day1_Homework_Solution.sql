-- List all brand names from the brands table..
select brand_name from [production].[brands];

--Show the product name and list price of all products, sorted from most expensive to cheapest.
select 
product_name,
list_price
from
[production].[products]
order by list_price desc;

-- Find all customers who live in the state of New York (NY).
select 
*
from
[sales].[customers] where state = 'NY';

-- Show only the top 5 most expensive products in the store
select 
top 5 *
from
[production].[products]
order by list_price desc;

-- List all products with a price between $200 and $500, sorted by price ascending.
select 
* 
from
[production].[products]
where list_price between 200 and 500
order by list_price asc;

-- Find all customers whose last name starts with the letter "S".
select * 
from 
[sales].[customers]
where last_name like 's%'

-- List all products that belong to category 6 (Mountain Bikes) OR category 7 (Road Bikes).
select * from 
[production].[products]
where category_id = 6 or category_id = 7;

select * from 
[production].[products]
where category_id IN (6, 7)

-- Show all orders that have NOT been shipped yet (shipped_date is missing).
select * 
from
[sales].[orders]
where [shipped_date] is null;

-- Display product name, brand ID, 
-- and a computed column showing 15% off the list price, labeled "Sale Price".
select
	product_name,
	brand_id,
	list_price,
	list_price - (list_price * .15) as "Sale Price"
from [production].[products]

-- Get a unique list of all cities where BikeStores customers live, sorted alphabetically.
select
	distinct city
from [sales].[customers]
order by city;

-- List all staff members who are currently active (active = 1), 
-- showing their full name and email.

select
	first_name + '' + last_name as full_name,
	email
from [sales].[staffs]
where active = 1

-- Using UNION, 
-- get a combined list of all cities from both customers and stores (no duplicates), 
-- sorted A�Z.

select city from [sales].[stores]
union
select city from [sales].[customers]
order by city;

-- Using EXCEPT, 
-- find product IDs that exist in order_items but are NOT in the products table.
select product_id
from [sales].[order_items]
except
select product_id 
from [production].[products]

-- List all products from the year 2016 with a price greater than $1,500, 
-- sorted by price descending.

select 
	*
from [production].[products]
where model_year >= 2016 and list_price > 1500
order by list_price desc;

-- BONUS: Using UNION ALL, show Trek (brand_id = 9) 
-- products from 2016 and Surly (brand_id = 8) products from 2017. 
-- Include product name, brand, year, and price. Order by year then price descending.

select 
	*
from [production].[products]
where model_year >= 2016 and brand_id = 9
union all
select 
	*
from [production].[products]
where model_year >= 2017 and brand_id = 8
order by model_year, list_price desc;