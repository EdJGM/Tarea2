class CardModel {
  final String id;
  final String userId;
  final String cardNumber;
  final bool isFrozen;

  CardModel({required this.id, required this.userId, required this.cardNumber, required this.isFrozen});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      userId: json['userId'],
      cardNumber: json['cardNumber'],
      isFrozen: json['isFrozen'],
    );
  }
}