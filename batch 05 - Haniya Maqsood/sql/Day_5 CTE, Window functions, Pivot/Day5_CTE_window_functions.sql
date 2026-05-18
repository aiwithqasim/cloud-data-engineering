
--PART 1: CASE Expressions 
------------------------------------------------

--**Basic Structure:**
--CASE
--    WHEN condition1 THEN result1
--    WHEN condition2 THEN result2
--    ELSE default_result
--END

--**Example 1: Convert numbers to words (Super Simple)**
-- Order status in BikeStores is stored as 1,2,3,4
-- Let's make it readable:
select 
count(a.order_id) no_of_orders,
a.order_status_desc from 
(select 
	order_id, 
	customer_id,
	order_status,
	CASE
		WHEN order_status = 1 THEN 'PLACED'
		WHEN order_status = 2 THEN 'CONFIRMED'
		WHEN order_status = 3 THEN 'DISPATCHED'
		WHEN order_status = 4 THEN 'COMPLETED'
		ELSE 'UNKNOWN'
	END AS order_status_desc
from [sales].[orders]) a
group by a.order_status_desc


-- CTE - CREATE TABLE EXPRESSIONS
-- ORDER STATUS - TOTAL COUNT
WITH ORDER_SUMMARY AS (
select 
	order_id, 
	customer_id,
	order_status,
	CASE
		WHEN order_status = 1 THEN 'PLACED'
		WHEN order_status = 2 THEN 'CONFIRMED'
		WHEN order_status = 3 THEN 'DISPATCHED'
		WHEN order_status = 4 THEN 'COMPLETED'
		ELSE 'UNKNOWN'
	END AS order_status_desc
from [sales].[orders] 
)

--**Example 2: Price categories (Very Simple)**


SELECT ORDER_STATUS_DESC, COUNT(*)
FROM ORDER_SUMMARY
GROUP BY ORDER_STATUS_DESC;

--- CASES - DERIVED COLUMN 
--**Example 2: Price categories (Very Simple)**
-- PRICE_CATEGORY - LESS THAN 500 - 'BUDGET' - LESS THAN 2000 - 'MID RANGE' - LESS THAN 5000 - 'EXPENSIVE' ELSE 'LUXURY '
SELECT 
    product_name,
    list_price,
    CASE 
        WHEN list_price < 500 THEN 'Budget'
        WHEN list_price < 2000 THEN 'Mid-Range'
        WHEN list_price < 5000 THEN 'Premium'
        ELSE 'Luxury'
    END AS price_tier
FROM production.products

-- **Example 3: Simple CASE (when checking one column for equality)**
-- Shortcut for when you're checking a single column:
SELECT * FROM [production].[products]
--  2020 < 'old' 2022 - 'RECENT' <2026 'LATEST' ELSE 'NEW' 

SELECT 
    product_name,
    model_year,
    CASE model_year
        WHEN 2024 THEN 'New Arrival'
        WHEN 2023 THEN 'Last Year'
        ELSE 'Older Model'
    END AS year_category
FROM production.products;

---------------- CASE STATEMENTS END -----------------------
SELECT 
product_name, 
list_price, 
MODEL_YEAR,
CATEGORY_ID,
MIN(LIST_PRICE) OVER(PARTITION BY CATEGORY_ID) AS AVG_PRICE
FROM  production.products -- 809

SELECT AVG(LIST_PRICE) FROM  production.products
SELECT * FROM  production.products

SELECT MODEL_YEAR, AVG(LIST_PRICE) 
FROM  production.products 
GROUP BY MODEL_YEAR;


SELECT AVG(LIST_PRICE)  FROM production.products WHERE category_id = 6  -- 1262.63


-------------- row_number 
---- it gives incremental number to each row

SELECT 
product_name, 
list_price, 
MODEL_YEAR,
CATEGORY_ID,
ROW_NUMBER() OVER(PARTITION BY CATEGORY_ID ORDER BY LIST_PRICE DESC) AS RN
FROM  production.products -- 809

----- rank 
SELECT 
product_name, 
list_price, 
MODEL_YEAR,
CATEGORY_ID,
RANK() OVER(PARTITION BY CATEGORY_ID ORDER BY LIST_PRICE DESC) AS RN
FROM  production.products 

----- DENSE rank 
SELECT 
product_name, 
list_price, 
MODEL_YEAR,
CATEGORY_ID,
DENSE_RANK() OVER(PARTITION BY CATEGORY_ID ORDER BY LIST_PRICE DESC) AS RN
FROM  production.products 

-- SECOND HIGHEST PRICE CTAEGORY

-- Example 5: LAG - look at previous row**
-- Compare each order with the customer's previous order:
SELECT 
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
FROM sales.orders;

SELECT 
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
FROM sales.orders;





**Current Data (rows):**
Store    | Status    | Count
Store A  | Pending   | 10
Store A  | Completed | 25
Store B  | Pending   | 5
Store B  | Completed | 30

**After PIVOT (columns):**
Store    | Pending | Completed
Store A  | 10      | 25
Store B  | 5       | 30


SELECT 
    store_id,
    order_status,
    COUNT(*) AS order_count
FROM sales.orders
GROUP BY store_id, order_status
ORDER BY store_id, order_status;

SELECT *
FROM (
    SELECT store_id, order_status, order_id
    FROM sales.orders
) AS SourceTable
PIVOT (
    COUNT(order_id)
    FOR order_status IN ([1], [2], [3], [4])
) AS PivotTable;
