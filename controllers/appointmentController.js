import pool from "../config/db.js";

// ✅ Create a new appointment
export const createAppointment = async (req, res) => {
  try {
    const {
      patient_id,
      doctor_email,
      patient_name,
      age,
      symptoms,
      location,
      appointment_date,
      appointment_time,
    } = req.body;

    if (
      !patient_id ||
      !doctor_email ||
      !patient_name ||
      !appointment_date ||
      !appointment_time
    ) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    const query = `
      INSERT INTO appointments 
      (patient_id, doctor_email, patient_name, age, symptoms, location, appointment_date, appointment_time)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *;
    `;

    const values = [
      patient_id,
      doctor_email,
      patient_name,
      age,
      symptoms,
      location,
      appointment_date,
      appointment_time,
    ];

    const result = await pool.query(query, values);

    res.status(201).json({
      message: "Appointment created successfully",
      appointment: result.rows[0],
    });
  } catch (err) {
    console.error("❌ Error creating appointment:", err);
    res.status(500).json({ message: "Server error while creating appointment" });
  }
};

// ✅ Get all appointments for a specific patient
export const getAppointmentsByPatient = async (req, res) => {
  try {
    const { patient_id } = req.params;

    if (!patient_id) {
      return res.status(400).json({ message: "Patient ID is required" });
    }

    const { rows } = await pool.query(
      `
      SELECT * FROM appointments 
      WHERE patient_id = $1 
      ORDER BY appointment_date DESC;
      `,
      [patient_id]
    );

    res.status(200).json(rows);
  } catch (err) {
    console.error("❌ Error fetching appointments:", err);
    res.status(500).json({ message: "Server error while fetching appointments" });
  }
};



// export const getDoctorAppointment = async (req,res) =>{

//   try{

//  const {email} = req.params;
  
  

//     if (!email) {
//       return res.status(400).json({ message: "Patient ID is required" });
//     }

//     const { rows } = await pool.query(
//       `
//       SELECT *
//       FROM appointments
//       WHERE doctor_email = $1
//       ORDER BY appointment_date DESC
//       `,
//       [email]
//     );

//     res.status(200).json(rows);


//   }catch(err){
//           console.error("❌ Error fetching appointments:", err);
//     res.status(500).json({ message: "Server error while fetching appointments" });
//   }


// }
