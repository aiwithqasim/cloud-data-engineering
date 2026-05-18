select * from [production].[products] where brand_id = 9; --- brand_id


select * from [sales].[staffs]

delete from [production].[brands] where brand_id = 9
select * from [production].[products]; --brand_id
-- INNER JOIN (IT BRING ONLY COMMON VALUES)
select
	p.product_name,
	b.brand_name
from
 [production].[products] p
 inner join [production].[brands] b
 on p.brand_id = b.brand_id


-- ORDER ITEMS WITH PRODUCT DETAILS
select
p.product_name, p.list_price, p.model_year, oi.discount, oi.quantity, c.category_name
from [production].[products] p
inner join [sales].[order_items] oi
on p.product_id = oi.product_id
inner join [production].[categories] c
on p.category_id = c.category_id

-- THREE-TABLE JOIN (ORDERS + CUSTOMERS + STORES)
-- ORDER SUMMARY - BIKESTORES
select 
o.order_id, 
o.order_date,
o.order_status, 
c.first_name + '' + c.last_name as customer_name, 
c.state as customer_state,
s.store_name,
s.state as store_state
from [sales].[orders] o
inner join [sales].[customers] c
on o.customer_id = c.customer_id
inner join [sales].[stores]s
on o.store_id = s.store_id 

select *  from [sales].[orders]

-- FOUR-TABLE JOIN (ADD STAFF)
select 
o.order_id, 
o.order_date,
o.order_status, 
c.first_name + '' + c.last_name as customer_name, 
c.state as customer_state,
s.store_name,
s.state as store_state,
sf.first_name + '' + sf.last_name as staff_name,
sf.active
from [sales].[orders] o
inner join [sales].[customers] c
on o.customer_id = c.customer_id
inner join [sales].[stores] s
on o.store_id = s.store_id 
inner join [sales].[staffs] sf
on o.staff_id = sf.staff_id

-- All electra products priced over $1,500
select
p.product_name, p.list_price, p.model_year, oi.discount, oi.quantity, c.category_name, b.brand_name
from [production].[products] p
inner join [sales].[order_items] oi
on p.product_id = oi.product_id
inner join [production].[categories] c
on p.category_id = c.category_id
inner join [production].[brands] b
on p.brand_id = b.brand_id
where b.brand_name = 'electra' and p.list_price > 1500;

-- LEFT JOIN
-- LEFT JOIN: PRODUCT WITH NO STOCKS AT ANY STORE
-- jo product out of stock 
select 
* 
from 
[production].[products] p 
left join [production].[stocks] s
on p.product_id = s.product_id
where s.quantity = 0

--  products ha but launch nhi hoi
select 
* 
from 
[production].[products] p 
left join [production].[stocks] s
on p.product_id = s.product_id
where s.product_id is  null

select * from [production].[stocks]


-- FULL OUTER JOIN
-- All products AND all stock records, matched where possible
select 
* 
from 
[sales].[orders] o 
FULL OUTER join [production].[stocks] s
on s.store_id = o.store_id
where o.shipped_date is null

-- SELF JOIN
-- find out name of staff and their manager
select
staff.staff_id,
staff.first_name + '' + staff.last_name as staff_name,
manager.staff_id as manager_id,
manager.first_name + manager.last_name as manager_name
from
[sales].[staffs] staff
left join [sales].[staffs] manager
on staff.manager_id = manager.staff_id

-- CREATE VIEW 
-- THREE-TABLE JOIN (ORDERS + CUSTOMERS + STORES)
create view order_summary_vw as
select 
o.order_id, 
o.order_date,
o.order_status, 
c.first_name + '' + c.last_name as customer_name, 
c.state as customer_state,
s.store_name,
s.state as store_state,
sf.first_name + '' + sf.last_name as staff_name,
sf.active
from [sales].[orders] o
inner join [sales].[customers] c
on o.customer_id = c.customer_id
inner join [sales].[stores] s
on o.store_id = s.store_id 
inner join [sales].[staffs] sf
on o.staff_id = sf.staff_id

-- QUERY ON VIEWS
select * from order_summary_vw
where customer_state = 'CA'

