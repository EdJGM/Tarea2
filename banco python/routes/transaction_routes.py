import requests
from flask import Blueprint, request, jsonify, send_file
from models.transaction_model import Transaction
from services.auth_service import token_required, verify_token
from utils.pdf_generator import generate_transaction_pdf
from flask_cors import cross_origin
from mongoengine.queryset.visitor import Q

transaction_bp = Blueprint("transaction_bp", __name__)

# URL del endpoint de actualización de balance en Spring Boot
SPRING_BOOT_URL = "http://localhost:8080/users/update-balance"
SPRING_BOOT_URL_ORIGIN = "http://localhost:8080"

# 📌 Endpoint para crear una transacción
@transaction_bp.route("/add", methods=["POST"])
@cross_origin()
@token_required
def add_transaction():
    data = request.json

    sender_email = data.get("sender_email")
    receiver_email = data.get("receiver_email")
    sender_card = data.get("sender_card")
    receiver_card = data.get("receiver_card")
    amount = data.get("amount")

    if not sender_email or not receiver_email or not sender_card or not receiver_card or not amount:
        return jsonify({"msg": "Faltan datos en la solicitud"}), 400

    auth_header = request.headers.get("Authorization")
    if not auth_header:
        return jsonify({"msg": "Token es requerido"}), 401

    headers = {
        "Content-Type": "application/json",
        "Authorization": auth_header
    }

    # Verificar balance del remitente
    sender_balance_response = requests.get(
        f"{SPRING_BOOT_URL_ORIGIN}/users/balance?email={sender_email}", 
        headers=headers
    )
    
    if not sender_balance_response.json().get("balance"):
        return jsonify({"msg": "El email del remitente no existe"}), 404
    
    # Verificar que existe el receptor
    receiver_balance_response = requests.get(
        f"{SPRING_BOOT_URL_ORIGIN}/users/balance?email={receiver_email}", 
        headers=headers
    )
    if not receiver_balance_response.json().get("balance"):
        return jsonify({"msg": "El email del receptor no existe"}), 404
    
    # Verificar tarjeta del remitente
    sender_card_response = requests.get(
        f"{SPRING_BOOT_URL_ORIGIN}/cards/exists?card={sender_card}", 
        headers=headers
    )
    if not sender_card_response.json().get("exists"):
        return jsonify({"msg": "La tarjeta del remitente no existe"}), 404
    
   # Verificar tarjeta del receptor
    receiver_card_response = requests.get(
        f"{SPRING_BOOT_URL_ORIGIN}/cards/exists?card={receiver_card}", 
        headers=headers
    )
    if not receiver_card_response.json().get("exists"):
        return jsonify({"msg": "La tarjeta del receptor no existe"}), 404
    
    # Verificar si hay suficiente balance
    sender_balance = sender_balance_response.json().get("balance", 0)
    if sender_balance < amount:
        return jsonify({"msg": "Saldo insuficiente"}), 400

    sender_payload = {"email": sender_email, "newBalance": -amount}
    receiver_payload = {"email": receiver_email, "newBalance": amount}

    sender_response = requests.post(SPRING_BOOT_URL, json=sender_payload, headers=headers)
    receiver_response = requests.post(SPRING_BOOT_URL, json=receiver_payload, headers=headers)

    if sender_response.status_code != 200 or receiver_response.status_code != 200:
        return jsonify({"msg": "Error al actualizar los balances en Spring Boot"}), 500

    new_transaction = Transaction(
        sender_email=sender_email,
        receiver_email=receiver_email,
        sender_card=sender_card,
        receiver_card=receiver_card,
        amount=amount,
        transaction_type="transfer"
    )
    new_transaction.save()

    return jsonify({
        "msg": "Transacción registrada con éxito",
        "sender_email": sender_email,
        "receiver_email": receiver_email,
        "amount": amount,
        "transaction_type": "transfer"
    }), 201


# 📌 Endpoint para ver el historial de transacciones de un usuario
@transaction_bp.route("/history", methods=["GET"])
@cross_origin()
@token_required
def transaction_history():
    auth_header = request.headers.get("Authorization")
    token = auth_header.split(" ")[1]
    user_data = verify_token(token)

    if isinstance(user_data, tuple):  # Si el token es inválido
        return user_data

    user_email = user_data.get("sub")  # Extraer email del usuario autenticado

    transactions = Transaction.objects(Q(sender_email=user_email) | Q(receiver_email=user_email))
    transaction_list = [{
        "sender_email": t.sender_email,
        "receiver_email": t.receiver_email,
        "amount": t.amount,
        "transaction_type": t.transaction_type,
        "date": t.created_at.strftime("%Y-%m-%d %H:%M:%S")
    } for t in transactions]

    return jsonify(transaction_list), 200

# 📌 Endpoint para generar el PDF del historial
@transaction_bp.route("/history/pdf", methods=["GET"])
@cross_origin()
@token_required
def transaction_pdf():
    auth_header = request.headers.get("Authorization")
    token = auth_header.split(" ")[1]
    user_data = verify_token(token)

    if isinstance(user_data, tuple):  # Si el token es inválido
        return user_data

    user_email = user_data.get("sub")  # Extraer email del usuario autenticado

    transactions = Transaction.objects(Q(sender_email=user_email) | Q(receiver_email=user_email))
    transaction_list = [{
        "sender_email": t.sender_email,
        "receiver_email": t.receiver_email,
        "amount": t.amount,
        "transaction_type": t.transaction_type,
        "date": t.created_at.strftime("%Y-%m-%d %H:%M:%S")
    } for t in transactions]

    pdf_path = generate_transaction_pdf(transaction_list, user_email)
    return send_file(pdf_path, as_attachment=True)
