import express from 'express'
import pool from "../config/db.js";
const router = express.Router();


router.get("/:email",async (req,res)=>{

  try{

 const {email} = req.params;
  
  

    if (!email) {
      return res.status(400).json({ message: "Patient ID is required" });
    }

    const { rows } = await pool.query(
      `
      SELECT *
      FROM appointments
      WHERE doctor_email = $1
      ORDER BY appointment_date DESC
      `,
      [email]
    );

    res.status(200).json(rows);


  }catch(err){
          console.error("❌ Error fetching appointments:", err);
    res.status(500).json({ message: "Server error while fetching appointments" });
  }

})

export default router;