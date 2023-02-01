--������ ��������� �������, ���� ������������� ������� ������ �� ������� ���� ���
--����� �� ������� ������; �� ���� ���������, ���� ���� �� �������, ������������ �����
--����� ��������.


-- �������� ������� ������� ������� �������� �� ��������, ���������� � �������� ������.
-- ��� ������� �������� ��� ��������: ������� �� �����, � ���� ������� ����������������, ���� ���������,
-- ��� ������� �� ������������.


-- �������� ���������� ������������ � ������ ������ ����������������




--������� ������, ������������ ��������� �����
select d.airport_code as departure_airport,
	a.airport_code as arrival_airport
from airport a,
	airport d
where a.airport_code <> d.airport_code;


-- ������� ������, ������������ ���� ������
select avg(flight_length),
	avg (passengers)
from (select flight_no,
			scheduled_arrival - scheduled_departure as flight_length,
			count(passenger_id) passengers
	from flight f
		join booking_leg bl on bl.flight_id = f.flight_id
		join passenger p on p.booking_id = bl.booking_id
		group by 1,2 ) a;
		


	
-- **************************************************************************************
-- ������� ���������� ����� ��������, ������ ��� �����, ����� ������������� ������
-- ������ ���� ��� ����� ������.

-- ����� �������� ��������������� ����������� (�� ���� ����������, ������� ������� �����
-- ��������� ���������� �������������� �����) � ������� �������� ��������������.
-- �������������� ���� ������ R � S ���������� ������ �� ������� R, ��� ������� ����
-- ���� �� ���� ������ �� ������� S � ������������ ���������� � ����������� ��������


--�������������� � ������ �������������, ��������������� ���� ��������. 
--��-������, � �������������� ��������� ���������� ������ ������� �� ������ �������.
--��-������, ������ �� ������ ������� �� �����������, ���� �� ������ ������� ��� ���
--���� ��������� ������������. ���� ����� �������������� ������ �� ����-
--�������� �������� ����� JOIN.


-- 1
-- ������������� �������������� � ������� ��������� ����� EXISTS
select *
from flight f
where exists
	(select flight_id from booking_leg where flight_id = f.flight_id);



-- 2
-- ������������� �������������� � ������� ��������� ����� IN
select *
from flight
where flight_id in
	(select flight_id from booking_leg);
	
-- **************************************************************************************
--�������������� ������� �� ����������� ������ ������ �����������.
--�������, ��� ��������, ���� ���� ������� �������������� ����������� � �������� ����� �� ������.
--� ��� �������, ����� ������� �������������� ��������� �� ��������� ������, ��� ������� �����
--��������� �� ���������� ��������������.
	
explain
select departure_airport, booking_id, is_returning
from booking_leg bl
join flight f using (flight_id)
where departure_airport in
		(select airport_code from airport where iso_country = 'US')
	and bl.booking_id in
		(select booking_id from booking where update_ts > '2022-07-01');
-- **************************************************************************************
		
--�������������� ���� ������ R � S ���������� ������ �� ������� R, ��� ������� � ������� S 
--��� ����� � ����������� ��������� � ������� ����������.

-- ������������� �������������� � ������� NOT EXISTS
-- PostgreSQL ������ ������ � NOT EXISTS ����������� ������� �������������� � ����� ����������
select *
from flight f
where not exists
	(select flight_id
	from booking_leg
	where flight_id = f.flight_id);
	

-- ������������� �������������� � ������� NOT IN
select *
from flight
where flight_id not in
	(select flight_id
	from booking_leg);
		
-- **************************************************************************************
	
explain
select *
from flight f
join (select distinct flight_id from booking_leg) bl using (flight_id);



-- **************************************************************************************

-- ���������� ����������� �����������
set join_collapse_limit=1;

explain
select departure_airport, booking_id, is_returning
from booking_leg bl
	join flight f using (flight_id)
where departure_airport in
		(select airport_code from airport where iso_country = 'US')
	and bl.booking_id in
		(select booking_id from booking where update_ts > '2022-05-30');

-- **************************************************************************************
		
-- ������� ���� ������ � ����� ���������� ���������� �� ����� �����

select * from (
	select bl.flight_id,
		departure_airport,
		(avg(price))::numeric (7,2) as avg_price,
		count(distinct passenger_id) as num_passengers
	from booking b
		join booking_leg bl using (booking_id)
		join flight f using (flight_id)
		join passenger p using (booking_id)
	group by 1,2
	) a
where flight_id = 222183;

-- ���������� ���� ��������, ������������ � ����������� GROUP BY, ������ �����������
-- �� ������ �����������.


-- ����������� ������� �� ������� GROUP BY. ������ �������, ��� ������ ����
select bl.flight_id,
	departure_airport,
	(avg(price))::numeric (7,2) as avg_price,
	count(distinct passenger_id) as num_passengers
from booking b
	join booking_leg bl using (booking_id)
	join flight f using (flight_id)
	join passenger p using (booking_id)
where flight_id = 222183
group by 1,2;


-- **************************************************************************************

-- ������� ���������, ����� ���������� !!!!

-- ������������
-- ������� ������ ����������� �� ������� �����������
-- ��������

explain
select a.flight_id,
	a.avg_price,
	a.num_passengers
from (
	select bl.flight_id,
		departure_airport,
		(avg(price))::numeric (7,2) as avg_price,
		count(distinct passenger_id) as num_passengers
	from booking b
		join booking_leg bl using (booking_id)
		join flight f using (flight_id)
		join passenger p using (booking_id)
	group by 1,2
	) a
where flight_id in (
	select flight_id
	from flight
	where scheduled_departure between '07-03-2020' and '07-05-2020'
	);


-- ������� ���������� �� ������� �����������
-- ������� ������

select bl.flight_id,
	departure_airport,
	(avg(price))::numeric (7,2) as avg_price,
	count(distinct passenger_id) as num_passengers
from booking b
	join booking_leg bl using (booking_id)
	join flight f using (flight_id)
	join passenger p using (booking_id)
where scheduled_departure between '07-03-2020' and '07-05-2020'
group by 1,2

-- **************************************************************************************

-- ������� ����� �����, ����� ��������
-- GROUP BY ������� ��������� ��� ����� ������, � ����� ��������� ������ ��������

-- ������ ���������� ���������� �� ������ � ������
-- ��������
select city,
	date_trunc('month', scheduled_departure) as month,
	count(*) passengers
from airport a
	join flight f on airport_code = departure_airport
	join booking_leg l on f.flight_id =l.flight_id
	join boarding_pass b on b.booking_leg_id = l.booking_leg_id
group by 1,2
order by 3 DESC


-- ������������ ������, � ������� ������� ����������� �����������

select city,
	date_trunc('month', scheduled_departure),
	sum(passengers) passengers
from airport a
	join flight f on airport_code = departure_airport
	join (
		select flight_id, count(*) passengers
		from booking_leg l
			join boarding_pass b using (booking_leg_id)
		group by flight_id
	) cnt using (flight_id)
group by 1,2
order by 3 desc

-- **************************************************************************************
-- ������������� EXCEPT ������ NOT IN
-- �������� �������

select flight_id from flight f
except
select flight_id from booking_leg


-- **************************************************************************************

-- ������������� INTERSECT ������ IN
select flight_id from flight f
intersect
select flight_id from booking_leg

-- **************************************************************************************
-- ������ �� �������� ��������� � OR

select case
	when actual_departure > scheduled_departure + interval '1 hour'
		then 'late group 1'
		else 'late group 2'
	end as grouping,
	flight_id,
	count(*) as num_passengers
from boarding_pass bp
	join booking_leg bl using (booking_leg_id)
	join booking b using (booking_id)
	join flight f using (flight_id)
where departure_airport = 'FRA'
	and actual_departure > '2022-07-01'
	and (
		( actual_departure > scheduled_departure + interval '30 minute'
			and actual_departure <= scheduled_departure + interval '1 hour'
		)
		or
		( actual_departure>scheduled_departure + interval '1 hour'
			and bp.update_ts > scheduled_departure + interval '30 minute'
		)
	)
group by 1,2


-- ������� ������� � OR ����������, ��������� UNION ALL
-- ����� ��� �������� ������ �������

select 'late group 1' as grouping,
	flight_id,
	count(*) as num_passengers
from boarding_pass bp
	join booking_leg bl using (booking_leg_id)
	join booking b using (booking_id)
	join flight f using (flight_id)
where departure_airport = 'FRA'
	and actual_departure > scheduled_departure + interval '1 hour'
	and bp.update_ts > scheduled_departure + interval '30 minutes'
	and actual_departure > '2022-07-01'
group by 1,2
union all
select 'late group 2' as grouping,
	flight_id,
	count(*) as num_passengers
from boarding_pass bp
	join booking_leg bl using(booking_leg_id)
	join booking b using (booking_id)
	join flight f using (flight_id)
where departure_airport = 'FRA'
	and actual_departure > scheduled_departure + interval '30 minute'
	and actual_departure <= scheduled_departure + interval '1 hour'
	and actual_departure > '2022-07-01'
group by 1,2

-- **************************************************************************************

-- ������������ ������������ ������� �������

select first_name,
	last_name,
	pn.custom_field_value as passport_num,
	pe.custom_field_value as passport_exp_date,
	pc.custom_field_value as passport_country
from passenger p
	join custom_field pn on pn.passenger_id = p.passenger_id
		and pn.custom_field_name = 'passport_num'
	join custom_field pe on pe.passenger_id = p.passenger_id
		and pe.custom_field_name = 'passport_exp_date'
	join custom_field pc on pc.passenger_id = p.passenger_id
		and pc.custom_field_name = 'passport_country'
where p.passenger_id < 5000000
	

-- ���������� ������

select last_name,
	first_name,
	passport_num,
	passport_exp_date,
	passport_country
from passenger p
	join (
		select cf.passenger_id,
			coalesce(max(case when custom_field_name = 'passport_num'
							then custom_field_value else null
						end),'') as passport_num,
			coalesce(max(case when custom_field_name = 'passport_exp_date'
							then custom_field_value else null
						end),'') as passport_exp_date,
			coalesce(max(case when custom_field_name = 'passport_country'
							then custom_field_value else null
						end),'') as passport_country
		from custom_field cf
		where cf.passenger_id < 5000000
		group by 1
	) info using (passenger_id)
where p.passenger_id < 5000000


-- **************************************************************************************

-- ��������� �����, ����������� ������

CREATE MATERIALIZED VIEW flight_departure_prev_day AS
SELECT bl.flight_id,
	departure_airport,
	coalesce(actual_departure,
	scheduled_departure)::date departure_date,
	count(DISTINCT passenger_id) AS num_passengers
FROM booking bJOIN booking_leg bl USING (booking_id)
	JOIN flight f USING (flight_id)
	JOIN passenger p USING (booking_id)
WHERE (actual_departure BETWEEN CURRENT_DATE � 1 AND CURRENT_DATE)
	OR (actual_departure IS NULL
		AND	scheduled_departure BETWEEN CURRENT_DATE � 1 AND CURRENT_DATE)
GROUP BY 1,2,3


-- **************************************************************************************
-- **************************************************************************************
-- **************************************************************************************
-- **************************************************************************************
�
-- **************************************************************************************
-- **************************************************************************************
-- **************************************************************************************
-- **************************************************************************************
-- **************************************************************************************