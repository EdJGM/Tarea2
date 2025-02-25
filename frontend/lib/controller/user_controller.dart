import '../services/api_service.dart';

class UserController {
  final ApiService apiService = ApiService();

  Future<Map<String, dynamic>> getUserProfile() async {
    return await apiService.fetchUserProfile();
  }
}
