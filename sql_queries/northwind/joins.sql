select product_name, s.company_name, units_in_stock 
from products p 
inner join suppliers s on p.supplier_id = s.supplier_id 
order by units_in_stock desc ;


select category_name, sum(units_in_stock)
from products p 
inner join categories c on p.category_id = c.category_id 
group by category_name 
order by sum(units_in_stock) desc 
limit 5;


select c.category_name, sum(unit_price * units_in_stock)
from products p 
inner join categories c on p.category_id = c.category_id 
where discontinued <> 1
group by c.category_name 
having sum(unit_price * units_in_stock) > 5000
order by sum(unit_price * units_in_stock) desc;


select order_id, customer_id , first_name, last_name, title
from orders o 
inner join employees e on o.employee_id = e.employee_id;


select order_date, product_name, p.unit_price 
from orders o 
inner join order_details od on o.order_id = od.order_id 
inner join products p on od.product_id = p.product_id; 


select company_name, order_id
from customers c 
left join orders o on o.customer_id = c.customer_id 
where o.order_id is null;


select count(*) 
from employees e 
left join orders o on o.employee_id = e.employee_id 
where order_id is null;


select *
from orders o 
join order_details od using (order_id)
join products p using (product_id)
join customers c using (customer_id)
join employees e using (employee_id)
where ship_country = 'USA';


select c.contact_name, concat (e.first_name,' ', e.last_name) 
from orders o 
join employees e using (employee_id)
join customers c using (customer_id)
join shippers s on o.ship_via = s.shipper_id 
where e.city='London' and c.city='London'
	and s.company_name  = 'Speedy Express';


select p.product_name, p.units_in_stock, s.contact_name, s.phone 
from products p 
join categories c using (category_id)
join suppliers s using (supplier_id)
where c.category_name in ('Beverages', 'Seafood')
and p.units_in_stock < 20
and p.discontinued = 0
order by p.units_in_stock;


select contact_name, o.order_id 
from customers c 
left join orders o using (customer_id)
where o.order_id is null
order by contact_name 

