import express from "express";
import { firebaseAuthController} from "../controllers/firebaseAuth.js";

const router = express.Router();

router.post("/firebase", firebaseAuthController);



export default router;
