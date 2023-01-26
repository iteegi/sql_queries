explain
select f.flight_no,
       f.actual_departure,
       count(passenger_id) passengers
from flight f
	join booking_leg bl on bl.flight_id = f.flight_id
    join passenger p on p.booking_id=bl.booking_id
where f.departure_airport = 'JFK'
	and f.arrival_airport = 'ORD'
   	and f.actual_departure between       
        '2022-05-30' and '2022-05-31'
group by f.flight_id, f.actual_departure;


