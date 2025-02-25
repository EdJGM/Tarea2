class PaymentModel {
  final String id;
  final String userId;
  final double amount;
  final String cardNumber;
  final String createdAt;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.cardNumber,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'].toDouble(),
      cardNumber: json['cardNumber'],
      createdAt: json['created_at'],
    );
  }
}