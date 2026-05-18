-- SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'products'

-- datatypes
-- 1GB - 1024 MB-- 1Mb - 1024 kb - 1kb - 1024 bytes

 customer_id INT, - 10 digits -- 1,2,3 -- 000000000000000000000000001 -- 0000000000000000000000000010 8-10 bytes
 -- age - 3 digits - SMALLINT

1. Numeric Types:
   - INT, SMALLINT, TINYINT (integers)
     Example: customer_id INT, age TINYINT (0-255)
   - DECIMAL(p,s) - exact decimal
     Example: list_price DECIMAL(10,2) → max 99,999,999.99
   - FLOAT/REAL - approximate (avoid for money)


   CUSTOMER_NAME CHAR(500) - ROY -- 
     CUSTOMER_NAME VARCHAR(500) - ROY -- 


2. Character/String Types:
   - CHAR(n) - fixed length (wastes space but faster)
   - VARCHAR(n) - variable length (save space)
     Example: first_name VARCHAR(255)
   - TEXT - large text (deprecated, use VARCHAR(MAX))

   
3. Date/Time Types:
   - DATE - just date (2025-01-15)
   - TIME - just time (14:30:00)
   - DATETIME - date + time
   - SMALLDATETIME - less precision


4. Other Types:
   - BIT - boolean (0,1, or NULL)
     Example: active TINYINT (used as boolean)
   - UNIQUEIDENTIFIER - GUIDs



   -------------------- CONSTRAINTS --------------------
PRIMARY KEY - uniquely identifies each row
FOREIGN KEY - links table
UNIQUE - no duplicate values (but can have one NULL)

NOT NULL - must have a value
Example: product_name VARCHAR(255) NOT NULL




2. ALTER TABLE - modify existing structure

    ALTER TABLE sales.customers
    add date_of_birth date;

   a) ADD column:

   b) DROP column:

   c) ADD constraint:

   d) ALTER column datatype:


3. TRUNCATE TABLE  sales.customers

4. DELETE FROM sales.customers 
 WHERE TRANSACTION_DATE = '2026-01-01'



SELECT *
INTO production.products_bkp
FROM production.categories;

select * from [production].[products_bkp]


    INSERT INTO production.products (
     column names
   )
   VALUES (
     column values datatype
   );


      INSERT INTO production.categories (category_name)
   VALUES ('Motor Bikes'), ('Sports Bikes');





   select * from production.categories
   ----------- UPDATE
   UPDATE production.categories
   SET category_name = 'Pink Bikes'
   where category_id = 9;








3. Date/Time Types:
   - DATE - just date (2025-01-15)
   - TIME - just time (14:30:00)
   - DATETIME - date + time
   - SMALLDATETIME - less precision

4. Other Types:
   - BIT - boolean (0,1, or NULL)
     Example: active TINYINT (used as boolean)
   - UNIQUEIDENTIFIER - GUIDs


-------------------- CONSTRAINTS --------------------
PRIMARY KEY - uniquely identifies each row
FOREIGN KEY - links table
UNIQUE - no duplicate values (but can have one NULL)

NOT NULL - must have a value
Example: product_name VARCHAR(255) NOT NULL

2. ALTER TABLE - modify existing structure

    ALTER TABLE sales.customers
    [action] [column] [datatype];

   a) ADD column:

   b) DROP column:

   c) ADD constraint:

   d) ALTER column datatype:

3. DROP TABLE - remove entire table (CAUTION!)

4. TRUNCATE TABLE - remove all rows (faster than DELETE)


----------------------- DML LANGUAGE --------------------

   INSERT INTO production.products (
     column names
   )
   VALUES (
     column values datatype
   );

2. INSERT multiple rows:
   INSERT INTO production.brands (brand_name)
   VALUES 
     ('Giant'),
     ('Specialized'),
     ('Cannondale');

3. INSERT with IDENTITY column (auto-number):
   -- Don't specify category_id, it auto-generates
   INSERT INTO production.categories (category_name)
   VALUES ('E-Bikes');

4. INSERT from SELECT (copy data):
   INSERT INTO production.products_archive
   SELECT * FROM production.products WHERE model_year < 2020;

------------------------- UPDATE & DELETE
   Syntax:
   UPDATE table_name
   SET column1 = value1, column2 = value2
   WHERE condition;  -- VERY IMPORTANT!

   2. DELETE - remove rows
   Syntax:
   DELETE FROM table_name
   WHERE condition;


   Practice commands for today:
- CREATE TABLE, ALTER TABLE, DROP TABLE
- INSERT, UPDATE, DELETE
- Check constraints with SELECT queries 
