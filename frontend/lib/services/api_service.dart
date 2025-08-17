import 'dart:convert';
//import 'dart:html' as html;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:flutter/foundation.dart' show kIsWeb;
import '../constants.dart';
import '../models/transaction_model.dart';

class ApiService {
  // Función para obtener el token JWT almacenado en SharedPreferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Función para manejar respuestas HTTP y verificar errores
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception("Sesión expirada. Por favor, inicia sesión nuevamente.");
    } else {
      throw Exception("Error en la solicitud: ${response.statusCode} - ${response.body}");
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Constants.loginEndpoint),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> registerUser(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.registerEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Accept": "*/*",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "balance": 1000.00
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      return _handleResponse(response);
    } catch (e) {
      print("Error during HTTP request: $e");
      rethrow;
    }
  }

  // Obtener el perfil de usuario autenticado
  Future<Map<String, dynamic>> fetchUserProfile() async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception("No se encontró un token válido.");
    }

    final response = await http.get(
      Uri.parse(Constants.userProfileEndpoint),
      headers: {"Authorization": "Bearer $token"},
    );

    Map<String, dynamic> userData = _handleResponse(response);

    if (userData.containsKey('id')) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', userData['id'].toString());
      print("User ID actualizado en SharedPreferences: ${userData['id']}");
    }

    return userData;
  }

  // Obtener las tarjetas del usuario
  Future<List<dynamic>> getUserCards() async {
    String? token = await _getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userIdString = prefs.getString('user_id');
    int? userId = userIdString != null ? int.tryParse(userIdString) : null;

    if (token == null || userId == null) {
      throw Exception("No se encontró un token o userId válido.");
    }

    final response = await http.get(
      Uri.parse("${Constants.getUserCardsEndpoint}/$userId"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("Respuesta del backend en getUserCards(): ${response.body}");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['cards'] ?? [];
    } else {
      print("Error al obtener tarjetas: ${response.statusCode} - ${response.body}");
      return [];
    }
  }
  // Future<List<dynamic>> getUserCards() async {
  //   String? token = await _getToken();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userIdString = prefs.getString('user_id');
  //   int? userId = userIdString != null ? int.tryParse(userIdString) : null;
  //
  //   if (token == null || userId == null) {
  //     throw Exception("No se encontró un token o userId válido.");
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse("${Constants.getUserCardsEndpoint}/$userId"),
  //     headers: {"Authorization": "Bearer $token"},
  //   );
  //
  //   print("Respuesta del backend en getUserCards(): ${response.body}"); //  Debug
  //
  //   if (response.statusCode == 200) {
  //     try {
  //       var jsonResponse = jsonDecode(response.body);
  //
  //       // ✅ Asegurar que jsonResponse es un Map con "cards"
  //       if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('cards')) {
  //         var cardsData = jsonResponse['cards'];
  //
  //         if (cardsData is List) { // Verificar que sea una lista
  //           return cardsData;
  //         } else {
  //           print("Formato incorrecto en 'cards': ${jsonResponse['cards']}");
  //           return [];
  //         }
  //       } else {
  //         print("Formato de respuesta inesperado: $jsonResponse");
  //         return [];
  //       }
  //     } catch (e) {
  //       print("Error al parsear JSON: $e");
  //       return [];
  //     }
  //   } else {
  //     print("Error al obtener tarjetas: ${response.statusCode} - ${response.body}");
  //     return [];
  //   }
  // }

  Future<bool> addCard(String cardNumber) async {
    String? token = await _getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');

    if (token == null || userId == null) {
      throw Exception("No se encontró un token o userId válido.");
    }

    // 🔥 Asegurar que cardNumber no sea vacío ni nulo
    if (cardNumber.isEmpty) {
      print("⚠ Error: cardNumber está vacío.");
      return false;
    }

    print("🔍 Enviando solicitud para agregar tarjeta...");
    print("📌 Token: $token");
    print("📌 UserID: $userId");
    print("📌 CardNumber: $cardNumber"); // 🔥 Verificar si es correcto

    final response = await http.post(
      Uri.parse("${Constants.addCardEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "userId": int.tryParse(userId) ?? 0,  // ✅ Convertir a número
        "cardNumber": cardNumber.trim(),  // ✅ Eliminar espacios innecesarios
        "isFrozen": false
      }),
    );

    print("📌 Respuesta del servidor: ${response.statusCode} - ${response.body}");

    return response.statusCode == 200;
  }



  // Congelar o descongelar una tarjeta
  Future<bool> freezeCard(String cardId) async {
    String? token = await _getToken();

    final response = await http.put(
      Uri.parse("${Constants.freezeCardEndpoint}/$cardId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }

  // Eliminar una tarjeta
  Future<bool> deleteCard(String cardId) async {
    String? token = await _getToken();

    final response = await http.delete(
      Uri.parse("${Constants.deleteCardEndpoint}/$cardId"),
      headers: {"Authorization": "Bearer $token"},
    );

    return response.statusCode == 200;
  }



  // Realizar pago
  Future<Map<String, dynamic>> makePayment({
    required String senderEmail,
    required String receiverEmail,
    required String senderCard,
    required String receiverCard,
    required double amount,
  }) async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception("No se encontró un token válido.");
    }

    final response = await http.post(
      Uri.parse(Constants.addTransactionEndpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "sender_email": senderEmail,
        "receiver_email": receiverEmail,
        "sender_card": senderCard,
        "receiver_card": receiverCard,
        "amount": amount,
        "transaction_type": "transfer"
      }),
    );

    return _handleResponse(response);
  }

  // Obtener historial de transacciones
  Future<List<TransactionModel>> getTransactionHistory() async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception("No se encontró un token válido.");
    }

    final response = await http.get(
      Uri.parse(Constants.transactionHistoryEndpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TransactionModel.fromJson(json)).toList();
    } else {
      throw Exception("Error al obtener historial: ${response.statusCode}");
    }
  }

  // // Historial de transacciones en PDF
  // Future<void> downloadTransactionPdf() async {
  //   String? token = await _getToken();
  //   if (token == null) {
  //     throw Exception("No se encontró un token válido.");
  //   }
  //
  //   final response = await http.get(
  //     Uri.parse(Constants.transactionPdfEndpoint),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer $token"
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     if (kIsWeb) {
  //       // For web, we'll trigger a download in the browser
  //       final blob = html.Blob([response.bodyBytes]);
  //       final url = html.Url.createObjectUrlFromBlob(blob);
  //       final anchor = html.AnchorElement(href: url)
  //         ..setAttribute("download", "historial_transacciones.pdf")
  //         ..click();
  //       html.Url.revokeObjectUrl(url);
  //     } else {
  //       // For mobile platforms, we'll save the file locally
  //       Directory tempDir;
  //       if (Platform.isAndroid) {
  //         tempDir = await getExternalStorageDirectory() ?? await getTemporaryDirectory();
  //       } else {
  //         tempDir = await getTemporaryDirectory();
  //       }
  //       String tempPath = tempDir.path;
  //       File file = File('$tempPath/historial_transacciones.pdf');
  //       await file.writeAsBytes(response.bodyBytes);
  //       // You might want to open the file here or notify the user of its location
  //     }
  //   } else {
  //     throw Exception("Error al descargar el PDF: ${response.statusCode}");
  //   }
  // }

  Future<void> downloadTransactionPdf() async {
    String? token = await _getToken();
    if (token == null) {
      throw Exception("No se encontró un token válido.");
    }

    final response = await http.get(
      Uri.parse(Constants.transactionPdfEndpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/transaction.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Open the file
      await OpenFile.open(filePath);
    } else {
      throw Exception('Failed to download PDF');
    }
  }


}