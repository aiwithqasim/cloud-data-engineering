-- ================================================================================
-- HOMEWORK: CLASS 5 - CTEs, PIVOT, EXPRESSIONS & WINDOW FUNCTIONS (EASY VERSION)
-- Database: BikeStores Sample Database
-- Instructions: Write SQL statements to solve each problem below.
-- ================================================================================

-- ================================================================================
-- SECTION A: CASE Expressions 
-- ================================================================================

-- Q1: Write a simple CASE that shows order_status as a word instead of number.
--     Show order_id, order_status (number), and status_description (word).

-- Q2: Categorize products by price:
--     Under $500 = 'Budget'
--     $500 to $2000 = 'Standard' 
--     Over $2000 = 'Premium'
--     Show product_name, list_price, and price_category.

-- Q3: Using CASE with COUNT, count how many orders have status = 4 (Completed) 
--     vs non-completed for each store. Show store_id, completed_count, not_completed_count.

-- Q4: Create a column called "year_label" that shows:
--     If model_year = 2024: 'New'
--     If model_year = 2023: 'Recent'
--     Else: 'Older'
--     Show product_name, model_year, year_label.

-- Q5: For customers, show email and a column called "has_email" that says 'Yes' if email is not NULL, 'No' if NULL.

-- ================================================================================
-- SECTION B: CTEs (Common Table Expressions)
-- ================================================================================

-- Q6: Create a CTE called "high_value_products" that selects products with list_price > 3000.
--     Then SELECT from that CTE to show all those products.

-- Q7: Write a CTE that calculates the average list_price of all products.
--     Then use it to find products that cost more than average.

-- Q8: Create a CTE called "customer_order_counts" that counts how many orders each customer has.
--     Then use it to find customers with more than 5 orders.


-- ================================================================================
-- SECTION C: ROW_NUMBER() and RANK() - EASY BEGINNER
-- ================================================================================

-- Q9: Use ROW_NUMBER() to number all products ordered by list_price from highest to lowest.
--      Show product_name, list_price, and row_number.

-- Q10: Use ROW_NUMBER() to rank products by price WITHIN each brand (partition by brand_id).
--      Show brand_id, product_name, list_price, and rank_in_brand.


-- Q11: Use RANK() instead of ROW_NUMBER() on products ordered by list_price.
--      See what happens when multiple products have the same price.


-- ================================================================================
-- SECTION D: Window Functions - Running Totals and Averages
-- ================================================================================

-- Q12: Calculate a running total of daily orders (cumulative sum over time).
--      Show order_date, daily_order_count, and running_total.

-- Q13: For each product, show its list_price and the average list_price of its brand.
--      Use AVG() OVER (PARTITION BY brand_id).

-- Q14: Calculate a running total of quantity sold for each product over time.
--      Show product_id, order_date, quantity, and cumulative_quantity for that product.


-- ================================================================================
-- SECTION E: LAG, LEAD (Previous and Next)
-- ================================================================================

-- Q15: For each customer, show their order date and the date of their previous order.
--      Use LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date).

-- Q16: Calculate the number of days between a customer's consecutive orders.
--      (Use LAG and DATEDIFF)


-- ================================================================================
-- SECTION F: PIVOT (Rows to Columns)
-- ================================================================================

-- Q17: Create a simple pivot showing the count of orders for each order_status (1,2,3,4) 
--      as separate columns. Only need store_id and the 4 status columns.


-- ================================================================================
-- SECTION G: Mixed Practice (Putting It All Together)
-- ================================================================================

-- Q18: Use CASE to categorize customers by total spending:
--      Over $5000 = 'VIP'
--      $1000-$5000 = 'Regular'
--      Under $1000 = 'New'
--      Show customer_name and tier.

-- Q19: Use ROW_NUMBER() and CASE together: Find top 3 products per category, 
--      and label them as 'Gold', 'Silver', 'Bronze'.

-- Q20: Create a CTE that calculates monthly revenue, then use LAG to show month-over-month growth.

-- Q21: Write a query that shows each product, its price, its rank in its brand, 
--      and a CASE that says 'Top Product' if rank = 1, else 'Other'.

-- Q22: Create a pivot showing the count of customers by state and by customer tier 
--      (you'll need to create the tier using CASE first, then pivot).

-- ================================================================================
-- END OF HOMEWORK - ALL QUESTIONS ARE BEGINNER-FRIENDLY
-- ================================================================================