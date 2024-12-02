import 'package:flutter/material.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/pages/home/main_page.dart';
import 'package:potato_apps/pages/setting_page.dart';
import 'package:potato_apps/pages/sign_in_page.dart';
import 'package:potato_apps/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potato_apps/firebase_options.dart';
import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  cleanTemporaryDirectory();
  _requestPermission();
  // await signInAnonymously();
  // await getDataFromFirestore();
}

Future<void> signInAnonymously() async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    log("Signed in with temporary account: ${userCredential.user!.uid}");
  } catch (e) {
    log("Failed to sign in anonymously: $e");
  }
}

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// Request Permission to show notifications (for iOS)
Future<void> _requestPermission() async {
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('Permission granted: ${settings.authorizationStatus}');

  // If permission is granted, get the device token
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    _getDeviceToken();
  } else {
    print("Permission not granted");
  }
}

// Get the Firebase device token
Future<void> _getDeviceToken() async {
  String? token = await _firebaseMessaging.getToken();
  if (token != null) {
    print("Device Token: $token"); // Print the device
    AppConstant.deviceToken = token;
  } else {
    print("Failed to get the device token.");
  }
}

Future<void> cleanTemporaryDirectory() async {
  try {
    final tempDir = await getTemporaryDirectory();
    final files = tempDir.listSync();
    for (var file in files) {
      if (file is File) {
        await file.delete();
      }
    }
    print("Temporary directory cleaned.");
  } catch (e) {
    print("Error cleaning temporary directory: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const SplashScreen(),
        '/sign-in': (context) => const SignInPage(),
        '/home': (context) => const MainPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
