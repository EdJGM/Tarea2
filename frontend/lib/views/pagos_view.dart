import 'dart:math';

import 'package:flutter/material.dart';
import '../controller/payment_controller.dart';
import '../routes.dart';

class PaymentsScreen extends StatefulWidget {
  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final PaymentController _paymentController = PaymentController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _senderEmailController = TextEditingController();
  final TextEditingController _receiverEmailController = TextEditingController();
  final TextEditingController _senderCardController = TextEditingController();
  final TextEditingController _receiverCardController = TextEditingController();
  int _currentIndex = 2;

  Future<void> _confirmPayment() async {
    double? amount = double.tryParse(_amountController.text);
    String senderEmail = _senderEmailController.text.trim();
    String receiverEmail = _receiverEmailController.text.trim();
    String senderCard = _senderCardController.text.trim();
    String receiverCard = _receiverCardController.text.trim();

    if (amount == null || amount <= 0) {
      _showErrorDialog("Monto inválido. Debe ser mayor a 0.");
      return;
    }

    if (senderEmail.isEmpty || receiverEmail.isEmpty || senderCard.isEmpty || receiverCard.isEmpty) {
      _showErrorDialog("Todos los campos son obligatorios.");
      return;
    }

    bool confirm = await _showConfirmationDialog(amount, senderCard, receiverCard);
    if (confirm) {
      _makePayment(senderEmail, receiverEmail, senderCard, receiverCard, amount);
    }
  }

  Future<void> _makePayment(String senderEmail, String receiverEmail, String senderCard, String receiverCard, double amount) async {
    try {
      var response = await _paymentController.makePayment(
        senderEmail: senderEmail,
        receiverEmail: receiverEmail,
        senderCard: senderCard,
        receiverCard: receiverCard,
        amount: amount,
      );

      if (response.containsKey("msg") && response["msg"] == "Transacción registrada con éxito") {  // ✅ Verifica mensaje de éxito
        _showSuccessDialog("Pago realizado con éxito.");
      } else {
        _showErrorDialog("Hubo un problema con el pago.");
      }
    } catch (e) {
      String errorMessage = e.toString();
      RegExp regex = RegExp(r'"msg":\s*"([^"]+)"');
      Match? match = regex.firstMatch(errorMessage);
      String customMessage = match != null ? match.group(1) ?? "Error desconocido" : "Error desconocido";
      _showErrorDialog("Error al realizar pago: $customMessage");
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? placeholder,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: placeholder,
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(fontSize: 16),
      ),
    );
  }


  Future<bool> _showConfirmationDialog(double amount, String senderCard, String receiverCard) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.payment, color: Colors.blue[600], size: 28),
            SizedBox(width: 12),
            Text(
              "Confirmar Pago",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detalles del pago:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Monto:", style: TextStyle(color: Colors.grey[600])),
                      Text(
                        "\$${amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24),
                  Text("De: **** ${senderCard.substring(max(0, senderCard.length - 4))}",
                      style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 8),
                  Text("Para: **** ${receiverCard.substring(max(0, receiverCard.length - 4))}",
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancelar",
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              "Confirmar",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
            SizedBox(width: 12),
            Text(
              "¡Pago Exitoso!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 28),
            SizedBox(width: 12),
            Text(
              "Error",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc4dafa),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Realizar Pago',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Información del Pago",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildInputField(
                      controller: _amountController,
                      label: 'Monto',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      placeholder: '0.00',
                    ),
                    _buildInputField(
                      controller: _senderEmailController,
                      label: 'Correo del Remitente',
                      icon: Icons.mail_outline,
                      placeholder: 'tu@email.com',
                    ),
                    _buildInputField(
                      controller: _receiverEmailController,
                      label: 'Correo del Receptor',
                      icon: Icons.person_outline,
                      placeholder: 'receptor@email.com',
                    ),
                    _buildInputField(
                      controller: _senderCardController,
                      label: 'Tarjeta del Remitente',
                      icon: Icons.credit_card,
                      placeholder: '**** **** **** ****',
                    ),
                    _buildInputField(
                      controller: _receiverCardController,
                      label: 'Tarjeta del Receptor',
                      icon: Icons.credit_card_outlined,
                      placeholder: '**** **** **** ****',
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _confirmPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Realizar Pago',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.home);
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.transacciones);
              break;
            case 2:
            // Already on the "Pagos" screen
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.tarjetas);
              break;
            case 4:
              Navigator.pushReplacementNamed(context, AppRoutes.login);
              break;
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Pagos'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Tarjetas'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Salir'),
        ],
      ),
    );
  }
}