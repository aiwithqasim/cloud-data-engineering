-- CREATE DATABASE BIKESTORES;

-- SHOW ONLY TOP 5 
-- MOST EXPENSIVE PRODUCTS IN THE STORE;
SELECT TOP 5 * FROM [production].[products]
ORDER BY LIST_PRICE DESC 

-- ONLY UNIQUE ROWS
SELECT DISTINCT * FROM [sales].[order_items]


-- COMPARISON OPERATOR > < <>
SELECT * FROM [sales].[order_items]
WHERE LIST_PRICE < 10000 AND LIST_PRICE > 5000;

SELECT * FROM [sales].[order_items]
WHERE LIST_PRICE BETWEEN 5000 AND  10000;

SELECT * FROM [sales].[order_items]
WHERE LIST_PRICE <> 5000 AND LIST_PRICE <>  10000;


 -- IN OPERATOR
SELECT * FROM [sales].[customers] 
WHERE STATE not IN ('NY', 'CA') ORDER BY STATE;

SELECT * FROM [sales].[customers] 
WHERE STATE  IN ('NY', 'CA') ORDER BY STATE

--- NULL / ISNULL
SELECT * FROM [sales].[customers]
WHERE PHONE IS NULL;

SELECT * FROM [sales].[customers]
WHERE PHONE IS NOT NULL;




-- LOGICAL OPERATORS
select * from [production].[brands]
where brand_name = 'Electra' and brand_id = 200; 

select * from [production].[brands]
where brand_name = 'Electra' or brand_id = 2;



select * from [production].[stocks]
where store_id = 1;


order by list_price desc , quantity desc
