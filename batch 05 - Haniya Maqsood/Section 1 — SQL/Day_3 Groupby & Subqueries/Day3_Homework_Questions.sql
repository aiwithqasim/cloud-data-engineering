-- ============================================
-- SQL Server — Class 3 Homework
-- BikeStores Sample Database
-- Topics: GROUP BY · HAVING · Subqueries · EXISTS
-- ============================================

-- Q1: Count how many products each brand has in the catalog.
-- Show brand name and product count.
-- Sort by count descending.


-- Q2: For each category, show:
-- category name,
-- total number of products,
-- cheapest price,
-- most expensive price,
-- average price (rounded to 2 decimals).
-- Sort by average price descending.


-- Q3: Show the number of orders placed per order status.
-- Display the status value and order count.
-- Sort by order_status ascending.


-- Q4: For each store, calculate total revenue:
-- (quantity × list_price × (1 – discount)) from order_items.
-- Show store name and total revenue.
-- Sort by revenue descending.


-- Q5: Show total number of products per brand per model year.
-- Display brand name, model year, and product count.
-- Sort by brand name then model year.


-- Q6: Find all brands that have more than 25 products in the catalog.
-- Show brand name and product count.


-- Q7: Among products from year 2018 only,
-- find categories whose average price is above $1500.
-- Show category name, product count, and average price.


-- Q8: Find customers who have placed 3 or more orders.
-- Show customer full name and order count.
-- Sort by order count descending.



-- Q9: Find all products whose list price is higher than
-- the average list price of all products.
-- Show product name and price.
-- Sort by price descending.


-- Q10: Find all orders placed by customers from state 'TX'.
-- Use a subquery (NOT a JOIN).
-- Show order ID, customer ID, and order date.


-- Q11: For each brand, show its average price,
-- but only for brands whose average price exceeds overall product average.
-- Use a subquery in FROM (derived table).
-- Show brand name and average price.



-- Q12: Using EXISTS:
-- Find all customers who have placed at least one order.
-- Show customer full name and email.


-- Q13: Using NOT EXISTS:
-- Find all products that have never appeared in any order (order_items).
-- Show product name and list price.
