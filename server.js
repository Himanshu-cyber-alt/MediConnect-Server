













import express from "express";

import cors from "cors";
import http from "http";
import { Server } from "socket.io";


import  registerLogin from "./routes/patients.js";
import patientRoutes from "./routes/patientProfiles.js"

import doctorRoutes from "./routes/doctorRoutes.js";
import testRouter from "./routes/testRouter.js"
import appointment from "./routes/appointmentRoutes.js"
import authRoutes from "./routes/authRoutes.js";
import doctorAppointment from "./routes/doctorAppointmentRoutes.js"

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "https://mediconnect-xp3k.onrender.com" } });








const doctorSockets = {};

io.on("connection", (socket) => {
  console.log("🔌 User connected:", socket.id);

  // ============================
  // Doctor registers on login
  // ============================
  socket.on("registerDoctor", ({ email }) => {
    doctorSockets[email] = socket.id;
    console.log(`👨‍⚕️ Doctor registered: ${email} → ${socket.id}`);
  });

  // ============================
  // Patient requests a call
  // ============================
  socket.on("callRequest", ({ doctorEmail, patientEmail, appointmentId }) => {
    const doctorSocket = doctorSockets[doctorEmail];
    console.log("patient email ==> ",patientEmail)

    if (!doctorSocket) {
      socket.emit("doctorOffline");
      return;
    }

    // ✅ CREATE ROOM ID ON SERVER
    const roomId = `appointment-${appointmentId}`;

    console.log("room id ==>",appointmentId)

    // Send incoming call to doctor
    io.to(doctorSocket).emit("incomingCall", {
      patientEmail,
      patientSocket: socket.id,
      roomId,
    });

    console.log(
      `📞 Call request → Doctor: ${doctorEmail}, Room: ${roomId}`
    );
  });

  // ============================
  // Doctor accepts / declines
  // ============================
socket.on("callResponse", ({ accepted, patientSocket, roomId }) => {
  if (!patientSocket || !roomId) {
    console.error("❌ Missing patientSocket or roomId");
    return;
  }

  if (accepted) {
    // 🔥 SEND REDIRECT EVENT
    io.to(patientSocket).emit("redirectToCall", {
      url: `/call/${roomId}`,
    });

    console.log(`✅ Redirecting patient to /call/${roomId}`);
  } else {
    io.to(patientSocket).emit("callDeclined");
  }
});


  // ============================
  // End call (optional)
  // ============================
  socket.on("endCall", ({ patientSocket }) => {
    io.to(patientSocket).emit("callEnded");
  });

  // ============================
  // Cleanup on disconnect
  // ============================
  socket.on("disconnect", () => {
    console.log("❌ User disconnected:", socket.id);

    for (const email in doctorSockets) {
      if (doctorSockets[email] === socket.id) {
        delete doctorSockets[email];
        console.log(`🧹 Removed doctor: ${email}`);
      }
    }
  });
});

// ============================
// Express middleware & routes
// ============================
app.use(cors({ origin: "https://mediconnect-xp3k.onrender.com" }));
app.use(express.json());

app.use("/api/patients", registerLogin);
app.use("/api/patients", patientRoutes);
app.use("/api/patient/profile", testRouter);

app.use("/api/doctors", doctorRoutes);
app.use("/api/appointments", appointment);
app.use("/api/doctorappointments", doctorAppointment);
app.use("/api/auth", authRoutes);

// ============================
const PORT = 5000 || process.env.PORT;
server.listen(PORT, () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);
