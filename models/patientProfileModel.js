import pool from "../config/db.js";
import router from "../routes/patients.js";

// CREATE profile
export const createProfile = async (patient_id, profileData) => {
  const {
    full_name,
    gender,
    date_of_birth,
    height_cm,
    weight_kg,
    blood_group,
    address,
    existing_conditions,
  } = profileData;

  const query = `
    INSERT INTO patient_profiles (
      patient_id,
      full_name,
      gender,
      date_of_birth,
      height_cm,
      weight_kg,
      blood_group,
      address,
      existing_conditions,
      created_at,
      updated_at
    )
    VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,NOW(),NOW())
    RETURNING *;
  `;

  const values = [
    patient_id,
    full_name || null,
    gender || null,
    date_of_birth || null,
    height_cm ? Number(height_cm) : null,
    weight_kg ? Number(weight_kg) : null,
    blood_group || null,
    address || null,
    existing_conditions || null,
  ];

  const { rows } = await pool.query(query, values);
  return rows[0];
};

// UPDATE profile
// UPDATE profile
export const updateProfile = async (patient_id, profileData) => {
  const {
    first_name,
    gender,
    dob,
    height,
    weight,
    blood_group,
    address,
    symptoms,
  } = profileData;

  const query = `
    UPDATE patient_profiles
    SET
      first_name = $2,
      gender = $3,
      dob = $4,
      height = $5,
      weight = $6,
      blood_group = $7,
      address = $8,
      symptoms = $9,
      created_at = NOW()
    WHERE patient_id = $1
    RETURNING *;
  `;

  const values = [
    patient_id,
    first_name || null,
    gender || null,
    dob || null,
    height ? Number(height) : null,
    weight ? Number(weight) : null,
    blood_group || null,
    address || null,
    symptoms || null,
  ];

  const { rows } = await pool.query(query, values);
  return rows[0];
};



// GET profile by patient_id
export const getProfileByPatientId = async (patient_id) => {
  const query = `SELECT * FROM patient_profiles WHERE patient_id = $1 LIMIT 1;`;
  const { rows } = await pool.query(query, [patient_id]);
  return rows[0] || null;
};


