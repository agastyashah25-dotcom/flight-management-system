USE flight_management_system;
DROP VIEW IF EXISTS booking_summary;
CREATE VIEW booking_summary AS
SELECT b.booking_id,p.name AS passenger_name,b.booking_date,
 COALESCE(SUM(pay.amount),0) AS total_paid
FROM booking b JOIN passenger p ON p.passenger_id=b.passenger_id
LEFT JOIN payment pay ON pay.booking_id=b.booking_id
GROUP BY b.booking_id,p.name,b.booking_date;
DROP TRIGGER IF EXISTS trg_payment_insert;
DROP PROCEDURE IF EXISTS GetBookingsByPassenger;
DROP PROCEDURE IF EXISTS BuildPaidReport;
DROP FUNCTION IF EXISTS GetServiceCost;
DELIMITER //
CREATE PROCEDURE GetBookingsByPassenger(IN p_passenger_id VARCHAR(10))
BEGIN
 SELECT b.booking_id,b.booking_date,f.flight_number,bf.status
 FROM booking b JOIN booking_flight bf ON b.booking_id=bf.booking_id
 JOIN flight f ON bf.flight_id=f.flight_id WHERE b.passenger_id=p_passenger_id;
END //
CREATE FUNCTION GetServiceCost(p_booking_id VARCHAR(10)) RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
 DECLARE total_cost DECIMAL(10,2);
 SELECT COALESCE(SUM(bs.quantity*s.price),0) INTO total_cost
 FROM booking_service bs JOIN service s ON bs.service_id=s.service_id
 WHERE bs.booking_id=p_booking_id;
 RETURN total_cost;
END //
CREATE PROCEDURE BuildPaidReport()
BEGIN
 DECLARE done INT DEFAULT 0;
 DECLARE v_booking_id VARCHAR(10);
 DECLARE v_paid DECIMAL(10,2);
 DECLARE booking_cursor CURSOR FOR SELECT booking_id FROM booking;
 DECLARE CONTINUE HANDLER FOR NOT FOUND SET done=1;
 DELETE FROM booking_total_paid;
 OPEN booking_cursor;
 read_loop: LOOP
  FETCH booking_cursor INTO v_booking_id;
  IF done=1 THEN LEAVE read_loop; END IF;
  SELECT COALESCE(SUM(amount),0) INTO v_paid FROM payment WHERE booking_id=v_booking_id;
  INSERT INTO booking_total_paid(booking_id,total_paid) VALUES(v_booking_id,v_paid);
 END LOOP;
 CLOSE booking_cursor;
END //
CREATE TRIGGER trg_payment_insert AFTER INSERT ON payment FOR EACH ROW
BEGIN
 INSERT INTO payment_audit(payment_id,booking_id,amount)
 VALUES(NEW.payment_id,NEW.booking_id,NEW.amount);
END //
DELIMITER ;
