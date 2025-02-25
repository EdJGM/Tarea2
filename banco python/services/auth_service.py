import jwt
import datetime
import base64
from flask import request, jsonify
from functools import wraps

# Clave secreta en Base64 tomada de Spring Boot
SECRET_KEY_STRING = "GCNf9qwnP4zo1ebxniw8T3RDHMB4r6NmfkfvBc8Q6ns="

# Decodificar la clave en bytes
SECRET_KEY = base64.b64decode(SECRET_KEY_STRING)

# Algoritmo usado en Spring Boot
ALGORITHM = "HS256"

def generate_token(email):
    """Genera un JWT con la clave secreta de Spring Boot"""
    payload = {
        "sub": email,
        "iat": datetime.datetime.utcnow(),
        "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)
    }
    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token

def verify_token(token):
    """Verifica y decodifica un JWT"""
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload  # Retorna los datos del usuario
    except jwt.ExpiredSignatureError:
        return jsonify({"msg": "Token expirado"}), 401
    except jwt.InvalidTokenError:
        return jsonify({"msg": "Token inválido"}), 401

def token_required(f):
    """Decorador para proteger rutas con JWT"""
    @wraps(f)
    def decorated(*args, **kwargs):
        token = None
        if "Authorization" in request.headers:
            auth_header = request.headers["Authorization"]
            if auth_header.startswith("Bearer "):
                token = auth_header.split(" ")[1]

        if not token:
            return jsonify({"msg": "Token es requerido"}), 401
        
        verification = verify_token(token)
        if isinstance(verification, tuple):
            return verification  # Devuelve error si el token no es válido
        
        return f(*args, **kwargs)

    return decorated
