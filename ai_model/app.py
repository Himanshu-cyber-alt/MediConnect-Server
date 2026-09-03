
from fastapi import FastAPI
from pydantic import BaseModel
import joblib
from fastapi.middleware.cors import CORSMiddleware
from data import doctor_map

# Load trained model and features
model = joblib.load("disease_model.pkl")
symptoms_list = joblib.load("symptoms.pkl")

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://mediconnect-himanshu.s3-website.ap-south-1.amazonaws.com",
        "https://mediconnect-himanshu.s3-website.ap-south-1.amazonaws.com",
        "*"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Symptoms(BaseModel):
    symptoms: list[str]

@app.get("/")
def home():
    return {"message": "AI Server Running"}

@app.post("/predict")
def predict(data: Symptoms):
    input_vec = [1 if s in data.symptoms else 0 for s in symptoms_list]

    disease = model.predict([input_vec])[0]
    recommended_doctor = doctor_map.get(disease, "General Physician")

    return {
        "predicted_disease": disease,
        "recommended_doctor": recommended_doctor
    }