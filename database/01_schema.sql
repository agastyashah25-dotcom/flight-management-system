-- Flight Management System: original seven-table ER model preserved.
-- Website-only extensions are explicitly marked below. MySQL 8.0+.
CREATE DATABASE IF NOT EXISTS flight_management_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE flight_management_system;
CREATE TABLE IF NOT EXISTS passenger (
 passenger_id VARCHAR(10) PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(100),
 UNIQUE KEY uq_passenger_email (email)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS flight (
 flight_id VARCHAR(10) PRIMARY KEY, flight_number VARCHAR(10) NOT NULL,
 origin VARCHAR(50) NOT NULL, destination VARCHAR(50) NOT NULL,
 -- Website extension, absent from original submitted ER diagram:
 departure VARCHAR(5) NOT NULL DEFAULT '09:00', arrival VARCHAR(5) NOT NULL DEFAULT '11:00',
 duration VARCHAR(30) DEFAULT '2h 00m', price DECIMAL(10,2) NOT NULL DEFAULT 0,
 airline VARCHAR(100) DEFAULT 'Demo Airline', aircraft VARCHAR(80) DEFAULT 'Airbus A320',
 capacity INT NOT NULL DEFAULT 180, CHECK (price>=0), CHECK (capacity>0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS service (
 service_id VARCHAR(10) PRIMARY KEY, service_name VARCHAR(100) NOT NULL,
 price DECIMAL(10,2) NOT NULL DEFAULT 0, CHECK (price>=0),
 -- website display-only extension:
 description VARCHAR(255), icon VARCHAR(30)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS booking (
 booking_id VARCHAR(10) PRIMARY KEY, passenger_id VARCHAR(10) NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'pending', booking_date DATE NOT NULL,
 CONSTRAINT fk_booking_passenger FOREIGN KEY (passenger_id) REFERENCES passenger(passenger_id),
 CHECK (status IN ('pending','Confirmed','Waiting','Cancelled'))
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS payment (
 payment_id VARCHAR(10) PRIMARY KEY, booking_id VARCHAR(10) NOT NULL,
 amount DECIMAL(10,2) NOT NULL, payment_mode VARCHAR(20), payment_date DATE,
 CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
 CHECK (amount>0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS booking_flight (
 booking_id VARCHAR(10) NOT NULL, flight_id VARCHAR(10) NOT NULL,
 seat_number VARCHAR(10), travel_class VARCHAR(20),
 -- Corrected: status was present in submitted ER & inserts, missing from submitted CREATE TABLE.
 status VARCHAR(20) NOT NULL DEFAULT 'Waiting',
 PRIMARY KEY(booking_id,flight_id),
 CONSTRAINT fk_bf_booking FOREIGN KEY(booking_id) REFERENCES booking(booking_id),
 CONSTRAINT fk_bf_flight FOREIGN KEY(flight_id) REFERENCES flight(flight_id),
 CHECK (status IN ('Confirmed','Cancelled','Waiting'))
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS booking_service (
 booking_id VARCHAR(10) NOT NULL, service_id VARCHAR(10) NOT NULL,
 quantity INT NOT NULL DEFAULT 1,
 PRIMARY KEY(booking_id,service_id),
 CONSTRAINT fk_bs_booking FOREIGN KEY(booking_id) REFERENCES booking(booking_id),
 CONSTRAINT fk_bs_service FOREIGN KEY(service_id) REFERENCES service(service_id),
 CHECK (quantity>0)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS booking_total_paid (
 booking_id VARCHAR(10) PRIMARY KEY, total_paid DECIMAL(10,2) NOT NULL DEFAULT 0,
 FOREIGN KEY(booking_id) REFERENCES booking(booking_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS payment_audit (
 audit_id INT AUTO_INCREMENT PRIMARY KEY,
 payment_id VARCHAR(10), booking_id VARCHAR(10), amount DECIMAL(10,2),
 action_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
CREATE INDEX idx_booking_passenger ON booking(passenger_id);
CREATE INDEX idx_payment_booking ON payment(booking_id);
CREATE INDEX idx_flight_route ON flight(origin,destination);
CREATE INDEX idx_bf_flight_seat ON booking_flight(flight_id,seat_number);
