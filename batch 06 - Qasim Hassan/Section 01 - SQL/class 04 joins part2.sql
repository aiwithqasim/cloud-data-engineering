
-- cross join

SELECT store_id FROM sales.stores;
SELECT brand_id FROM production.brands;

SELECT 
	s.store_id,
	p.brand_id
FROM sales.stores AS s
CROSS JOIN production.brands AS p;

-- self join
SELECT 
	e.first_name +' ' + e.last_name AS employee,
	m.first_name +' ' + m.last_name AS manager
FROM [sales].[staffs] AS e
INNER JOIN [sales].[staffs] AS m
ON e.manager_id = m.staff_id;





