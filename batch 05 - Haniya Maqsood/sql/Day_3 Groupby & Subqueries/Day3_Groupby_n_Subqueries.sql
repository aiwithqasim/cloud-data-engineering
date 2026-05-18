 --Common aggregate functions:
 -- COUNT(*)          — total number of rows in the group
 -- COUNT(col)        — rows where col is NOT NULL
 -- SUM(col)          — sum of values
 -- AVG(col)          — average value
 -- MIN(col)          — smallest value
 -- MAX(col)          — largest value


 select count(*) from [production].[products];
  
  
select count(shipped_date) from [sales].[orders]; -- 1445

select count(*) from [sales].[orders]; -- 1615


select sum(list_price) from [sales].[order_items]; -- total sales


 select avg(list_price) from [production].[products]; -- average product price

 
select avg(list_price) from [sales].[order_items]; -- total sales

select 
	min(list_price) least_price_prod, 
	max(list_price) mas_price_prod, 
	avg(list_price) avg_priced_prod
from [sales].[order_items];

 select avg(list_price) from [production].[products]; -- average product price


-- CONCEPT
-- GROUP BY


-- Q1: How many products does each brand have? 

select
brand_name,
count(*) brand_product_count
from [production].[products] p
inner join [production].[brands] b
on p.brand_id = b.brand_id
group by brand_name
order by brand_name





-- Q3: Count orders per customer
select o.customer_id, c.first_name + ' ' + c.last_name as customer_full_nm,
count(*) as order_count
from [sales].[customers]  c
inner join [sales].[orders] o 
on o.customer_id = c.customer_id
where o.customer_id = 241
group by o.customer_id, c.first_name , c.last_name
order by order_count;



-- Q2: SUM and AVG per category 
select p.category_id, c.category_name, sum(p.list_price) sum , avg(p.list_price) avg
from
[production].[categories] c
inner join  [production].[products] p
on c.category_id  = p.category_id
group by p.category_id, c.category_name


-- Q4: Which store generated the most revenue? 
-- Four-table JOIN with GROUP BY

select 
	s.store_name,
	sum((oi.list_price - (oi.list_price * oi.discount)) * oi.quantity) as total_revenue
from [sales].[order_items] oi 
inner join [sales].[orders] o 
on oi.order_id = o.order_id
inner join [sales].[stores] s
on s.store_id = o.store_id
group by s.store_name


-- Q8: Orders per year 
select 
	year(order_date) order_year , 
	count(order_id) no_of_orders_per_year
from 
[sales].[orders]
group by year(order_date)
having count(order_id)  > 300
order by no_of_orders_per_year desc;

-- Products sold per brand per model year — how has each brand's catalog grown?

select brand_name, model_year, sum(quantity) no_of_products_sold
from [production].[products] p 
inner join [production].[brands] b
on b.brand_id = p.brand_id
inner join [sales].[order_items] oi 
on oi.product_id = p.product_id
group by brand_name, model_year
order by  sum(quantity) desc


-- GROUP BY MULTIPLE COLUMNS
-- Products sold per brand per model year — how has each brand's catalog grown?

-- Q6: Average price per brand 

-- Q7: Total orders and revenue per staff member 

-- Q9: Stock quantity per store

-- Q10: Products per model year 


-- HAVING CONCEPT
-- BRANDS WITH MORE THAN 20 PRODUCTS


-- ── Q12: WHERE + HAVING together ─────────────────────────────
--        Among 2018 products only,
--        which categories have an average price over $1,000?


-- CUSTOMERS WHO PLACED 2 OR MORE ORDERS


-- Q14: Brands with avg price between $500 and $1,500 


-- Q15: Stores with more than 200 total units in stock

-- Q16: Categories with more than 5 products from 2016 

-- Q17: Staff who handled more than 50 orders 

-- SUBQUERIES
-- Find all products priced above the average price of all products

select * 
from [production].[products] p 
where p.list_price > (select avg(p.list_price) avg_price
from [production].[products] p )


-- Find all orders placed by customers who live in California
select *
from [sales].[orders] o
inner join [sales].[customers] c
on c.customer_id = o.customer_id
where c.state = 'CA'



select * from sales.orders
where customer_id in (select customer_id from sales.customers where state = 'CA')


-- EXISTS   — returns TRUE if the subquery returns at least one row. Does NOT return data, just a yes/no.




-- EXISTS: CUSTOMERS WHO HAVE PLACED AT LEAST ONE ORDER
SELECT count(*)
FROM [sales].[customers] c
WHERE EXISTS (
    SELECT 1
    FROM [sales].[orders] o
    WHERE o.customer_id = c.customer_id
)

select count(*)  FROM [sales].[customers] c -- 1445

-- NOT EXISTS: CUSTOMERS WITH NO ORDERS

-- Q25: Products that have never been ordered 

SELECT *
FROM [production].[products] p 
WHERE not EXISTS (
    SELECT 1
    FROM [sales].[order_items] o
    WHERE o.product_id = p.product_id
)

SELECT *
FROM [production].[products] p 
WHERE product_id not in (
    SELECT product_id
    FROM [sales].[order_items] o
)


-- Q26: Stores that have at least one completed order 

SELECT *
FROM [sales].[stores] s
WHERE  EXISTS (
    SELECT 1
    FROM [sales].[orders] o
    WHERE o.store_id = s.store_id and o.order_status = 4
)

SELECT distinct store_name
FROM [sales].[stores] s