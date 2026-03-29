



import express from "express";
import pool from "../config/db.js";
import {updateProfile,getProfile,createProfile,deleteProfile} from "../controllers/patientProfileController.js"

const router = express.Router();

// Update profile
 router.put("/:patient_id", updateProfile);

// Get profile
router.get("/:patient_id",getProfile);
router.delete("/:patient_id", deleteProfile);


export default router;

