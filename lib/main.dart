import 'package:flutter/material.dart';
import 'package:potato_apps/pages/home/main_page.dart';
import 'package:potato_apps/pages/sign_in_page.dart';
import 'package:potato_apps/pages/splash_screen.dart';

void main() {
  runApp(const MyApp());
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
      },
    );
  }
}
