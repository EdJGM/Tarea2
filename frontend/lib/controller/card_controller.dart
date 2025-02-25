import '../services/api_service.dart';

class CardController {
  final ApiService apiService = ApiService();

  Future<List<dynamic>> getUserCards() async {
    final response = await apiService.getUserCards();
    return response;
  }

  Future<bool> addCard(String cardNumber) async {
    return await apiService.addCard(cardNumber);
  }

  Future<bool> deleteCard(String cardId) async {
    return await apiService.deleteCard(cardId);
  }

  Future<bool> freezeCard(String cardId) async {
    return await apiService.freezeCard(cardId);
  }
}