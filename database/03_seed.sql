-- Original submitted passengers, flights, services, six bookings, seven payments.
-- Supplemental presentation fields are website demo extensions.
USE flight_management_system;
INSERT IGNORE INTO passenger(passenger_id,name,email) VALUES
 ('1','Aarav Mehta','aarav.mehta@example.com'),('2','Priya Nair','priya.nair@example.com'),
 ('3','Rohan Shah','rohan.shah@example.com'),('4','Sneha Iyer','sneha.iyer@example.com'),
 ('5','Imran Khan','imran.khan@example.com');
INSERT IGNORE INTO flight(flight_id,flight_number,origin,destination,departure,arrival,duration,price,airline,aircraft,capacity) VALUES
 ('1','AI101','Mumbai','Delhi','06:40','08:50','2h 10m',5490,'Air India','Airbus A320',180),
 ('2','6E202','Delhi','Bengaluru','09:15','12:05','2h 50m',4790,'IndiGo','Airbus A321',210),
 ('3','UK303','Bengaluru','Mumbai','13:30','15:25','1h 55m',5150,'Demo Airline','Airbus A320',180),
 ('4','AI404','Mumbai','Dubai','21:10','23:05','3h 25m',17900,'Air India','Boeing 787',256),
 ('5','6E505','Chennai','Mumbai','17:20','19:20','2h 00m',4290,'IndiGo','Airbus A320',180);
INSERT IGNORE INTO service(service_id,service_name,price,description,icon) VALUES
 ('1','Extra Baggage',1500,'Add 10 kg to your checked baggage allowance','luggage'),
 ('2','In-flight Meal',450,'A freshly prepared meal for your journey','utensils'),
 ('3','Lounge Access',1200,'Unwind before boarding','coffee'),
 ('4','Priority Boarding',300,'Board early','zap');
-- Original 3-value INSERT was invalid because BOOKING has 4 columns; give explicit status.
INSERT IGNORE INTO booking(booking_id,passenger_id,status,booking_date) VALUES
 ('1','1','Confirmed','2026-09-10'),('2','2','Confirmed','2026-09-12'),
 ('3','3','Cancelled','2026-09-15'),('4','1','Confirmed','2026-09-20'),
 ('5','4','Confirmed','2026-09-25'),('6','5','Waiting','2026-09-28');
INSERT IGNORE INTO booking_flight(booking_id,flight_id,seat_number,travel_class,status) VALUES
 ('1','1','12A','Economy','Confirmed'),('2','2','8B','Business','Confirmed'),
 ('3','3','5D','Economy','Cancelled'),('4','4','3A','Business','Confirmed'),
 ('4','5','7C','Economy','Confirmed'),('5','1','14C','Economy','Confirmed'),
 ('6','2','20F','Economy','Waiting');
INSERT IGNORE INTO booking_service(booking_id,service_id,quantity) VALUES
 ('1','1',2),('1','2',1),('2','3',1),('3','2',2),('4','4',1),('5','1',1);
INSERT IGNORE INTO payment(payment_id,booking_id,amount,payment_mode,payment_date) VALUES
 ('1','1',5500,'UPI','2026-09-10'),('2','1',1500,'UPI','2026-09-11'),
 ('3','2',4800,'Credit Card','2026-09-12'),('4','3',5200,'Debit Card','2026-09-15'),
 ('5','4',18500,'Net Banking','2026-09-20'),('6','5',7000,'UPI','2026-09-25'),
 ('7','6',4800,'Cash','2026-09-28');
-- Submitted trigger test also inserted payment 8; included here as original demonstration data.
INSERT IGNORE INTO payment(payment_id,booking_id,amount,payment_mode,payment_date)
 VALUES('8','2',999,'UPI','2026-10-01');
CALL BuildPaidReport();
