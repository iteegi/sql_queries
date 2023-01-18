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