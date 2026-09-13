select 
s.first_name,
s.staff_id,
o.order_id,
o.order_date
from sales.staff as s
left Join sales.orders on 
s.store_id = o.order_id;