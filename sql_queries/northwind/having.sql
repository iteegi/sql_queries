select category_id, sum(unit_price*units_in_stock)
from products p 
where discontinued <> 1
group by category_id 
having sum(unit_price*units_in_stock) > 5000
order by sum(unit_price*units_in_stock)