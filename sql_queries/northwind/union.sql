select country
from customers c 
union
select country 
from employees e;


select country
from customers c 
intersect
select country 
from suppliers s ;



select country
from customers c 
except
select country 
from suppliers;



select country 
from customers c
intersect
select country 
from suppliers s 
intersect
select country 
from employees e; 



select country 
from customers c
intersect
select country 
from suppliers s 
except
select country 
from employees e; 