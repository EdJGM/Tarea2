from flask import Flask
from flask_cors import CORS
from mongoengine import connect

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True, allow_headers=["Content-Type", "Authorization"])

# 🔗 Conectar a MongoDB (ajusta con tu conexión real)
app.config["MONGODB_SETTINGS"] = {
    "db": "bankdb",
    "host": "mongodb://localhost:27017/bankdb"  # Cambia si usas otro host
}

# 🔥 Conexión a MongoDB
connect(
    db="bankdb",
    host="mongodb://localhost:27017/bankdb"
)
