# AeroFlow — Flight Management System Frontend

A complete **React + Vite** frontend for the seven-table Flight Management System described in the supplied DBMS PDF. Hybrid passenger booking website + administration console.

## What works today (without any backend)
- Search/filter/sort flights and begin reservations
- Enter passenger details, choose class and demo seat
- Add extra services with live quantity/price calculations
- Confirm a **simulated** payment and create a booking
- Look up bookings and change status
- Admin: view and add flights/passengers, view bookings, record payments
- Payment audit simulation when a new demo payment is recorded
- Reports: revenue aggregates, payment methods, booking statuses, booking summary and service-cost calculations
- Demo data persists in **your browser localStorage** across refreshes
- Responsive layout and interactive navigation

**No real ticket, airline inventory, flight schedules, card payments, authentication, or airline integrations are included.** The five original flight routes and passenger/payment records are seeded from the uploaded PDF. Flight fares, departure/arrival times, capacity and aircraft are illustrative only because those fields are not in the original database schema. The sample `UK303` airline is deliberately labeled Demo Airline rather than suggesting it represents an active airline. The demo date field is not used to filter inventory since the PDF has no flight operating-date column.

## Run on your Windows laptop

1. Install the **LTS** version of Node.js from https://nodejs.org/en/download
2. Extract the ZIP somewhere convenient, for example `Documents\FlightManagementSystem\frontend`.
3. Open the extracted folder in **VS Code** (File → Open Folder).
4. Open **Terminal → New Terminal**. Run:

   ```powershell
   node -v
   npm.cmd install
   npm.cmd run dev
   ```

5. Open the `http://localhost:5173/` address printed in the terminal.
6. Navigate among the passenger pages and management console using the sidebar. Create a demo booking to see booking/payment/audit records update.

If Windows PowerShell blocks `npm.ps1`, **use `npm.cmd`**, as shown above. You do not need to modify the Windows execution policy.

## Folder map

- `src/App.jsx`: working pages, navigation, forms and dashboard charts
- `src/styles.css`: responsive visual design
- `src/data/mockData.js`: original project seed records, plus labeled mock-enhancement fields
- `src/services/api.js`: centralized mock/live API adapter
- `src/main.jsx`: React entry point
- `.env.example`: future backend API settings

## Connect your backend later

Keep everything in mock mode today (default). When your Express + MySQL backend is ready:

1. Copy `.env.example` to `.env`.
2. Set `VITE_API_MODE=live` and `VITE_API_BASE_URL=http://localhost:5000`.
3. Implement the endpoints below with the response shapes expected by `src/services/api.js`.
4. Restart Vite after changing `.env`.

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/flights` | Return flights (with demo UI fields, or adapt UI) |
| POST | `/api/flights` | Add a flight |
| GET | `/api/passengers` | Return passengers |
| POST | `/api/passengers` | Create passenger |
| GET | `/api/services` | Return services |
| GET | `/api/bookings` | Return bookings with nested `legs[]` and `services[]` |
| POST | `/api/bookings` | Create passenger/booking/leg/services/payment atomically |
| PATCH | `/api/bookings/:id` | Update booking and flight-leg status |
| GET | `/api/payments` | Return payments |
| POST | `/api/payments` | Record payment (MySQL trigger writes audit) |
| GET | `/api/payment-audit` | Return payment audit rows |

See `api.js` for the complete payload and response shapes. Configure CORS for your Vite origin (`http://localhost:5173`). **MySQL credentials belong only in the backend**, never the React `.env`.

### Source schema compatibility items

Before enabling live mode, fix discrepancies in the original PDF SQL:
- `BOOKING`: INSERT statements contain 3 values although the table has 4 columns; list the target columns.
- `BOOKING_FLIGHT`: data and queries reference a `status` field that is missing from its CREATE TABLE definition. Add that field.
- Procedures use INT IDs while core tables use VARCHAR(10); standardize IDs.
- `FLIGHT` in PDF contains no fare, schedule, aircraft, or capacity. Either extend the MySQL schema or adapt the frontend to omit those demo fields.
- Your original PDF has no login/user accounts; introduce authentication and authorization before deploying a real customer-facing system.
- Real booking should validate seat availability, fares, status, and payment server-side, using MySQL transactions for multi-table writes. Do not trust frontend-calculated totals.

### Notes on PDF concepts

The mock report and audit screens implement **JavaScript simulations** of the PDF's SQL aggregate/view/function/trigger behavior. The actual SQL procedures, cursor, indexes, and trigger remain in your MySQL backend and will be connected where appropriate. No claim is made that a MySQL procedure or trigger is executing in mock mode.

## Reset demo data

Open browser developer tools → Application → Local Storage → remove the key `aeroflow_fms_v1`, then reload the page. This restores the seeded dataset.

## Technology

React 18, Vite 5, Lucide React, Recharts, custom CSS. Internet may be required for `npm install` and Google Fonts (fallback fonts are provided).
