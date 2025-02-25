class TransactionModel {
  final double amount;
  final String senderEmail;
  final String receiverEmail;
  final String transactionType;
  final String createdAt;

  TransactionModel({
    required this.amount,
    required this.senderEmail,
    required this.receiverEmail,
    required this.transactionType,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      amount: json['amount'].toDouble(),
      senderEmail: json['sender_email'],
      receiverEmail: json['receiver_email'],
      transactionType: json['transaction_type'],
      createdAt: json['date'],
    );
  }
}