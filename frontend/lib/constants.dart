class Constants {
  static const String baseUrlSpring = "http://10.40.15.131:8080"; // URL del backend en Spring Boot
  static const String baseUrlFlask = "http://10.40.15.131:5000"; // URL del backend en Flask

  static const String loginEndpoint = "$baseUrlSpring/users/login";
  static const String registerEndpoint = "$baseUrlSpring/users/register";
  static const String userProfileEndpoint = "$baseUrlSpring/users/me";
  static const String updateBalanceEndpoint = "$baseUrlSpring/users/update-balance";

  static const String addTransactionEndpoint = "$baseUrlFlask/transactions/add";
  static const String transactionHistoryEndpoint = "$baseUrlFlask/transactions/history";
  static const String transactionPdfEndpoint = "$baseUrlFlask/transactions/history/pdf";

  static const String addCardEndpoint = "$baseUrlSpring/cards/add";
  static const String getUserCardsEndpoint = "$baseUrlSpring/cards/user";
  static const String freezeCardEndpoint = "$baseUrlSpring/cards/freeze";
  static const String deleteCardEndpoint = "$baseUrlSpring/cards/delete";
}