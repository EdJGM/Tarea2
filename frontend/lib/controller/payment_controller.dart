import '../services/api_service.dart';

class PaymentController {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> makePayment({
    required String senderEmail,
    required String receiverEmail,
    required String senderCard,
    required String receiverCard,
    required double amount,
  }) async {
    return await apiService.makePayment(
      senderEmail: senderEmail,
      receiverEmail: receiverEmail,
      senderCard: senderCard,
      receiverCard: receiverCard,
      amount: amount,
    );
  }
}