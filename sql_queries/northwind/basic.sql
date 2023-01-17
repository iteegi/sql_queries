select count(*)
from products;

select product_name, unit_price * units_in_stock 
from products;

select distinct city 
from employees e ;

select distinct country, city  
from employees e ;

select count(distinct country) 
from employees e ;

select count(*) region 
from employees e ;

select first_name ,region 
from employees e 
where region is null;


select country, count(*)
from suppliers s 
group by country 
order by count(*) desc;


select ship_country, sum(freight)
from orders o 
where ship_region is not null
group by ship_country 
having sum(freight) > 2750
order by sum(freight);
