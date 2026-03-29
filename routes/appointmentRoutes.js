import express from "express";
import { createAppointment, getAppointmentsByPatient } from "../controllers/appointmentController.js";

const router = express.Router();

router.post("/", createAppointment); // book new appointment
router.get("/:patient_id", getAppointmentsByPatient); // fetch all for patient




export default router;
