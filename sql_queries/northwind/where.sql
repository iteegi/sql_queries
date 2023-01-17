select company_name, contact_name, phone, country 
from customers c 
where country = 'USA';

select *
from products p 
where unit_price > 20;

select count(*)
from products p 
where unit_price < 20;


select city
from  customers c 
where  city <> 'Berlin';


select unit_price, units_in_stock
from products p 
where unit_price > 25 and units_in_stock > 41;


select city
from customers c 
where city='Berlin' or city='London' or city='San Francisco';

select shipped_date, freight
from orders o 
where shipped_date > '1998-04-30' and (freight < 75 or freight > 150);

select count(*)
from orders o 
where freight between 20 and 40;

select country
from customers c 
where country in ('Mexico', 'Germany', 'USA');


select country
from customers c 
where country not in ('Mexico', 'Germany', 'USA');



