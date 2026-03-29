


import express from "express";
import pool from "../config/db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";


const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET;

/* =========================
   REGISTER PATIENT
========================= */
router.post("/register", async (req, res) => {
  const { email, password } = req.body;

   console.log("Email => ",email,"  Password => ",password);
  if (!email || !password) {
    return res.status(400).json({ message: "Email and password required" });
  }

  try {
    const exists = await pool.query(
      "SELECT 1 FROM patients WHERE email = $1",
      [email]
    );

    if (exists.rows.length > 0) {
      return res.status(409).json({ message: "Email already registered" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const result = await pool.query(
      `INSERT INTO patients (email, password)
       VALUES ($1, $2)
       RETURNING patient_id, email`,
      [email, hashedPassword || null]
    );

     console.log(result);
     
    const patient = result.rows[0];

   await pool.query(`INSERT INTO patient_profiles (patient_id)
                        VALUES ($1)`,[patient.patient_id])


    const token = jwt.sign(
      { id: patient.patient_id, role: "patient" },
      JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.status(201).json({
      message: "Patient registered",
      token,
      patient
    });
  } catch (err) {
    console.error("Patient register error:", err);
    res.status(500).json({ message: "Server error" });
  }
});

/* =========================
   LOGIN PATIENT
========================= */
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  console.log(req.body)

  if (!email || !password)
    return res.status(400).json({ message: "Email and password required" });

  try {
    const result = await pool.query(
      "SELECT * FROM patients WHERE email = $1",
      [email]
    );

    if (result.rows.length === 0) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const patient = result.rows[0];

    const isMatch = await bcrypt.compare(password, patient.password);
    if (!isMatch) {
      return res.status(400).json({ message: "Invalid credentials" });
    }

    const token = jwt.sign(
      { id: patient.patient_id, role: "patient" },
      JWT_SECRET,
      { expiresIn: "1d" }
    );

    res.json({
      message: "Login successful",
      token,
      patient: {
        patient_id: patient.patient_id,
        email: patient.email
      }
    });
  } catch (err) {
    console.error("Patient login error:", err);
    res.status(500).json({ message: "Server error" });
  }
});





export default router;
