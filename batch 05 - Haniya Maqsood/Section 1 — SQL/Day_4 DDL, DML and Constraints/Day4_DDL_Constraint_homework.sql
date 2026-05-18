-- ================================================================================
-- HOMEWORK: CLASS 4 - MODIFYING DATA, DDL, DATA TYPES & CONSTRAINTS
-- Database: BikeStores Sample Database
-- Instructions: Write SQL statements to solve each problem below.
-- Answers will be provided in a separate file.
-- ================================================================================

-- ================================================================================
-- SECTION A: DATA TYPES & CONSTRAINTS (Conceptual Questions)
-- ================================================================================

-- Q1: What data type would you use for a product's weight (e.g., 2.5 kg)?

weight decimal(5,3)  12345.999


-- Q2: In the sales.stores table, the zip_code is VARCHAR(5). Why not use INT?


-- Q3: Look at sales.orders.order_status. The comment says 1=Pending,2=Processing,3=Rejected,4=Completed.
--     Is TINYINT a good choice? Why not use INT?

select * from [sales].[orders]
--yes, tinyint is a good choice


-- Q4: If you add a CHECK constraint that rating must be BETWEEN 1 AND 5, what happens if you try to INSERT rating = 0?


-- Q5: Why does sales.staffs have UNIQUE constraint on email but not on phone?



-- ================================================================================
-- SECTION B: DDL (CREATE, ALTER, DROP)
-- ================================================================================

-- Q6: Create a new table called sales.loyalty_programs with the following columns:
--     - program_id (INT, auto-increment starting 1, PRIMARY KEY)
--     - program_name (VARCHAR(100), NOT NULL, UNIQUE)
--     - discount_rate (DECIMAL(3,2), NOT NULL, DEFAULT 0.05, CHECK between 0.00 and 0.50)
--     - start_date (DATE, NOT NULL, DEFAULT GETDATE())
--     - end_date (DATE, NULL)

CREATE TABLE sales.loyalty_programs (
    program_id INT IDENTITY(1,1) NOT NULL,
    program_name VARCHAR(100) NOT NULL UNIQUE,
    
    discount_rate DECIMAL(3,2) NOT NULL
        DEFAULT 0.05
        CHECK (discount_rate BETWEEN 0.00 AND 0.50),

    start_date DATE NOT NULL DEFAULT GETDATE(),
    end_date DATE NOT NULL DEFAULT GETDATE()
);


-- Q7: Add a new column 'loyalty_program_id' (INT, NULL) to the sales.customers table.

    alter table sales.customers
    add [loyalty_program_id] INT null;



-- Q8: Add a FOREIGN KEY constraint to sales.customers.loyalty_program_id that references 
--     sales.loyalty_programs.program_id.
        


-- Q9: Change the data type of sales.customers.zip_code from VARCHAR(5) to VARCHAR(10).

    ALTER TABLE sales.customers
    ALTER COLUMN zip_code VARCHAR(10);

-- Q10: Drop the column 'birth_date' from sales.customers (first add it if it doesn't exist, then drop it).

   alter table sales.customers
   add birth_date date null;


   alter table sales.customers
   drop column  birth_date

-- Q11: Create a new table production.product_reviews with appropriate columns and constraints:
--      - review_id (PK, auto-increment)
--      - product_id (FK to production.products)
--      - customer_id (FK to sales.customers)
--      - rating (TINYINT, 1-5)
--      - review_text (VARCHAR(1000))
--      - review_date (DATE, default today)

-- ================================================================================
-- SECTION C: INSERT STATEMENTS
-- ================================================================================

-- Q12: Insert a new brand called 'Santa Cruz' into production.brands.

SET IDENTITY_INSERT production.brands on;
        
        INSERT INTO production.brands
        (BRAND_ID, BRAND_NAME)
        VALUES (9, 'Trek')

        SELECT * FROM production.brands;
-- Q13: Insert three new categories at once: 'Mountain', 'Road', 'Hybrid'.
 SELECT * FROM production.categories;
 INSERT INTO production.categories
 (category_name)
 VALUES ('Mountain'), ('Road'), ('Hybrid')
        

-- Q14: Insert a new product with the following details:
--      product_name = 'Santa Cruz Bronson'
--      brand_id = (the brand_id of 'Santa Cruz' from Q12)
--      category_id = (category_id of 'Mountain' from Q13)
--      model_year = 2025
--      list_price = 4299.99

-- Q15: Copy all customers from California (state = 'CA') into a new table called sales.ca_customers_backup.
--      (Create the table first with the same structure as sales.customers)

-- ================================================================================
-- SECTION D: UPDATE STATEMENTS
-- ================================================================================

-- Q16: Update the phone number of customer with customer_id = 10 to '(555) 123-4567'.

-- Q17: Increase the list price of all products in the 'Road' category by 8%.

-- Q18: Mark all orders that have status = 4 (Completed) and shipped_date IS NULL 
--      to set shipped_date = order_date + 3 days.

-- Q19: Set the manager_id of all staffs working at store_id = 1 to staff_id = 5 
--      (assume staff_id 5 is the manager of that store).

-- Q20: Update the discount for order_items where order_id = 100 and item_id = 2 to 0.15 (15%).

-- ================================================================================
-- SECTION E: DELETE STATEMENTS
-- ================================================================================

-- Q21: Delete the brand 'Santa Cruz' you inserted in Q12.

-- Q22: Delete all order_items that have quantity = 0.

-- Q23: Delete all customers who have never placed an order (use subquery with NOT EXISTS).

-- Q24: Delete all products that have list_price > 10000 and model_year < 2020.

-- Q25: Delete the loyalty_programs table you created in Q6 (clean up).

-- ================================================================================
-- SECTION F: COMBINED & CHALLENGE QUESTIONS
-- ================================================================================

-- Q26: Write a single transaction that:
--      1. Creates a new store called 'Downtown LA'
--      2. Adds 3 new staff members to that store
--      3. Inserts 100 units of product_id = 1 into stocks for that store
--      (ROLLBACK if any step fails)

-- Q27: Change the schema of sales.order_items: add a new column 'tax_amount' DECIMAL(8,2) DEFAULT 0.00,
--      then update it to be (list_price * quantity * discount * 0.08) for all existing rows.

-- Q28: Identify and delete duplicate email addresses in sales.customers (keeping the smallest customer_id).

-- Q29: Archive all orders from year 2020 or older: 
--      Insert them into a new table sales.orders_archive, then delete from sales.orders.

-- Q30: Add a CHECK constraint to production.products ensuring list_price >= 0 AND model_year BETWEEN 1900 AND YEAR(GETDATE())+1.

-- ================================================================================
-- END OF HOMEWORK QUESTIONS
-- ================================================================================E
