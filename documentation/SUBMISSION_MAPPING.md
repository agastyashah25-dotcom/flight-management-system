# Source-preservation mapping

## Experiment 6: ER diagram and requirement analysis
Preserved entities PASSENGER, BOOKING, FLIGHT, SERVICE, PAYMENT; relationships:
PASSENGER 1:M BOOKING; BOOKING M:M FLIGHT via BOOKING_FLIGHT (seat_number, travel_class, status); BOOKING M:M SERVICE via BOOKING_SERVICE (quantity); BOOKING 1:M PAYMENT. The same seven SQL tables are present.

## Flight Management System PDF: SQL
- Seven core tables and composite PKs: `01_schema.sql`
- Submitted five passengers, five flights, four services, six bookings, seven payments plus original trigger test payment 8: `03_seed.sql`
- Original `booking_summary` view, `GetBookingsByPassenger` procedure, `GetServiceCost` function, `BuildPaidReport` cursor, and `trg_payment_insert` audit trigger: `02_routines.sql`
- Original joins, subqueries, aggregate functions, view/index demos, and additional UNION/RIGHT JOIN/TCL/DCL examples: `04_queries_for_viva.sql`

## Deliberate corrections
1. Original `BOOKING` had 4 columns but sample insert used 3; seed explicitly populates booking status.
2. Original `BOOKING_FLIGHT` CREATE TABLE lacked `status` but ER diagram, seed and queries required it; added status.
3. Original routine args and cursor report used INT while IDs were VARCHAR(10); aligned them with VARCHAR(10).
4. Payment audit trigger created before seed so seed payments are automatically audited.
5. Sample dataset statuses reproduce the submitted flight-leg status and use matching booking-level statuses for the UI.

## Website-only fields
`flight`: departure, arrival, duration, price, airline, aircraft, capacity. `service`: description, icon. These weren't part of the original submitted ER diagram; all other original column names remain.

## Academic caveats
- The submitted flight-number `UK303` remains as historical demonstration data; no claim of current airline scheduling.
- No real payment processor or airline seat inventory. App is local, unauthenticated demo.
