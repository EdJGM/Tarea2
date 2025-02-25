import 'package:flutter/material.dart';
import 'package:frontend/views/login_view.dart';
import 'package:frontend/views/home_view.dart';
import 'package:frontend/views/pagos_view.dart';
import 'package:frontend/views/transaccion_view.dart';
import 'package:frontend/views/cards_view.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String pagos = '/pagos';
  static const String transacciones = '/transacciones';
  static const String tarjetas = '/tarjetas';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => LoginScreen(),
      home: (context) => HomeScreen(),
      pagos: (context) => PaymentsScreen(),
      transacciones: (context) => TransactionsScreen(),
      tarjetas: (context) => CardsScreen(),
    };
  }
}