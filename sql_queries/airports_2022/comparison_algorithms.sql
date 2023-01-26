
-- Index Scan
explain
SELECT flight_no, departure_airport, arrival_airport
FROM flight
  WHERE scheduled_departure BETWEEN
'2022-05-29'  AND  '2022-05-30';


-- ���� � ��� �� ������, ������ ���������� �������� ���.
-- �� ��� Bitmap Scan 
explain
SELECT flight_no, departure_airport, arrival_airport
FROM flight
  WHERE scheduled_departure BETWEEN
'2022-05-29'  AND  '2022-05-31';


