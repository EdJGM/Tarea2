from mongoengine import Document, StringField, FloatField, DateTimeField
import datetime
from zoneinfo import ZoneInfo

class Transaction(Document):
    sender_email = StringField(required=True)   # Usuario que envía
    receiver_email = StringField(required=True) # Usuario que recibe
    sender_card = StringField(required=True)    # Tarjeta que envía
    receiver_card = StringField(required=True)  # Tarjeta que recibe
    amount = FloatField(required=True)          # Monto
    transaction_type = StringField(default="transfer")
    created_at = DateTimeField(default=lambda: datetime.datetime.now(ZoneInfo('America/Guayaquil'))) # Fecha de transacción
