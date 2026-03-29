import admin from "firebase-admin";
import pool from "../config/db.js";
import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET;


const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT_KEY);
serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, '\n');


if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}


  export const firebaseAuthController = async (req, res) => {
    try {
      const  idToken  = req.body.token;
      console.log("token ==> ",idToken)
      if (!idToken) {
        return res.status(400).json({ message: "Token missing" });
      }

      // ✅ Verify Firebase Email/Password token
      const decoded = await admin.auth().verifyIdToken(idToken);

    

      const { email} = decoded;


      // 🔍 Check user in DB
      let result = await pool.query(
        "SELECT * FROM patients WHERE email = $1",
        [email]
      );

      
      let user;
      let flag = false;

      // 🆕 REGISTER (first time)
      if (result.rows.length === 0) {
        
        const insert = await pool.query(
          "INSERT INTO patients (email) VALUES ($1) RETURNING *",
          [email]
        );
          
        

      user = insert.rows[0];
        flag = true;
        console.log("flag => ",flag)

      

      } else {
        user = result.rows[0];
        flag = false;

      }

      // 🔐 Create YOUR app JWT
      let appToken = jwt.sign(
        { id: user.patient_id, email: user.email },
        JWT_SECRET,
        { expiresIn: "1d" }
      );

  console.log(appToken)
    

      res.json({
        user,
        token: appToken,
        flag
      });
    } catch (err) {
      console.error("🔥 FIREBASE VERIFY ERROR:");
    console.error(err.code);
    console.error(err.message);
      res.status(401).json({ message: "Firebase auth failed" });
    }
  };




