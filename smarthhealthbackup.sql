-- 1. Enable extension (REQUIRED for UUID)
CREATE EXTENSION IF NOT EXISTS pgcrypto;

--------------------------------------------------

-- 2. PATIENTS TABLE
CREATE TABLE patients (
    patient_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------

-- 3. DOCTORS TABLE
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    is_online BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--------------------------------------------------

-- 4. PATIENT PROFILES TABLE
CREATE TABLE patient_profiles (
    profile_id SERIAL PRIMARY KEY,
    patient_id UUID,
    first_name VARCHAR(100),
    gender VARCHAR(20),
    symptoms TEXT,
    dob DATE,
    height NUMERIC(5,2),
    weight NUMERIC(5,2),
    blood_group VARCHAR(10),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_patient
    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id)
    ON DELETE CASCADE
);

--------------------------------------------------

-- 5. APPOINTMENTS TABLE
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id UUID,
    doctor_email VARCHAR(100),
    patient_name VARCHAR(100),
    age INTEGER,
    symptoms TEXT,
    location VARCHAR(100),
    appointment_date DATE,
    appointment_time VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_patient_appointment
    FOREIGN KEY (patient_id)
    REFERENCES patients(patient_id),

    CONSTRAINT fk_doctor_email
    FOREIGN KEY (doctor_email)
    REFERENCES doctors(email)
);
