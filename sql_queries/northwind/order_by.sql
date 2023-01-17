select distinct country
from customers c 
order by country ;

select distinct country
from customers c 
order by country desc;

select distinct country, city
from customers c 
order by country desc, city asc;

select ship_city, order_date 
from orders o 
where ship_city = 'London'
order by order_date;

select min(order_date) 
from orders o 
where ship_city = 'London';

select avg(unit_price)
from products p 
where discontinued <> 1;

select required_date, shipped_date
from orders o 
order by required_date desc, shipped_date;

select min(unit_price) 
from products p 
where units_in_stock > 30;

select avg(shipped_date - order_date)
from orders o 
where ship_country  = 'USA';


select sum(unit_price*units_in_stock)
from products p 
where discontinued <> 1;
