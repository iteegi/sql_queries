-- Если есть такой индекс
create index account_last_name on account (last_name);

-- Следующий запрос не сможет воспользоваться этим индексом:
select * from account where lower(last_name) = 'daniels';


-- Однако лучше было бы создать (дополнительный) функциональный индекс:
create index account_last_name_lower on account (lower(last_name));


--При создании функционального индекса PostgreSQL применяет функ-
--цию к значениям столбца (или столбцов), а затем помещает эти значения
--в B-дерево. Подобно обычному B-дереву, где узлы содержат значения столб-
--ца, в функциональном индексе узлы содержат значения функции.


-- индекс не используется. Потому что приведение значения типа timestamp к дате является преобразованием столбца.
select *
from flight
where scheduled_departure::date between '2022-05-30' and '2022-05-31'

-- а здесь используется. Время выполнения уменьшиться
select *
from flight
where scheduled_departure between '2022-05-30' and '2022-05-31'


-- ***************************************************************************************
-- В девяноста пяти процентах случаев это условие формулируют как update_ts::date = CURRENT_DATE, 
-- фактически лишаясь индекса по столбцу update_ts. Чтобы воспользоваться индексом,
-- критерий следует записать как

-- update_ts >= CURRENT_DATE,

-- или, если значения могут быть в будущем, условие должно быть написано так:

--update_ts >= CURRENT_DATE AND update_ts < CURRENT_DATE + 1.
-- ***************************************************************************************



--Индекс не используется!!!
-- Потому что coalesce – это функция, которая изменяет значения столбца.
-- Нужно создать еще один функциональный индекс?
-- Это можно сделать, но на самом деле не нужно.
-- Вместо этого перепишем оператор так, как показано в листинге

select * 
from flight
where coalesce(actual_departure, scheduled_departure)
	between '2022-05-30' and '2022-05-31'


-- Вместо этого перепишем оператор
select * 
from flight
where (actual_departure between '2022-05-30' and '2022-05-31')
	or (actual_departure is null
		and scheduled_departure between '2022-05-30' and '2022-05-31')


		
-- ***************************************************************************************
-- Единственная проблема с этим запросом заключается в том, что он не
-- использует функциональный индекс, который был создан ранее
-- потому что B-деревья не поддерживают поиск с оператором like.
select *
from account
where lower(last_name) like 'johns%';


-- преобразуем
select *
from account
where (lower(last_name) >= 'johns' and lower(last_name) < 'johnt')

-- Лучшим решением было бы создать индекс для поиска по шаблону:
create index account_last_name_lower_pattern
	on account (lower(last_name) text_pattern_ops);


-- ***************************************************************************************
-- Перекрывающий индекс
-- сканирование только индекса
create index flight_depart_arr_sched_dep_inc_sched_arr
	on flight (departure_airport,
		arrival_airport,
		scheduled_departure)
		include (scheduled_arrival);
	
-- План выполнения запроса
explain
select departure_airport,
	scheduled_departure,
	scheduled_arrival
from flight
where arrival_airport = 'JFK'
	and departure_airport ='ORD'
	and scheduled_departure between '2022-05-30' and '2022-05-31';

-- ***************************************************************************************
-- частичный индекс
create index flight_canceled on flight (flight_id)
where status = 'Canceled';

select * from flight
where scheduled_departure where '2022-05-30' and '2022-05-31'
and status = 'Canceled'

-- ***************************************************************************************
-- Цель оптимизации коротких запросов – избежать больших промежуточных результатов. 
-- Это означает, что самые ограничительные критерии фильтрации должны применяться первыми. И затем после
-- каждой операции соединения результат должен оставаться небольшим.

-- ***************************************************************************************
create index account_login on account (login);
create index account_login_lower_pattern
on account (lower(login) text_pattern_ops);
create index passenger_last_name on passenger (last_name);
create index boarding_pass_passenger_id on boarding_pass (passenger_id);
create index passenger_last_name_lower_pattern
on passenger (lower(last_name) text_pattern_ops);
create index passenger_booking_id on passenger (booking_id);
create index booking_account_id on booking (account_id);
-- ***************************************************************************************
-- хотя первая таблица в тексте запроса – passenger и что первый критерий
-- фильтрации применяется к этой же таблице, выполнение начинается с таблицы
-- account. Причина в том, что таблица account содержит значительно меньше запи-
-- сей, чем таблица passenger, и хотя селективность обоих фильтров примерно
-- одинакова, индекс по таблице account даст меньше записей.

explain
select b.account_id,
a.login,
p.last_name,
p.first_name
from passenger p
	join booking b using(booking_id)
	join account a on a.account_id = b.account_id
where lower(p.last_name) = 'smith'
	and lower(login) like 'smith%'


-- ***************************************************************************************
create index frequent_fl_last_name_lower_pattern
on frequent_flyer (lower(last_name) text_pattern_ops);
create index frequent_fl_last_name_lower on frequent_flyer (lower(last_name));
	
-- ***************************************************************************************
-- Запрос, выбирающий количество бронирований для каждого часто летающего пассажира

explain
select a.account_id,
	a.login,
	f.last_name,
	f.first_name,
	count(*) as num_bookings
from frequent_flyer f
	join account a using(frequent_flyer_id)
	join booking b using(account_id)
where lower(f.last_name) = 'smith'
	and lower(login) like 'smith%'
group by 1,2,3,4

-- ***************************************************************************************
-- Избежание применения индекса: 
	--Столбец числового типа можно изменить, добавив к его значению ноль.
	--Например, условие attr1 + 0 = p_value не даст использовать индекс для столб-
	--ца attr1. Для любого типа данных функция coalesce будет блокировать ис-
	--пользование индексов, поэтому, предполагая, что attr2 не допускает не-
	--определенных значений, условие можно изменить и написать что-то вроде
	--coalesce(t1.attr2, '0') = coalesce(t2.attr2, '0').

-- ***************************************************************************************
select *
from boarding_pass
where update_ts between '2022-05-29' and '2022-08-18'
limit 100;

-- Этот запрос быстрее из-за сортировки
select *
from boarding_pass
where update_ts::date between '2022-05-29' and '2022-08-17'
order by 1
limit 100;








