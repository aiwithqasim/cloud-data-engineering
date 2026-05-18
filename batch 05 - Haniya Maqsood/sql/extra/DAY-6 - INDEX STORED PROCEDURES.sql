-- to add index on table
CREATE INDEX [index_name] ON [tablename](column_name);

-- to find indexes on tables
EXEC sp_helpindex [Tablename];

-- CLUSTERED INDEX
-- only one per table 
-- helpful for queries with ranges <>, between
-- by default - primary key is clustered index
-- physically orders the table for faster retrieval

-- NON CLUSTERED INDEX
-- they just points to the location - dont reorder the book
-- usually helps to filter where, join order by


-- Create a non-clustered index on last_name (common search)


-- Create index on multiple columns (composite index)


-- Create unique index (no duplicates allowed)


-- how to select column for index
-- column used in most filtering
-- joining column

-- when you should not create index
-- table is too small
-- column with few unique values
-- column rarely used

-- Query 1: Search by last_name (SLOW without index)
SELECT * FROM sales.customers 
WHERE city like 'St%';

-- Q: Should you index a "gender" column (M/F only)?

-- Q: Should you index "email" column?

-- STORED PROCEDURES
-- SAVE A sql SCRIPT AND USE IT REPEATEDLY

-- 
-- **Basic Syntax:**
-- CREATE PROCEDURE procedure_name
-- AS
-- BEGIN
    -- Your SQL code here
-- END;


-- -- Create a procedure that shows all expensive products

--**Example 2: Stored Procedure with Parameters (Customizable!)**
-- Parameters are like "ingredients" you can change each time
--CREATE PROCEDURE procedure_name
--    @MinPrice DECIMAL(10,2),
--    @MaxPrice DECIMAL(10,2)
--AS
--BEGIN
--    SELECT product_name, list_price
--    FROM production.products
--    WHERE list_price BETWEEN @MinPrice AND @MaxPrice
--    ORDER BY list_price;
-- END;


-- exec procedure_name parameter 1, parameter 2

--CREATE PROCEDURE sp_UpdateProductPrice
--@ProductID INT,
--@NewPrice DECIMAL(10,2)
--AS
--BEGIN
---- Check if product exists
--IF EXISTS (SELECT 1 FROM production.products WHERE product_id = @ProductID)
--BEGIN
--    UPDATE production.products
--    SET list_price = @NewPrice
--    WHERE product_id = @ProductID;
        
--    SELECT 'Product updated successfully' AS Message;
--END
--ELSE
--BEGIN
--    SELECT 'Product not found' AS Message;
--END
--END;

-- Get customer order history (PARAMETER CUSTOMER_ID)

-- -- 2. Restock alert (products with low inventory) (SET DEFAULT THRESHOLD 10)

-- ALTER PROCEDURE
-- DROP PROCEDURE


-- GET CUSTOMERS PENDING ORDER



--| Scenario | Action |
--|----------|--------|
--| Primary Key | Automatic clustered index (good) |
--| Foreign Key | Add non-clustered index |
--| WHERE column = value | Add index on that column |
--| JOIN on column | Index both sides of JOIN |
--| ORDER BY column | Consider index on that column |
--| Small table (<1000 rows) | Skip indexes |
--| Frequent updates | Fewer indexes |

