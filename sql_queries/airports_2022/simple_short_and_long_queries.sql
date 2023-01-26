create index flight_arrival_airport on flight (arrival_airport);
create index booking_leg_flight_id on booking_leg (flight_id);
create index flight_actual_departure on flight (actual_departure);
create index boarding_pass_booking_leg_id on boarding_pass (booking_leg_id);



-- Длинный запрос
select d.airport_code as departure_airport,
	 a.airport_code as arrival_airport
from  airport a,
	airport d;



-- Короткий запрос
select f.flight_no,
       f.scheduled_departure,
	     boarding_time,
	     p.last_name,
	     p.first_name,
	     bp.update_ts as pass_issued,
	     ff.level
from flight f
	join booking_leg bl on bl.flight_id = f.flight_id
    join passenger p on p.booking_id=bl.booking_id
	join account a on a.account_id =p.account_id
	join boarding_pass bp on bp.passenger_id=p.passenger_id
	left outer join frequent_flyer ff on ff.frequent_flyer_id=a.frequent_flyer_id	
where f.departure_airport = 'JFK'
            and f.arrival_airport = 'ORD'
            and f.scheduled_departure between        
        '2022-05-29'  AND  '2022-05-31';
        
       
       
-- Длинный запрос, выводящий одну строку
select avg(flight_length),
		avg (passengers)
from (
	select flight_no, 
			scheduled_arrival -scheduled_departure as flight_length,
			count(passenger_id) passengers
  	from flight f
    	join booking_leg bl on bl.flight_id = f.flight_id
    	join passenger p on p.booking_id=bl.booking_id
	group by 1,2) a       

       