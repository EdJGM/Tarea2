class User {
  final String id;
  final String name;
  final String email;
  final double balance;

  User({required this.id, required this.name, required this.email, required this.balance});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      balance: json['balance'].toDouble(),
    );
  }
}