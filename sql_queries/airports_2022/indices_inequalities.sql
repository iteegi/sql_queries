-- ���� ���� ����� ������
create index account_last_name on account (last_name);

-- ��������� ������ �� ������ ��������������� ���� ��������:
select * from account where lower(last_name) = 'daniels';


-- ������ ����� ���� �� ������� (��������������) �������������� ������:
create index account_last_name_lower on account (lower(last_name));


--��� �������� ��������������� ������� PostgreSQL ��������� ����-
--��� � ��������� ������� (��� ��������), � ����� �������� ��� ��������
--� B-������. ������� �������� B-������, ��� ���� �������� �������� �����-
--��, � �������������� ������� ���� �������� �������� �������.


-- ������ �� ������������. ������ ��� ���������� �������� ���� timestamp � ���� �������� ��������������� �������.
select *
from flight
where scheduled_departure::date between '2022-05-30' and '2022-05-31'

-- � ����� ������������. ����� ���������� �����������
select *
from flight
where scheduled_departure between '2022-05-30' and '2022-05-31'


-- ***************************************************************************************
-- � ��������� ���� ��������� ������� ��� ������� ����������� ��� update_ts::date = CURRENT_DATE, 
-- ���������� ������� ������� �� ������� update_ts. ����� ��������������� ��������,
-- �������� ������� �������� ���

-- update_ts >= CURRENT_DATE,

-- ���, ���� �������� ����� ���� � �������, ������� ������ ���� �������� ���:

--update_ts >= CURRENT_DATE AND update_ts < CURRENT_DATE + 1.
-- ***************************************************************************************



--������ �� ������������!!!
-- ������ ��� coalesce � ��� �������, ������� �������� �������� �������.
-- ����� ������� ��� ���� �������������� ������?
-- ��� ����� �������, �� �� ����� ���� �� �����.
-- ������ ����� ��������� �������� ���, ��� �������� � ��������

select * 
from flight
where coalesce(actual_departure, scheduled_departure)
	between '2022-05-30' and '2022-05-31'


-- ������ ����� ��������� ��������
select * 
from flight
where (actual_departure between '2022-05-30' and '2022-05-31')
	or (actual_departure is null
		and scheduled_departure between '2022-05-30' and '2022-05-31')


		
-- ***************************************************************************************
-- ������������ �������� � ���� �������� ����������� � ���, ��� �� ��
-- ���������� �������������� ������, ������� ��� ������ �����
-- ������ ��� B-������� �� ������������ ����� � ���������� like.
select *
from account
where lower(last_name) like 'johns%';


-- �����������
select *
from account
where (lower(last_name) >= 'johns' and lower(last_name) < 'johnt')

-- ������ �������� ���� �� ������� ������ ��� ������ �� �������:
create index account_last_name_lower_pattern
	on account (lower(last_name) text_pattern_ops);


-- ***************************************************************************************
-- ������������� ������
-- ������������ ������ �������
create index flight_depart_arr_sched_dep_inc_sched_arr
	on flight (departure_airport,
		arrival_airport,
		scheduled_departure)
		include (scheduled_arrival);
	
-- ���� ���������� �������
explain
select departure_airport,
	scheduled_departure,
	scheduled_arrival
from flight
where arrival_airport = 'JFK'
	and departure_airport ='ORD'
	and scheduled_departure between '2022-05-30' and '2022-05-31';

-- ***************************************************************************************
-- ��������� ������
create index flight_canceled on flight (flight_id)
where status = 'Canceled';

select * from flight
where scheduled_departure where '2022-05-30' and '2022-05-31'
and status = 'Canceled'

-- ***************************************************************************************
-- ���� ����������� �������� �������� � �������� ������� ������������� �����������. 
-- ��� ��������, ��� ����� ��������������� �������� ���������� ������ ����������� �������. � ����� �����
-- ������ �������� ���������� ��������� ������ ���������� ���������.

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
-- ���� ������ ������� � ������ ������� � passenger � ��� ������ ��������
-- ���������� ����������� � ���� �� �������, ���������� ���������� � �������
-- account. ������� � ���, ��� ������� account �������� ����������� ������ ����-
-- ���, ��� ������� passenger, � ���� ������������� ����� �������� ��������
-- ���������, ������ �� ������� account ���� ������ �������.

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
-- ������, ���������� ���������� ������������ ��� ������� ����� ��������� ���������

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
-- ��������� ���������� �������: 
	--������� ��������� ���� ����� ��������, ������� � ��� �������� ����.
	--��������, ������� attr1 + 0 = p_value �� ���� ������������ ������ ��� �����-
	--�� attr1. ��� ������ ���� ������ ������� coalesce ����� ����������� ��-
	--����������� ��������, �������, �����������, ��� attr2 �� ��������� ��-
	--������������ ��������, ������� ����� �������� � �������� ���-�� �����
	--coalesce(t1.attr2, '0') = coalesce(t2.attr2, '0').

-- ***************************************************************************************
select *
from boarding_pass
where update_ts between '2022-05-29' and '2022-08-18'
limit 100;

-- ���� ������ ������� ��-�� ����������
select *
from boarding_pass
where update_ts::date between '2022-05-29' and '2022-08-17'
order by 1
limit 100;








