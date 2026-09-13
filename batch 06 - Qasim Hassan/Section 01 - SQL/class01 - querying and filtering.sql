USE bikestores;

-- QUERYING
-----------

-- select all columsn and rows
SELECT * FROM sales.customers;

-- select specific columns and all rows
SELECT customer_id, first_name, last_name FROM sales.customers;

-- select specific column first and then all coumns and rows
SELECT phone, * FROM sales.customers;

-- QUERYING & FILTERING
-----------------------
-- METHMATICAL/COMPARSION OPERATOPRS
--greater then >
--less than <
--equals to =
--greater then and equal to >=
--less than and equal to <=
--not equals to != also <>

-- greater then 
SELECT * FROM sales.customers
where customer_id > 50;

--less then 
SELECT * FROM sales.customers
where customer_id < 50;

--greater then equal to 
SELECT * FROM sales.customers
where customer_id >= 50;

--lesss then equal to
SELECT * FROM sales.customers
where customer_id <= 50;

--equal to 
SELECT * FROM sales.customers
where customer_id = 50;

-- LOGICAL OPERATORS
-- both condition should match AND
-- any consition should match OR
-- should not be NOT

-- select all columsn and rows where states is NY
SELECT * FROM sales.customers WHERE state = 'NY';

-- select all columsn and rows where states is NY or TX
SELECT * FROM sales.customers WHERE state = 'NY' or state = 'TX';

-- select all columsn and rows where states is NY and first_name is Garry
SELECT * FROM sales.customers WHERE first_name = 'Garry' and state = 'TX';

-- select all columsn and rows where states is NOT CA
SELECT * FROM sales.customers WHERE state != 'CA';

-- select all columsn and rows where phne number isnt been provided
SELECT * FROM sales.customers WHERE phone IS NULL;

-- select all columsn and rows where customer have provided phone number
SELECT * FROM sales.customers WHERE phone IS NOT NULL;

-- all customers  betwee id 5 to 56
SELECT * FROM sales.customers WHERE customer_id BETWEEN 5 AND 56;

-- OTHERS
---------

-- ALIAS
SELECT
	first_name + ' ' + last_name AS full_name
FROM sales.customers;

SELECT
	last_name AS full_name
FROM sales.customers;

-- LIMITING ROWS
SELECT top 15 * FROM sales.customers;

-- ORDER BY
SELECT *
FROM sales.customers
ORDER BY first_name;

SELECT *
FROM sales.customers
ORDER BY first_name DESC;

SELECT *
FROM sales.customers
ORDER BY state ASC, first_name DESC;

SELECT *
FROM sales.customers
ORDER BY first_name DESC, state ASC;

-- qasim --> CA
-- qasim --> NY

SELECT *
FROM sales.customers
ORDER BY state ASC, first_name DESC;

SELECT *
FROM sales.customers
ORDER BY first_name ASC, last_name DESC;

SELECT *
FROM sales.customers
ORDER BY 8, 2;

-- how to apply limitng on order by using ?
SELECT * FROM sales.customers
ORDER BY first_name
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- query multiple value (OPTION1)
select * from sales.customers
where state = 'NY' OR state = 'CA'

-- query multiple value (OPTION2: RECOMMENDED)
select * from sales.customers
where state IN ('NY', 'CA')

SELECT * FROM sales.customers
WHERE customer_id IN (
	SELECT customer_id FROM sales.orders
	-- ORDER BY customer_id
);

	SELECT * FROM sales.orders


	---------------------------
SELECT * FROM production.products;



SELECT category_id, category_name FROM production.categories;
---- inner join 



SELECT
    p.product_name,
    c.category_name,
    p.list_price
FROM production.products AS p
INNER JOIN production.categories AS c
    ON p.category_id = c.category_id;





SELECT
   *
FROM production.products AS p
INNER JOIN production.stocks AS s
    ON p.product_id = s.product_id;


SELECT 
 p.product_name,
 s.product_id,
 s.store_id,
 s.quantity
FROM  production.products AS p
INNER JOIN production.stocks AS s
 ON p.product_id = s.product_id;




 SELECT
    o.order_id,
    o.order_date,
    s.store_name,
    s.city
FROM sales.orders AS o
INNER JOIN sales.stores AS s
    ON o.store_id = s.store_id
WHERE o.order_id IN (1, 15, 3);

------- left join
SELECT
    p.product_name,
    oi.order_id
FROM production.products AS p
LEFT JOIN sales.order_items AS oi
    ON p.product_id = oi.product_id
WHERE oi.order_id IS NULL;

--------------------



SELECT
    c.first_name,
    c.last_name,
    o.order_id
FROM sales.customers AS c
LEFT JOIN sales.orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;



--------

select 
s.first_name,
s.staff_id,
o.order_id,
o.order_date 
from sales.staffs as s
left Join sales.orders as o on 
s.store_id = o.store_id;

SELECT * 
FROM production.products;

SELECT * 
FROM production.stocks;


SELECT 
    p.product_id,
    p.product_name,
    p.brand_id,
    p.category_id,
    s.quantity
FROM production.products AS p
INNER JOIN production.stocks AS s
ON p.product_id 
= s.product_id;

SELECT COUNT(*) FROM production.products

SELECT COUNT(*) FROM production.stocks;

-- 1260


SELECT 
p.product_name,
p.product_id,
s.quantity
FROM production.stocks AS s
JOIN production.products as p
ON p.product_id=s.product_id;

===============================

----5.1. Write a query that lists every product 
--with its brand name, 
---using production.products and production.brands.

----5.2. Using a LEFT JOIN, write a query 
--that finds every store
----with zero staff currently assigned to it.

----5.3. Explain, in your own words, why 
--the following query returns every product
----regardless of stock level, and rewrite 
--it so that it only returns products 
----with fewer than 5 units in stock at store 1:
SELECT p.product_name, s.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id AND 
    s.quantity < 5 AND s.store_id = 1;

SELECT p.product_name, s.quantity
FROM production.products AS p
LEFT JOIN production.stocks AS s
    ON p.product_id = s.product_id
 WHERE S.quantity < 5
 AND S.STORE_ID = 1








