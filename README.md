# Flight Management System — Full-stack college DBMS project

## What is included
- `flight_frontend_work/`: original React/Vite frontend with its existing UI preserved
- `backend/`: Express API with MySQL 8 connection and parameterized operations
- `database/`: original seven-table ER model, corrected seed data, view, procedures, function, cursor, trigger, and viva queries
- `documentation/`: mapping to submitted PDFs and testing instructions

> **Demo only:** ticket prices, flight schedules and aircraft are website additions, not present in the submitted ER diagram. Payments are simulated record entries, **not money transfers**. There is no login/role-based authorization, so this must only run on a trusted local machine, not be deployed publicly.

## Step 1: MySQL Workbench
1. Start your MySQL server and connect using Workbench.
2. Use **File → Open SQL Script** and run, in this exact order, on a fresh schema:
   - `database/01_schema.sql`
   - `database/02_routines.sql`
   - `database/03_seed.sql`
3. Open `database/04_queries_for_viva.sql` and run individual examples. The TCL snippet intentionally rolls back changes. DCL examples are comments only.
4. Verify: `USE flight_management_system; SHOW TABLES; SELECT * FROM booking_summary; SELECT * FROM payment_audit;`

**Existing database?** These scripts are designed for a new database. Back up any previous `flight_management_system` schema before use; `01_schema.sql` does not migrate existing table definitions. The indexes may error if already created. Do not drop existing tables without a backup.

## Step 2: Backend
In VS Code, open this top-level extracted folder. In a new terminal:
```powershell
cd backend
npm.cmd install
Copy-Item .env.example .env
```
Edit `backend/.env` and set `DB_PASSWORD` to your local MySQL password. Never upload/share this file.
```powershell
npm.cmd run dev
```
Visit http://localhost:5000/api/health; expect `{"status":"ok","database":"connected","mode":"demonstration"}`.

## Step 3: Frontend
In another VS Code terminal from the top-level project folder:
```powershell
cd flight_frontend_work
npm.cmd install
Copy-Item .env.example .env
```
Set in `flight_frontend_work/.env`:
```env
VITE_API_MODE=live
VITE_API_BASE_URL=http://localhost:5000
```
Then:
```powershell
npm.cmd run dev
```
Open http://localhost:5173. If you want to use the browser-only demo instead, change `VITE_API_MODE=mock` then restart Vite.

## Step 4: Confirm connectivity
- Admin → Flight inventory displays the seeded original 5 flight routes.
- Passenger → book a flight. Use a **new, unoccupied seat**, e.g. `17B` on `AI101`.
- Admin → Bookings lists the new booking; Payments lists a **demonstration** transaction.
- Workbench: `SELECT * FROM booking ORDER BY CAST(booking_id AS UNSIGNED) DESC;`
- Verify related rows: `SELECT * FROM booking_flight; SELECT * FROM payment_audit ORDER BY audit_id DESC;`
- Cancel booking from UI; status should update in `booking` and `booking_flight`.

## API endpoints
`GET /api/health`, `/api/passengers`, `/api/flights`, `/api/services`, `/api/bookings`, `/api/payments`, `/api/payment-audit`; `POST /api/passengers`, `/api/flights`, `/api/bookings`, `/api/payments`; `PATCH /api/bookings/:id`; reporting routes in backend/server.js.

## Limitations
- All sample dates, passenger data and prices are illustrative. No external airline inventory API.
- Payment creation is a database record only, not a payment gateway.
- Frontend does not have authentication; admin endpoints are not access-controlled. Local academic demonstration only.
- Composite PK in `booking_flight` allows one occurrence of each flight per booking. Matches submitted ER model.
- Business class uses the existing frontend demo multiplier (1.8× base fare). Server independently calculates the amount; it does not trust the browser total.
- IDs are varchar to preserve the submitted design; auto-increment via `MAX(CAST(id AS UNSIGNED))` is suitable only for single-user classroom demos, not concurrent production systems.
