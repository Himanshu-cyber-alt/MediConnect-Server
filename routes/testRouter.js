

import express from "express";
import pool from "../config/db.js";


const router = express.Router();

router.post("/", async (req, res) => {
  const {
    patient_id,
    firstName,
    gender,
    symptoms,
    dob,
    height,
    weight,
    bloodGroup,
    address,
  } = req.body;

  try {
    const result = await pool.query(
      `INSERT INTO patient_profiles 
       (patient_id, first_name, gender, symptoms, dob, height, weight, blood_group, address)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING *`,
      [patient_id, firstName, gender, symptoms, dob, height, weight, bloodGroup, address]
    );
    res.json({ success: true, patient_id, profile: result.rows[0] });
  } catch (err) {
    console.error(err);
    res.status(500).json({ success: false, message: "Database insert failed" });
  }
});

export default router;