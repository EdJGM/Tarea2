from config import app
from routes.transaction_routes import transaction_bp

# Registrar los blueprints
app.register_blueprint(transaction_bp, url_prefix="/transactions")

if __name__ == "__main__":
    app.run(debug=True, port=5000)
