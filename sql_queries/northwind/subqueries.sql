select company_name 
from suppliers s 
where country in (
	select distinct country
	from customers c);
	

select category_name, sum(units_in_stock)
from products p 
inner join categories c using (category_id)
group by category_name
order by sum(units_in_stock) desc 
limit (select min(product_id) + 4 
		from products p2 );

	
	

select product_name, units_in_stock 
from products p 
where units_in_stock > (
	select avg(units_in_stock)
	from products p2 )
order by units_in_stock;




select company_name, contact_name 
from customers c 
where exists (select customer_id from orders o
				where customer_id = c.customer_id
				and freight between 50 and 100);

			
select company_name, contact_name 
from customers c 
where exists (select customer_id from orders o
				where customer_id = c.customer_id
				and order_date between '1995-02-01' and '1995-02-15');
				
				
				
select product_name 
from products p 
where not exists (
	select order_id
	from orders o
	join order_details od using (order_id)
	where od.product_id = product_id
	and order_date between '1995-02-01' and '1995-02-15');



select order_id
from orders o
join order_details od using (order_id)
where od.product_id = product_id
	and order_date between '1995-02-01' and '1995-02-15';


select distinct company_name
from customers c 
where customer_id = any (
	select customer_id
	from orders o
	join order_details od using (order_id)
	where quantity > 40);


select distinct product_name, quantity
from products p 
join order_details od using (product_id)
where quantity > (
	select avg(quantity)
	from order_details od2)
order by quantity desc;


select distinct product_name, quantity
from products p 
join order_details od using (product_id)
where quantity > all (
	select avg(quantity)
	from order_details od2
	group by product_id)
order by quantity;



select product_name, units_in_stock 
from products p 
where units_in_stock < all(
	select  avg(quantity)
	from order_details od
	group by product_id)
order by units_in_stock desc;


select customer_id, sum(freight) as freight_sum
from orders o 
inner join (
	select customer_id, avg(freight) as freight_avg
	from orders o2
	group by customer_id) as oa
		using (customer_id)
where freight > freight_avg  and shipped_date between '1996-07-16' and '1996-07-31'
group by customer_id 
order by freight_sum;





select customer_id, ship_country, order_price
from orders o 
join (
	select order_id, sum(unit_price*quantity-unit_price*quantity*discount) as order_price
	from order_details od
	group by order_id) as od
		using (order_id)
where ship_country in ('Argentina', 'Bolivia', 'Brazil')
	and order_date = '1997-09-01'
order by order_price desc 
limit 3