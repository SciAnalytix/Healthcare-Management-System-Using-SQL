create database Hospital;

use Hospital;

create table appointments(
Appointment_id int,
Patient_id int,
Doctor_id int,
Appointment_date date,
Appointment_time time,
Appointment_status text
);

create table billing(
Bill_id int,
Appointment_id int,
Amount double,
Payment_status text,
Payment_Date date
);

select* from patients;
select* from billing;
select* from appointments;
select* from prescriptions;
select* from doctors;

 /*  Beginner Level (Basic SELECTs, WHERE, ORDER BY, JOIN)  */

-- 1. List all patients with their name, age, and gender.
select name as Patient_name, age as Patient_age, gender as Patient_gender from patients;

-- 2. List all doctors and their specialties.
select name , specialty from doctors;

-- 3. Show all appointments scheduled after 2025-01-01.
select * from appointments
where Appointment_date> '2025-01-01'
order by Appointment_date asc;

-- 4. Find all appointments for a specific doctor, e.g., Doctor_ID = 5.
select* from appointments
where Doctor_id= 15;

-- 5. List all prescriptions with medicine name and dosage.
select prescription_id, medicine, dosage from prescriptions;

-- 6. Get all bills where payment status is 'Pending'.
select* from billing
where payment_status = 'Pending';

-- 7. Find doctors who are Cardiologists.
select name from doctors
where specialty= 'Cardiologist';

-- 8. List patients aged above 60.
select name as patient_name, age, gender from patients
where age>60
order by age asc;

-- 9. Show all appointments with status = 'No Show'.
select * from appointments
where appointment_status= 'No Show'
order by appointment_date , appointment_time asc;

-- 10. Display all appointments along with patient name and doctor name (using JOIN).
select
 appointments.Appointment_ID, appointments.Appointment_Date,appointments.Appointment_Status,patients.name as Patient_Name,doctors.name as Doctor_Name 
from appointments
join doctors
on doctors.Doctor_id= appointments.Doctor_id
join Patients
on Patients.Patient_id- appointments.patient_id ;

/* Intermediate Level (GROUP BY, Aggregates, Multiple JOINS) */

-- 11. Count total number of appointments each doctor has.

select doctors.name as doctor,  count(appointments.appointment_id) as total_appointment from appointments
join doctors
on appointments.doctor_id= doctors.doctor_id
group by doctor
order by total_appointment asc;

-- 12. Find the most common medicine prescribed.

select medicine, count(medicine) as frequency from prescriptions
group by medicine
order by frequency desc;

-- 13. Show number of appointments by status (Scheduled, Completed, etc.).
select Appointment_status, count(appointment_id) as total_appointment from appointments
group by appointment_status
order by total_appointment desc;


-- 14. List patients who had more than 3 appointments.

select patients.name as patient_name, count(appointment_id) as total from appointments
join patients
on patients.patient_id= appointments.patient_id
group by patient_name
having total>3
order by total desc;

-- 15. Get the total billing amount per patient.
select patients.patient_id, patients.name as patient ,round(sum(billing.amount),0)as total_billing from patients
join appointments
on patients.patient_id=  appointments.patient_id
join billing
on appointments.appointment_id= billing.appointment_id
group by patient, patient_id
order by total_billing desc limit 5;


-- 16. Find average appointment bill amount by doctor.
select doctors.name as doctor, round(avg(billing.amount),0) as avg_amount from billing
join appointments
on appointments.appointment_id= billing.appointment_id
join doctors
on appointments.doctor_id= doctors.doctor_id
group by doctor
order by avg_amount desc;

-- 17. Show doctors along with their total number of patients seen.

select doctors.name as doctor, count(distinct appointments.patient_id) as patient_seen from doctors
join appointments
on doctors.doctor_id= appointments.doctor_id
group by doctor
order by patient_seen desc;

-- 18. Get the top 5 highest bill amounts and their patients.

select patients.name as Patient,patients.patient_id as ID, round(sum(billing.amount)) as Billing_Amount from patients
join appointments on
appointments.patient_id=patients.patient_id
join billing
on billing.appointment_id= appointments.appointment_id
group by Patient, ID
order by Billing_Amount desc limit 5;

-- 19. Count how many times each medicine was prescribed.

select  distinct(medicine) as medicine, count(medicine) as frequency from prescriptions
group by medicine
order by frequency desc;

-- 20. List patients with no medical history (history = 'None').

select patient_id, name from patients
where medical_history='None';


/*  Advanced Level (Nested queries, CASE, Views, Subqueries, Ranking)  */


-- 21. Find the patient(s) who spent the most total money.

select patients.patient_ID as id , patients.name as patient , round(sum(billing.amount),0) as total_spent_money from patients
join appointments
on appointments.patient_id= patients.patient_id
join billing
on billing.appointment_id=appointments.appointment_id
group by patient, id
order by total_spent_money desc limit 3;

-- 22. List doctors who have treated more than 10 unique patients.

select doctors.doctor_id as id, doctors.name as doctor, count(distinct appointments.patient_id) as patient_id from doctors
join appointments
on appointments.doctor_id=doctors.doctor_id
group by doctor, id
having patient_id>10
order by patient_id desc;

-- 23. Create a view showing patient name, doctor name, appointment date, and bill amount.

create view patient_summary as 
select patients.name as patient, doctors.name as doctor, billing.amount as bill_amount, appointments.appointment_date from patients
join appointments
on appointments.patient_id=patients.patient_id
join billing
on billing.appointment_id= appointments.appointment_id
join doctors
on appointments.doctor_id=doctors.doctor_id;

select*from patient_summary;

-- 24. Find the most active doctor (most appointments overall).

select doctors.name as doctor, count(appointments.appointment_id) as appointment from doctors
join appointments
on appointments.doctor_id=doctors.doctor_id
group by doctor
order by appointment desc limit 1;

-- 25. Show monthly revenue generated by the hospital.

select date_format(payment_Date, '%y-%m') as month, round(sum(billing.amount)) as total_revenue from billing
group by month
order by total_revenue desc;


-- 26. Find patients who have only missed (No Show) appointments.

select patients.Patient_ID, patients.Name, appointments.Appointment_Status from patients
join appointments
on
appointments.Patient_ID=patients.Patient_ID
group by patients.Patient_ID,patients.Name,appointments.Appointment_Status
having COUNT(*) = SUM(appointments.Appointment_Status = 'No Show');

-- 27. Rank appointments by bill amount (highest to lowest).

select appointments.appointment_id, billing.amount, rank() over( order by billing.amount desc) as billing_rank from appointments
join billing
on appointments.appointment_id=billing.appointment_id;

-- 28. Show percentage of appointments by status (e.g., 60% Completed, 20% Cancelled).



-- 29. Find appointments with prescriptions but no billing record.




-- 30. For each doctor, list their last appointment date.
select doctors.doctor_id, doctors.name, max(appointments.appointment_date) as last_appointment from doctors
join appointments
on appointments.doctor_id= doctors.doctor_id
group by doctors.doctor_id, doctors.name
order by last_appointment desc;

