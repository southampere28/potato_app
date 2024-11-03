class AppConstant {
  // Firebase Realtime Database URL
  static const String databaseURL =
      "https://potato-base-34d80-default-rtdb.asia-southeast1.firebasedatabase.app";

  // Firebase Firestore Collection Names
  static const String userCollection = "users";
  static const String deviceCollection = "device";

  // Google Sign-In Scopes
  static const List<String> googleScopes = [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  // Application-specific constants
  static const String appName = "Potato Base";
  static const String defaultCity = "City Unknown";
  static const String imgPlaceholder = "";

  // Other constants for your app (e.g., shared preferences keys, error messages, etc.)
  static const String errorSignInMessage =
      "Error signing in. Please try again.";
}
