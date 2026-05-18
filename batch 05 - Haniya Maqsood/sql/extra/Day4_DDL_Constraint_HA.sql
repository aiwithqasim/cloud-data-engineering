-- ================================================================================
-- HOMEWORK ANSWERS: CLASS 4 - MODIFYING DATA, DDL, DATA TYPES & CONSTRAINTS
-- Database: BikeStores Sample Database
-- ================================================================================

-- ================================================================================
-- SECTION A: DATA TYPES & CONSTRAINTS (Answers)
-- ================================================================================

-- A1: DECIMAL(5,2) or DECIMAL(6,2) depending on max weight expected
--     Example: weight DECIMAL(5,2)  (range -999.99 to 999.99)

-- A2: ZIP codes can have leading zeros (e.g., 02134). INT would remove leading zeros.
--     Also, zip codes are codes, not numbers to perform math on.

-- A3: Yes, TINYINT is perfect (0-255). It saves space (1 byte vs 4 bytes for INT) and the status has only 4 values.

-- A4: The INSERT will fail with a CHECK constraint violation error message.

-- A5: Email must be unique for login/contact reasons, but multiple staff members could share a phone number (e.g., store line).

-- ================================================================================
-- SECTION B: DDL (CREATE, ALTER, DROP) - ANSWERS
-- ================================================================================

-- A6: Create loyalty_programs table
CREATE TABLE sales.loyalty_programs (
    program_id INT IDENTITY(1,1) PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL UNIQUE,
    discount_rate DECIMAL(3,2) NOT NULL DEFAULT 0.05 CHECK (discount_rate BETWEEN 0.00 AND 0.50),
    start_date DATE NOT NULL DEFAULT GETDATE(),
    end_date DATE NULL
);

-- A7: Add column to customers
ALTER TABLE sales.customers
ADD loyalty_program_id INT NULL;

-- A8: Add foreign key constraint
ALTER TABLE sales.customers
ADD CONSTRAINT FK_customers_loyalty_program
FOREIGN KEY (loyalty_program_id) REFERENCES sales.loyalty_programs(program_id);

-- A9: Alter zip_code column
ALTER TABLE sales.customers
ALTER COLUMN zip_code VARCHAR(10);

-- A10: Add then drop birth_date column
ALTER TABLE sales.customers ADD birth_date DATE NULL;
ALTER TABLE sales.customers DROP COLUMN birth_date;

-- A11: Create product_reviews table
CREATE TABLE production.product_reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_text VARCHAR(1000) NULL,
    review_date DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (product_id) REFERENCES production.products(product_id),
    FOREIGN KEY (customer_id) REFERENCES sales.customers(customer_id)
);

-- ================================================================================
-- SECTION C: INSERT STATEMENTS - ANSWERS
-- ================================================================================

-- A12: Insert new brand
INSERT INTO production.brands (brand_name) VALUES ('Santa Cruz');

-- A13: Insert three categories
INSERT INTO production.categories (category_name) VALUES 
('Mountain'), ('Road'), ('Hybrid');

-- A14: Insert product (using subqueries to get IDs)
INSERT INTO production.products (product_name, brand_id, category_id, model_year, list_price)
VALUES (
    'Santa Cruz Bronson',
    (SELECT brand_id FROM production.brands WHERE brand_name = 'Santa Cruz'),
    (SELECT category_id FROM production.categories WHERE category_name = 'Mountain'),
    2025,
    4299.99
);

-- A15: Backup CA customers
SELECT * INTO sales.ca_customers_backup
FROM sales.customers
WHERE state = 'CA';

-- ================================================================================
-- SECTION D: UPDATE STATEMENTS - ANSWERS
-- ================================================================================

-- A16: Update specific customer phone
UPDATE sales.customers
SET phone = '(555) 123-4567'
WHERE customer_id = 10;

-- A17: Increase price for Road category products
UPDATE p
SET p.list_price = p.list_price * 1.08
FROM production.products p
INNER JOIN production.categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Road';

-- A18: Set shipped_date for completed orders
UPDATE sales.orders
SET shipped_date = DATEADD(day, 3, order_date)
WHERE order_status = 4 AND shipped_date IS NULL;

-- A19: Set manager for store 1
UPDATE sales.staffs
SET manager_id = 5
WHERE store_id = 1;

-- A20: Update specific order item discount
UPDATE sales.order_items
SET discount = 0.15
WHERE order_id = 100 AND item_id = 2;

-- ================================================================================
-- SECTION E: DELETE STATEMENTS - ANSWERS
-- ================================================================================

-- A21: Delete Santa Cruz brand
-- Note: May fail if products reference it (foreign key). Delete products first if needed.
DELETE FROM production.brands WHERE brand_name = 'Santa Cruz';

-- A22: Delete order_items with zero quantity
DELETE FROM sales.order_items WHERE quantity = 0;

-- A23: Delete customers with no orders
DELETE FROM sales.customers
WHERE NOT EXISTS (
    SELECT 1 FROM sales.orders 
    WHERE orders.customer_id = customers.customer_id
);

-- A24: Delete expensive old products
-- Check foreign keys first - may need to delete from order_items and stocks first
DELETE FROM production.products
WHERE list_price > 10000 AND model_year < 2020;

-- A25: Drop loyalty_programs table (and dependent FK first)
ALTER TABLE sales.customers DROP CONSTRAINT FK_customers_loyalty_program;
DROP TABLE sales.loyalty_programs;

-- ================================================================================
-- SECTION F: COMBINED & CHALLENGE - ANSWERS
-- ================================================================================

-- A26: Transaction for new store, staff, and stock
BEGIN TRANSACTION;
BEGIN TRY
    -- Insert store
    INSERT INTO sales.stores (store_name, phone, email, street, city, state, zip_code)
    VALUES ('Downtown LA', '(213) 555-1234', 'downtown@bikestores.com', '100 Main St', 'Los Angeles', 'CA', '90001');
    
    DECLARE @new_store_id INT = SCOPE_IDENTITY();
    
    -- Insert staff
    INSERT INTO sales.staffs (first_name, last_name, email, phone, active, store_id, manager_id)
    VALUES 
        ('John', 'Doe', 'john.doe@bikestores.com', '(213) 555-1001', 1, @new_store_id, NULL),
        ('Jane', 'Smith', 'jane.smith@bikestores.com', '(213) 555-1002', 1, @new_store_id, NULL),
        ('Bob', 'Johnson', 'bob.johnson@bikestores.com', '(213) 555-1003', 1, @new_store_id, NULL);
    
    -- Insert stock
    INSERT INTO production.stocks (store_id, product_id, quantity)
    VALUES (@new_store_id, 1, 100);
    
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    THROW;
END CATCH

-- A27: Add tax_amount column and update
ALTER TABLE sales.order_items ADD tax_amount DECIMAL(8,2) DEFAULT 0.00;
UPDATE sales.order_items
SET tax_amount = (list_price * quantity * (1 - discount) * 0.08);

-- A28: Delete duplicate emails (keep smallest customer_id)
WITH duplicates AS (
    SELECT customer_id, email,
           ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS rn
    FROM sales.customers
)
DELETE FROM sales.customers
WHERE customer_id IN (SELECT customer_id FROM duplicates WHERE rn > 1);

-- A29: Archive old orders
-- Create archive table
SELECT * INTO sales.orders_archive
FROM sales.orders
WHERE YEAR(order_date) <= 2020;
-- Delete from original
DELETE FROM sales.orders
WHERE YEAR(order_date) <= 2020;

-- A30: Add CHECK constraint for products
ALTER TABLE production.products
ADD CONSTRAINT CHK_products_list_price_year
CHECK (list_price >= 0 AND model_year BETWEEN 1900 AND YEAR(GETDATE())+1);

-- ================================================================================
-- END OF HOMEWORK ANSWERS
-- ================================================================================