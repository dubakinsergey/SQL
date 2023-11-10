--1.         Вывести список самолетов с кодами 320, 321, 733;
select * from aircrafts
where aircraft_code in('320', '321', '733');


--2.         Вывести список самолетов с кодом не на 3;
select aircraft_code, model from aircrafts
where aircraft_code not like '3%';

--3.         Найти билеты оформленные на имя «OLGA», с емайлом «OLGA» или без емайла;
select * from tickets
where passenger_name like '%OLGA%' and (contact_data ->> 'email' like '%olga%' or contact_data ->> 'email' is null);

--4.         Найти самолеты с дальностью полета 5600, 5700. Отсортировать список по убыванию дальности полета;
select model, range from aircrafts
where range in (5600,5700)
order by range desc;

--5.         Найти аэропорты в Moscow. Вывести название аэропорта вместе с городом. Отсортировать по полученному названию;
select airport_name, city from airports
where city = 'Москва'
order by airport_name;

--6.         Вывести список всех городов без повторов в зоне «Europe»;
select distinct city, timezone from airports
where timezone like '%Europe%';

--7.         Найти бронирование с кодом на «3A4» и вывести сумму брони со скидкой 10%
select book_ref, total_amount*0.9 from bookings
where book_ref like '3A4%';

--8.         Вывести все данные по местам в самолете с кодом 320 и классом «Business» строками вида «Данные по месту: номер места 1», «Данные по месту: номер места 2» … и тд
select 'Данные по месту: номер места ' || seat_no  AS seat_no from seats
where aircraft_code = '320' and fare_conditions = 'Business';

--9.         Найти максимальную и минимальную сумму бронирования в 2017 году;
select max(total_amount), min(total_amount)
from bookings
where to_char(book_date, 'YYYY') = '2017';

--10.      Найти количество мест во всех самолетах, вывести в разрезе самолетов;
select aircraft_code, count(seat_no)
from seats
group by aircraft_code;

--11.      Найти количество мест во всех самолетах с учетом типа места, вывести в разрезе самолетов и типа мест;
select aircraft_code, fare_conditions, count(*) AS seat_count
from seats
group by aircraft_code, fare_conditions
order by aircraft_code, fare_conditions;

--12.      Найти количество билетов пассажира ALEKSANDR STEPANOV, телефон которого заканчивается на 11;
select passenger_name, count(contact_data) from tickets
where passenger_name = 'ALEKSANDR STEPANOV' and (contact_data ->> 'phone' like '%11')
group by passenger_name;

--13.      Вывести всех пассажиров с именем ALEKSANDR, у которых количество билетов больше 2000. Отсортировать по убыванию количества билетов;
select passenger_name, count(ticket_no) from tickets
where passenger_name like 'ALEKSANDR%'
group by passenger_name
having count(ticket_no) > 2000
order by count(ticket_no) desc;

--14.      Вывести дни в сентябре 2017 с количеством рейсов больше 500.
select TO_CHAR(scheduled_departure, 'YYYY-MM-DD') as day, count(flight_id)
from flights
where to_char(scheduled_departure, 'YYYY-MM') = '2016-09'
group by TO_CHAR(scheduled_departure, 'YYYY-MM-DD')
having count(flight_id) > 500;

--15.      Вывести список городов, в которых несколько аэропортов
select city, count(airport_name)
from airports
group by city
having count(airport_name) > 1;

--16.      Вывести модель самолета и список мест в нем, т.е. на самолет одна строка результата
select aircraft_code, array_agg(seat_no) as seats
from seats
group by aircraft_code;

--17.      Вывести информацию по всем рейсам из аэропортов в г.Москва за сентябрь 2017
select *
from airports
join flights on airports.airport_code = flights.departure_airport
where city = 'Москва' and to_char(scheduled_departure, 'YYYY-MM') = '2017-09';

--18.      Вывести кол-во рейсов по каждому аэропорту в г.Москва за 2017
select airport_name, count(flight_id) as count_flight
from airports
join flights on airports.airport_code = flights.departure_airport
where city = 'Москва' and TO_CHAR(scheduled_departure, 'YYYY') = '2017'
group by airport_name;

--19.      Вывести кол-во рейсов по каждому аэропорту, месяцу в г.Москва за 2017
select airport_name, departure_airport, TO_CHAR(scheduled_departure, 'MM') as month, count(flight_id)
from flights
join airports on flights.departure_airport=airports.airport_code
where city = 'Москва' and TO_CHAR(scheduled_departure, 'YYYY') = '2017'
group by airport_name, departure_airport, TO_CHAR(scheduled_departure, 'MM')
ORDER BY airport_name, departure_airport, TO_CHAR(scheduled_departure, 'MM');

--20.      Найти все билеты по бронированию на «3A4B»
select ticket_no
from tickets
where book_ref like '3A4B%' ;

--21.      Найти все перелеты по бронированию на «3A4B»
select book_ref, flights.*
from tickets
join ticket_flights on tickets.ticket_no = ticket_flights.ticket_no
join flights on ticket_flights.flight_id = flights.flight_id
where book_ref like '3A4B%';