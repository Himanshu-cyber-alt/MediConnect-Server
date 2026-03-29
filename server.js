













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
const io = new Server(server, { cors: { origin: "https://mediconnect-gc7w.onrender.com" } });




// const doctorSockets = {};

// console.log(doctorSockets)

// io.on("connection", (socket) => {
//   console.log("User connected:", socket.id);

//   socket.on("registerDoctor", ({ email }) => {
//     doctorSockets[email] = socket.id;
//     console.log(`Doctor registered: ${email} → ${socket.id}`);
//   });





//   socket.on("callRequest", ({ doctorEmail, patientEmail }) => {
//   const doctorSocket = doctorSockets[doctorEmail];
//   if (doctorSocket) {
//     io.to(doctorSocket).emit("incomingCall", {
//       patientEmail,
//       patientSocket: socket.id
//     });
//   }
// });







//   socket.on("callResponse", ({ patientSocket, accepted }) => {
//     io.to(patientSocket).emit("callResponse", { accepted, doctorSocket: socket.id });
//   });

//   socket.on("webrtc-offer", ({ targetSocket, offer }) => {
//     io.to(targetSocket).emit("webrtc-offer", { offer, fromSocket: socket.id });
//   });

//   socket.on("webrtc-answer", ({ targetSocket, answer }) => {
//     io.to(targetSocket).emit("webrtc-answer", { answer });
//   });

//   socket.on("webrtc-ice-candidate", ({ targetSocket, candidate }) => {
//     io.to(targetSocket).emit("webrtc-ice-candidate", { candidate });
//   });

//   socket.on("callEnded", ({ targetSocket }) => {
//     io.to(targetSocket).emit("callEnded");
//   });

//   socket.on("disconnect", () => {
//     console.log("User disconnected:", socket.id);
//     for (const email in doctorSockets) {
//       if (doctorSockets[email] === socket.id) delete doctorSockets[email];
//     }
//   });
// });

// app.use(cors({ origin: "https://mediconnect-gc7w.onrender.com" }));
// app.use(express.json());


// app.use("/api/patients", registerLogin);
// app.use("/api/patients", patientRoutes);
// app.use("/api/patient/profile",testRouter);




// app.use("/api/doctors", doctorRoutes);
// app.use("/api/appointments",appointment)

// app.use("/api/doctorappointments",doctorAppointment)

// app.use("/api/auth", authRoutes);



// app.use((req, res, next) => {
//   res.header("Access-Control-Allow-Origin", "https://mediconnect-gc7w.onrender.com");
//   res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
//   res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
//   if (req.method === "OPTIONS") return res.sendStatus(200);
//   next();
// });

// const PORT = 5000;
// server.listen(PORT, () => console.log(`🚀 Server running on http://localhost:${PORT}`));




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
app.use(cors({ origin: "https://mediconnect-gc7w.onrender.com" }));
app.use(express.json());

app.use("/api/patients", registerLogin);
app.use("/api/patients", patientRoutes);
app.use("/api/patient/profile", testRouter);

app.use("/api/doctors", doctorRoutes);
app.use("/api/appointments", appointment);
app.use("/api/doctorappointments", doctorAppointment);
app.use("/api/auth", authRoutes);

// ============================
const PORT = 5000;
server.listen(PORT, () =>
  console.log(`🚀 Server running on http://localhost:${PORT}`)
);
