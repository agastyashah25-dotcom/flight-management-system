// Based on the provided Flight Management System PDF: 7 core entities.
// Timings, airfare, aircraft and capacity are DEMO-ONLY fields absent from the PDF.
export const seedPassengers = [
  {passenger_id:'1',name:'Aarav Mehta',email:'aarav.mehta@example.com'},
  {passenger_id:'2',name:'Priya Nair',email:'priya.nair@example.com'},
  {passenger_id:'3',name:'Rohan Shah',email:'rohan.shah@example.com'},
  {passenger_id:'4',name:'Sneha Iyer',email:'sneha.iyer@example.com'},
  {passenger_id:'5',name:'Imran Khan',email:'imran.khan@example.com'}
];
export const seedFlights = [
  {flight_id:'1',flight_number:'AI101',origin:'Mumbai',destination:'Delhi',departure:'06:40',arrival:'08:50',duration:'2h 10m',price:5490,airline:'Air India',aircraft:'Airbus A320',capacity:180},
  {flight_id:'2',flight_number:'6E202',origin:'Delhi',destination:'Bengaluru',departure:'09:15',arrival:'12:05',duration:'2h 50m',price:4790,airline:'IndiGo',aircraft:'Airbus A321',capacity:210},
  {flight_id:'3',flight_number:'UK303',origin:'Bengaluru',destination:'Mumbai',departure:'13:30',arrival:'15:25',duration:'1h 55m',price:5150,airline:'Demo Airline',aircraft:'Airbus A320',capacity:180},
  {flight_id:'4',flight_number:'AI404',origin:'Mumbai',destination:'Dubai',departure:'21:10',arrival:'23:05',duration:'3h 25m',price:17900,airline:'Air India',aircraft:'Boeing 787',capacity:256},
  {flight_id:'5',flight_number:'6E505',origin:'Chennai',destination:'Mumbai',departure:'17:20',arrival:'19:20',duration:'2h 00m',price:4290,airline:'IndiGo',aircraft:'Airbus A320',capacity:180}
];
export const seedServices = [
  {service_id:'1',service_name:'Extra Baggage',price:1500,description:'Add 10 kg to your checked baggage allowance',icon:'luggage'},
  {service_id:'2',service_name:'In-flight Meal',price:450,description:'A freshly prepared meal for your journey',icon:'utensils'},
  {service_id:'3',service_name:'Lounge Access',price:1200,description:'Unwind in an airport lounge before boarding',icon:'coffee'},
  {service_id:'4',service_name:'Priority Boarding',price:300,description:'Board early and settle in comfortably',icon:'zap'}
];
export const seedBookings = [
 {booking_id:'1',passenger_id:'1',status:'Confirmed',booking_date:'2026-09-10',legs:[{flight_id:'1',seat_number:'12A',travel_class:'Economy',status:'Confirmed'}],services:[{service_id:'1',quantity:2},{service_id:'2',quantity:1}]},
 {booking_id:'2',passenger_id:'2',status:'Confirmed',booking_date:'2026-09-12',legs:[{flight_id:'2',seat_number:'8B',travel_class:'Business',status:'Confirmed'}],services:[{service_id:'3',quantity:1}]},
 {booking_id:'3',passenger_id:'3',status:'Cancelled',booking_date:'2026-09-15',legs:[{flight_id:'3',seat_number:'5D',travel_class:'Economy',status:'Cancelled'}],services:[{service_id:'2',quantity:2}]},
 {booking_id:'4',passenger_id:'1',status:'Confirmed',booking_date:'2026-09-20',legs:[{flight_id:'4',seat_number:'3A',travel_class:'Business',status:'Confirmed'},{flight_id:'5',seat_number:'7C',travel_class:'Economy',status:'Confirmed'}],services:[{service_id:'4',quantity:1}]},
 {booking_id:'5',passenger_id:'4',status:'Confirmed',booking_date:'2026-09-25',legs:[{flight_id:'1',seat_number:'14C',travel_class:'Economy',status:'Confirmed'}],services:[{service_id:'1',quantity:1}]},
 {booking_id:'6',passenger_id:'5',status:'Waiting',booking_date:'2026-09-28',legs:[{flight_id:'2',seat_number:'20F',travel_class:'Economy',status:'Waiting'}],services:[]}
];
export const seedPayments = [
 {payment_id:'1',booking_id:'1',amount:5500,payment_mode:'UPI',payment_date:'2026-09-10'},
 {payment_id:'2',booking_id:'1',amount:1500,payment_mode:'UPI',payment_date:'2026-09-11'},
 {payment_id:'3',booking_id:'2',amount:4800,payment_mode:'Credit Card',payment_date:'2026-09-12'},
 {payment_id:'4',booking_id:'3',amount:5200,payment_mode:'Debit Card',payment_date:'2026-09-15'},
 {payment_id:'5',booking_id:'4',amount:18500,payment_mode:'Net Banking',payment_date:'2026-09-20'},
 {payment_id:'6',booking_id:'5',amount:7000,payment_mode:'UPI',payment_date:'2026-09-25'},
 {payment_id:'7',booking_id:'6',amount:4800,payment_mode:'Cash',payment_date:'2026-09-28'},
 {payment_id:'8',booking_id:'2',amount:999,payment_mode:'UPI',payment_date:'2026-10-01'}
];
export const seedAudit = [{audit_id:'1',payment_id:'8',booking_id:'2',amount:999,action_time:'2026-10-01T10:00:00'}];
