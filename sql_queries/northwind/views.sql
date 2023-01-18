create view products_suppliers_categories as
select product_name, quantity_per_unit, unit_price,
	units_in_stock, company_name, contact_name, phone,
	category_name, description
from products p 
join suppliers s using (supplier_id)
join categories c using (category_id);




select *
from products_suppliers_categories psc;


select *
from products_suppliers_categories psc 
where unit_price > 20;


drop view if exists products_suppliers_categories;



--=======================


create view heavy_orders as
select *
from orders o 
where freight > 50;


select *
from heavy_orders ho 
order by freight ;


create or replace view heavy_orders as
select *
from orders o 
where freight > 100;


--=======================

alter view orders_customers_employees rename to o_old;


create or replace view orders_customers_employees as
select order_date, required_date , shipped_date,
	ship_postal_code, company_name, contact_name,
	phone, last_name, first_name, title
from orders o 
join customers c using (customer_id)
join employees using (employee_id);


select *
from orders_customers_employees oce 
where order_date > '1997-01-01';


drop view if exists o_ld;
