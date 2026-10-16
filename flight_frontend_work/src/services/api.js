/*
  SINGLE API BOUNDARY. Today: localStorage mock adapter, persistent across refreshes.
  Later: set VITE_API_MODE=live in .env and implement matching Express routes.
  Frontend components do not query MySQL directly.
*/
import {seedPassengers,seedFlights,seedServices,seedBookings,seedPayments,seedAudit} from '../data/mockData';
const SEEDS={passengers:seedPassengers,flights:seedFlights,services:seedServices,bookings:seedBookings,payments:seedPayments,audit:seedAudit};
const KEY='aeroflow_fms_v1';
export const isDemo=import.meta.env.VITE_API_MODE!=='live';
export const currency=n=>new Intl.NumberFormat('en-IN',{style:'currency',currency:'INR',maximumFractionDigits:0}).format(Number(n)||0);
export const today=()=>new Date().toISOString().slice(0,10);
const clone=x=>JSON.parse(JSON.stringify(x));
const initial=()=>clone(SEEDS);
function load(){try{const x=JSON.parse(localStorage.getItem(KEY));return x&&Object.keys(SEEDS).every(k=>Array.isArray(x[k]))?x:initial()}catch{return initial()}}
function save(s){localStorage.setItem(KEY,JSON.stringify(s));window.dispatchEvent(new CustomEvent('fms:change'))}
async function live(path,options={}){const root=import.meta.env.VITE_API_BASE_URL||'http://localhost:5000';const response=await fetch(root+path,{headers:{'Content-Type':'application/json'},...options});if(!response.ok)throw new Error((await response.json().catch(()=>({}))).message||`Request failed (${response.status})`);return response.json()}
const nextId=(rows,key)=>String(Math.max(0,...rows.map(r=>Number(r[key])||0))+1);
export const api={
 async snapshot(){if(!isDemo){const [passengers,flights,services,bookings,payments,audit]=await Promise.all(['/api/passengers','/api/flights','/api/services','/api/bookings','/api/payments','/api/payment-audit'].map(x=>live(x)));return {passengers,flights,services,bookings,payments,audit}}return load()},
 async createBooking(payload){if(!isDemo)return live('/api/bookings',{method:'POST',body:JSON.stringify(payload)});
  const s=load();let passenger=s.passengers.find(p=>p.email.toLowerCase()===payload.passenger.email.toLowerCase());if(!passenger){passenger={...payload.passenger,passenger_id:nextId(s.passengers,'passenger_id')};s.passengers.push(passenger)}
  const booking={booking_id:nextId(s.bookings,'booking_id'),passenger_id:passenger.passenger_id,status:'Confirmed',booking_date:today(),legs:[{flight_id:payload.flight_id,seat_number:payload.seat_number,travel_class:payload.travel_class,status:'Confirmed'}],services:payload.services.filter(x=>x.quantity>0)};s.bookings.push(booking);
  const pay={payment_id:nextId(s.payments,'payment_id'),booking_id:booking.booking_id,amount:payload.total,payment_mode:payload.payment_mode,payment_date:today()};s.payments.push(pay);s.audit.push({audit_id:nextId(s.audit,'audit_id'),payment_id:pay.payment_id,booking_id:booking.booking_id,amount:pay.amount,action_time:new Date().toISOString()});save(s);return booking;
 },
 async updateBooking(id,status){if(!isDemo)return live(`/api/bookings/${id}`,{method:'PATCH',body:JSON.stringify({status})});const s=load();const b=s.bookings.find(x=>x.booking_id===id);if(!b)throw Error('Booking not found');b.status=status;b.legs=b.legs.map(l=>({...l,status}));save(s);return b},
 async createFlight(payload){if(!isDemo)return live('/api/flights',{method:'POST',body:JSON.stringify(payload)});const s=load();const f={...payload,flight_id:nextId(s.flights,'flight_id')};s.flights.push(f);save(s);return f},
 async createPassenger(payload){if(!isDemo)return live('/api/passengers',{method:'POST',body:JSON.stringify(payload)});const s=load();if(s.passengers.some(p=>p.email.toLowerCase()===payload.email.toLowerCase()))throw Error('That email is already registered');const p={...payload,passenger_id:nextId(s.passengers,'passenger_id')};s.passengers.push(p);save(s);return p},
 async createPayment(payload){if(!isDemo)return live('/api/payments',{method:'POST',body:JSON.stringify(payload)});const s=load();if(!s.bookings.some(b=>b.booking_id===payload.booking_id))throw Error('Booking not found');const p={...payload,payment_id:nextId(s.payments,'payment_id'),payment_date:today(),amount:Number(payload.amount)};s.payments.push(p);s.audit.push({audit_id:nextId(s.audit,'audit_id'),payment_id:p.payment_id,booking_id:p.booking_id,amount:p.amount,action_time:new Date().toISOString()});save(s);return p},
 async reset(){if(!isDemo)throw Error('Reset is only available in demo mode');save(initial())}
};
