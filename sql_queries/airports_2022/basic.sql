-- пассажиры с 4-м уровнем
select *
from frequent_flyer ff 
where "level" = 4;


-- номера их учеиных записей
select *
from  account a 
where frequent_flyer_id in (
	select frequent_flyer_id from frequent_flyer ff where "level" = 4);
	



-- все бронирования, сделанные этими людьми 
with level4 as(
	select * 
	from account a
	where frequent_flyer_id in (
			select frequent_flyer_id
			from frequent_flyer ff
			where "level" = 4)
)
select *
from booking b 
	where  account_id in (
		select account_id
		from level4);
				

-- какие из этих бронирований относятся к рейсам из Чикаго на заданное число
with bk as (
	with level4 as (
		select * 
		from account 
			where frequent_flyer_id in (
				select frequent_flyer_id
				from frequent_flyer
				where "level" = 4)
					)
	select *
	from booking
	where account_id in (
			select account_id
			from level4)
			)
select *
from bk
	where bk.booking_id in (
		select booking_id
		from booking_leg
		where leg_num=1
			and is_returning is false
        	and flight_id in (
        		select flight_id
        		from flight
        		where departure_airport in ('ORD', 'MDW')
	    			and scheduled_departure::date='2022-09-29')
);



-- фактическое число пассажиров

with bk_chi as (
	with bk as (
		with level4 as (
			select * 
			from account
			where frequent_flyer_id in (
				select frequent_flyer_id
				from frequent_flyer
				where "level" =4)
						)
		select *
		from booking
		where account_id in (
			select account_id
			from level4)
		)
	select *
	from bk
	where bk.booking_id in (
		select booking_id
		from booking_leg 
		where leg_num=1
			and is_returning is false
    		and flight_id in (
				select flight_id
				from flight ffff
      			where departure_airport in ('ORD', 'MDW')
	     			and scheduled_departure::date = '2022-09-29')
))
select count(*)
	from passenger
	where booking_id in (
		select booking_id
		from bk_chi)
;






-- декларативный запрос, что бы бд сама решила, как выполнить запрос

select count(*)
	from booking b 
		join booking_leg bl using (booking_id)
		join flight f using(flight_id)
		join account a using (account_id)
		join frequent_flyer ff using (frequent_flyer_id)
		join passenger p using (booking_id)
	where "level" = 4;

	
select count(*)
	from booking b 
		join booking_leg bl on b.booking_id = bl.booking_id 
		join flight f on f.flight_id = bl.flight_id 
		join account a on a.account_id = b.account_id 
		join frequent_flyer ff on ff.frequent_flyer_id = a.frequent_flyer_id 
		join passenger p on p.booking_id = b.booking_id 
	where "level" = 4
		and leg_num = 1
		and is_returning is false
		and departure_airport in ('ORD', 'MDW')
		and scheduled_departure::date between '2022-09-29' and '2022-09-30';