--CAPSTONE PROJECT 2 BY OKORONKWO ROSE UCHECHUKWU

--Creating ba_flight_routes table
CREATE TABLE ba_flight_routes(
	flight_number VARCHAR(10)PRIMARY KEY,
	departure_city VARCHAR(20) NOT NULL,
	arrival_city VARCHAR(20),
	distance_flown INT
);

--Creating ba_fuel_efficiency
CREATE TABLE ba_fuel_efficiency(
	ac_subtype VARCHAR(10)PRIMARY KEY,
	manufacturer VARCHAR(20),
	fuel_efficiency DECIMAL(10,9),
	capacity INT
);

--Creating ba_flights table
CREATE TABLE ba_flights(
	flight_id VARCHAR(10) PRIMARY KEY,
	flight_number VARCHAR(10) REFERENCES ba_flight_routes(flight_number),
	actual_flight_date DATE,
	airline VARCHAR(10),
	status VARCHAR(10),
	delayed_flag VARCHAR(10),
	total_passengers INT,
	baggage_weight INT,
	bike_bags INT,
	revenue_from_baggage INT
);

--Creating ba_aircrafts table
CREATE TABLE ba_aircrafts(
	aircraft_id INT PRIMARY KEY,
	flight_id VARCHAR(10) REFERENCES ba_flights(flight_id),
	ac_subtype VARCHAR(10) REFERENCES ba_fuel_efficiency(ac_subtype),
	manufacturer VARCHAR(15)
);


--Q1 Which manufacturer has the best aircrafts in terms of fuel efficiency?
SELECT manufacturer, AVG(fuel_efficiency) AS avg_fuel_efficiency
FROM fuel_efficiency
GROUP BY manufacturer
ORDER BY avg_fuel_efficiency 
LIMIT 1;

--The manufacturer with the best aircraft in terms of efficiency is the Mitsubishi.

/*Q2 Does British Airways tend to use aircraft from manufacturers known for 
their superior fuel efficiency more frequently?
*/

SELECT f.manufacturer,
	COUNT(a.aircraft_id) AS no_of_aircrafts,
	AVG(f.fuel_efficiency) AS avg_fuel_efficiency
FROM aircraft AS a
JOIN fuel_efficiency AS f  ON f.ac_subtype = a.ac_subtype
GROUP BY f.manufacturer
ORDER BY no_of_aircrafts 

/*British Airways uses Boeing aircrafts more than other aircrafts 
 and Boeing also have the most superior fuel efficiency*/

--Q3 Which month did passengers cancel flights the most?
SELECT 
	EXTRACT(MONTH FROM actual_date) AS months,
	CASE
			WHEN EXTRACT(MONTH FROM actual_date) =  1 THEN 'January'
			WHEN EXTRACT(MONTH FROM actual_date) =  2 THEN 'February'
			WHEN EXTRACT(MONTH FROM actual_date) =  3 THEN 'March'
			WHEN EXTRACT(MONTH FROM actual_date) =  4 THEN 'April'
			WHEN EXTRACT(MONTH FROM actual_date) =  5 THEN 'May'
			ELSE 'June'
			END AS Months_of_the_year,
	COUNT(status) AS no_of_cancelled_flights
FROM flight
WHERE status  = 'Cancelled'
GROUP BY months
ORDER BY no_of_cancelled_flights DESC
LIMIT 1
	
--4. Which city do passengers travel to the most?
SELECT fl.arrival_city,
	SUM(f.total_passenger) AS no_of_passenger
FROM flight_routes AS fl
JOIN flight AS f ON f.flight_number = fl.flight_number
GROUP BY fl.arrival_city
ORDER BY no_of_passenger DESC
LIMIT 1

--5. What is the revenue generated from baggage overtime?
SELECT
	'$' || SUM(revenue_from_baggage) AS total_revenue_from_baggage_overtime
FROM flight

--6. What is the average number of passengers like for each month?
SELECT 
	EXTRACT(MONTH FROM actual_date) AS months,
	CASE
			WHEN EXTRACT(MONTH FROM actual_date) =  1 THEN 'January'
			WHEN EXTRACT(MONTH FROM actual_date) =  2 THEN 'February'
			WHEN EXTRACT(MONTH FROM actual_date) =  3 THEN 'March'
			WHEN EXTRACT(MONTH FROM actual_date) =  4 THEN 'April'
			WHEN EXTRACT(MONTH FROM actual_date) =  5 THEN 'May'
			ELSE 'June'
			END AS Months_of_the_year,
	ROUND(AVG(total_passenger)) AS avg_no_of_passengers
FROM flight
GROUP BY months
ORDER BY months