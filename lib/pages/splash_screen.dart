import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:potato_apps/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkUserSession();
  }

  // Function to check the user session
  void _checkUserSession() async {
    // Wait for 2 seconds (optional splash screen delay)
    await Future.delayed(Duration(seconds: 3));

    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // If the user is logged in, navigate to mainpage
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // If not logged in, navigate to sign-in page
      Navigator.pushReplacementNamed(context, '/sign-in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background_splash.png'),
                  fit: BoxFit.cover)),
          child: Center(
              child: Container(
            height: 236,
            decoration: const BoxDecoration(
                image:
                    DecorationImage(image: AssetImage('assets/app_logo.png'))),
          ))),
    );
  }
}
