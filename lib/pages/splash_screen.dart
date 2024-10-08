import 'dart:async';

import 'package:flutter/material.dart';
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
    Timer(Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
    super.initState();
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
