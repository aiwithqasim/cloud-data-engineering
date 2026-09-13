-- Sub Queries
--------------
 -- query1 --> query

 SELECT * 
 FROM sales.customers o
 WHERE EXISTS (
    SELECT 1
    FROM sales.orders i
    WHERE o.customer_id = i.customer_id
    AND year(i.order_date) = 2017
 );

 SELECT DISTINCT brand_id FROM production.products; -- 1 to 9

 SELECT * 
 FROM production.products
 WHERE list_price >= ALL(
     SELECT
        --brand_id,
        avg(list_price) AS avg_brand_price
     FROM production.products
     --WHERE brand_id IN (1,3,5,7,9)
     GROUP BY brand_id
     ORDER BY brand_id
 );

-- Msg 1033, Level 15, State 1, Line 26
-- The ORDER BY clause is invalid in views, inline functions,
-- derived tables, subqueries, and common table expressions, 
-- unless TOP, OFFSET or FOR XML is also specified.
-- Completion time: 2026-09-13T15:25:58.8416549+05:00


 SELECT * 
 FROM production.products
 WHERE list_price >= ANY(
     SELECT
        --brand_id,
        avg(list_price) AS avg_brand_price
     FROM production.products
     --WHERE brand_id IN (1,3,5,7,9)
     GROUP BY brand_id
     --ORDER BY brand_id
 );

 -- summary:
 -- multiple AND --> ALL
 -- multiple OR --> ANY


 -- Top 2 most expensive products per category 

 SELECT *
 FROM production.categories AS o
 --WHERE category_id = 7;
 CROSS APPLY ( -- inner join
     SELECT TOP 2 * 
     FROM production.products i
     WHERE i.category_id = o.category_id
     ORDER BY list_price DESC
 ) p;

 SELECT *
 FROM production.categories AS o
 --WHERE category_id = 7;
 OUTER APPLY ( -- left join
     SELECT TOP 2 * 
     FROM production.products i
     WHERE i.category_id = o.category_id
     ORDER BY list_price DESC
 ) p;

-- Products priced above the average for Strider and Trek brands

SELECT *
FROM production.products
WHERE list_price >
ALL(
    SELECT AVG(p.list_price)
    FROM production.products p
    WHERE EXISTS (
     SELECT 1
     FROM production.brands b
     WHERE
         p.brand_id = b.brand_id
         AND brand_name IN ('Strider', 'Trek')
    )
    GROUP BY p.brand_id
);

-- tasks
select 
p.product_name,
p.list_price,
p.brand_id
from production.products as p
where p.list_price > (select avg(p2.list_price) from production.products as p2
where p2.brand_id = p.brand_id
);

select 
o.order_id,
o.customer_id,
o.order_date,
o.order_status
from sales.orders as o
where o.customer_id in (select c.customer_id from sales.customers as c
where c.state in ('NY', 'CA')
);

select 
c.customer_id,
c.first_name,
c.last_name from sales.customers c
where not exists (select 1
from sales.orders as o
where o.customer_id = c.customer_id);

--- CTEs --> Common Table Expressions

select 
o.order_id,
o.customer_id,
o.order_date,
o.order_status
from sales.orders as o
where o.customer_id in (
    select c.customer_id
    from sales.customers as c
    where c.state in ('NY', 'CA')
);

WITH NY_CA_CUSRTOMERS AS (
    select *
    from sales.customers as c
    where c.state in ('NY', 'CA')
),
FETCH_ORDERS AS (
    select 
        o.order_id,
        o.customer_id,
        o.order_date,
        o.order_status
    from sales.orders as o
    where o.customer_id in (SELECT customer_id FROM NY_CA_CUSRTOMERS)
)
SELECT * FROM FETCH_ORDERS;

