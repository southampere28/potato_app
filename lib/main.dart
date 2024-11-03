import 'package:flutter/material.dart';
import 'package:potato_apps/pages/home/main_page.dart';
import 'package:potato_apps/pages/sign_in_page.dart';
import 'package:potato_apps/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potato_apps/firebase_options.dart';
import 'dart:developer';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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

Future<void> getDataFromFirestore() async {
  try {
    // Access Firestore collection 'yourCollection'
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('cafe');
    QuerySnapshot snapshot = await collectionRef.get();

    // Log each document's data
    for (var doc in snapshot.docs) {
      print(doc.id);
      print(doc.data()); // Logs to terminal
    }
  } catch (e) {
    log('Error fetching data: $e');
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
      },
    );
  }
}
