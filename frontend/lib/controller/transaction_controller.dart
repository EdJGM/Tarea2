import 'dart:io';

import '../services/api_service.dart';
import '../models/transaction_model.dart';

class TransactionController {
  final ApiService apiService = ApiService();

  Future<List<TransactionModel>> getTransactionHistory() async {
    return await apiService.getTransactionHistory();
  }

  List<TransactionModel> filterTransactionsByDate(List<TransactionModel> transactions, DateTime startDate, DateTime endDate) {
    return transactions.where((transaction) {
      DateTime transactionDate = DateTime.parse(transaction.createdAt);
      return transactionDate.isAfter(startDate.subtract(Duration(days: 1))) && transactionDate.isBefore(endDate.add(Duration(days: 1)));
    }).toList();
  }

  List<TransactionModel> filterTransactionsByType(List<TransactionModel> transactions, String type) {
    return transactions.where((transaction) => transaction.transactionType == type).toList();
  }

  Future<void> downloadTransactionPdf() async {
    await apiService.downloadTransactionPdf();
  }
}