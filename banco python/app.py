from config import app
from routes.transaction_routes import transaction_bp

# Registrar los blueprints
app.register_blueprint(transaction_bp, url_prefix="/transactions")

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True, port=5000)
