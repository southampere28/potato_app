class AppConstant {
  // Firebase Realtime Database URL
  static const String databaseURL =
      "https://potato-base-34d80-default-rtdb.asia-southeast1.firebasedatabase.app";

  // Firebase Firestore Collection Names
  static const String userCollection = "users";
  static const String deviceCollection = "device";

  // Flask API URL
  static const String flaskURL = "http://172.16.104.219:5000";

  // ESPCam URL
  static const String espCamURL = 'http://172.16.104.219:5000/test_capture';

  // Google Sign-In Scopes
  static const List<String> googleScopes = [
    'email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  // Application-specific constants
  static const String appName = "Potato Base";
  static const String defaultCity = "City Unknown";
  static const String imgPlaceholder = "";
  static const String deviceID = "1730184375";

  // Other constants for your app (e.g., shared preferences keys, error messages, etc.)
  static const String errorSignInMessage =
      "Error signing in. Please try again.";
}
