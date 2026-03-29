# import joblib
# from sklearn.naive_bayes import MultinomialNB

# # Define possible symptoms
# symptoms = ["fever", "cough", "headache", "fatigue", "chest pain"]

# # Dummy dataset (X = symptoms presence, y = diseases)
# X = [
#     [1, 1, 0, 0, 0],  # fever + cough → Flu
#     [0, 0, 1, 1, 0],  # headache + fatigue → Migraine
#     [0, 1, 0, 0, 1],  # cough + chest pain → Asthma
#     [1, 0, 0, 1, 1],  # fever + fatigue + chest pain → Heart Disease
# ]
# y = ["Flu", "Migraine", "Asthma", "Heart Disease"]

# # Train model
# model = MultinomialNB()
# model.fit(X, y)

# # Save model + symptoms
# joblib.dump(model, "disease_model.pkl")
# joblib.dump(symptoms, "symptoms.pkl")

# print("✅ Model trained and saved as disease_model.pkl + symptoms.pkl")

# train_dummy_model.py
import joblib
from sklearn.preprocessing import MultiLabelBinarizer
from sklearn.tree import DecisionTreeClassifier
from data import disease_symptoms, symptoms_list

# Prepare training data
X = []
y = []

for disease, symptoms in disease_symptoms.items():
    input_vec = [1 if s in symptoms else 0 for s in symptoms_list]
    X.append(input_vec)
    y.append(disease)

# Train model
model = DecisionTreeClassifier()
model.fit(X, y)

# Save model and features
joblib.dump(model, "disease_model.pkl")
joblib.dump(symptoms_list, "symptoms.pkl")

print("✅ Model and features saved!")
