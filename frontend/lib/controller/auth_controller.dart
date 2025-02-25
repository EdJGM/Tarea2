import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthController {
  final ApiService apiService = ApiService();

  Future<bool> login(String email, String password) async {
    try {
      var response = await apiService.login(email, password);
      if (response.containsKey('token') && response.containsKey('userId')) {
        String token = response['token'];
        String userId = response['userId'].toString();

        // Guardar el token en SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_id', userId);
        print("User ID guardado: ${response['userId']}");
        return true; // Login exitoso
      }
      return false; // Login fallido
    } catch (e) {
      print("Error al iniciar sesión: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await apiService.registerUser(name, email, password);
    return response;
  }
}