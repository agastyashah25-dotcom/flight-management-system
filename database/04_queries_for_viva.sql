USE flight_management_system;
-- Submitted: passenger flight INNER JOIN
SELECT p.name,f.flight_number,f.origin,f.destination,bf.status FROM passenger p
JOIN booking b ON p.passenger_id=b.passenger_id
JOIN booking_flight bf ON b.booking_id=bf.booking_id
JOIN flight f ON bf.flight_id=f.flight_id;
-- Submitted: LEFT JOIN passengers with no bookings
SELECT p.name FROM passenger p LEFT JOIN booking b ON p.passenger_id=b.passenger_id WHERE b.booking_id IS NULL;
-- Submitted: subquery payments above average
SELECT DISTINCT p.name FROM passenger p JOIN booking b ON p.passenger_id=b.passenger_id
JOIN payment pay ON pay.booking_id=b.booking_id WHERE pay.amount>(SELECT AVG(amount) FROM payment);
-- Submitted: cancelled flight subquery
SELECT flight_number FROM flight WHERE flight_id IN
(SELECT flight_id FROM booking_flight WHERE status='Cancelled');
-- Submitted: aggregates, grouping, HAVING
SELECT SUM(amount) AS total_revenue FROM payment;
SELECT payment_mode,SUM(amount) AS total,COUNT(*) AS num_transactions FROM payment GROUP BY payment_mode;
SELECT p.name,COUNT(*) AS total_bookings FROM passenger p JOIN booking b ON p.passenger_id=b.passenger_id GROUP BY p.passenger_id,p.name HAVING COUNT(*)>1;
-- Submitted view, indexes, procedure, function, cursor, trigger
SELECT * FROM booking_summary;
SHOW INDEX FROM booking;
CALL GetBookingsByPassenger('1');
SELECT booking_id,GetServiceCost(booking_id) AS service_cost FROM booking;
CALL BuildPaidReport();
SELECT * FROM booking_total_paid;
SELECT * FROM payment_audit;
-- Additional demonstrations, beyond submitted PDF:
SELECT p.name,b.booking_id FROM booking b RIGHT JOIN passenger p ON p.passenger_id=b.passenger_id;
SELECT origin AS city FROM flight UNION SELECT destination AS city FROM flight;
SELECT origin AS city FROM flight UNION ALL SELECT destination AS city FROM flight;
SELECT p.name FROM passenger p WHERE EXISTS (SELECT 1 FROM booking b WHERE b.passenger_id=p.passenger_id);
SELECT b.booking_id, (SELECT SUM(amount) FROM payment y WHERE y.booking_id=b.booking_id) AS total_paid FROM booking b;
SELECT flight_number,TIMEDIFF(STR_TO_DATE(arrival,'%H:%i'),STR_TO_DATE(departure,'%H:%i')) AS clock_time_difference FROM flight;
SELECT DATE_FORMAT(booking_date,'%d %b %Y') AS booked_on,COUNT(*) AS count FROM booking GROUP BY booking_date;
-- TCL example: deliberately no lasting change
START TRANSACTION;
UPDATE booking SET status='Waiting' WHERE booking_id='1';
SELECT status FROM booking WHERE booking_id='1';
ROLLBACK;
SELECT status FROM booking WHERE booking_id='1';
-- DCL demonstration (manual DBA-only; do not execute without user/privilege setup):
-- CREATE USER 'fms_reader'@'localhost' IDENTIFIED BY 'replace_with_strong_password';
-- GRANT SELECT ON flight_management_system.* TO 'fms_reader'@'localhost';
-- REVOKE SELECT ON flight_management_system.* FROM 'fms_reader'@'localhost';
-- DROP USER 'fms_reader'@'localhost';
