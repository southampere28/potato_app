import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonController {
  static final googleSignIn = GoogleSignIn();

  static Future<void> sessionCheck() async {}

  static Future<void> googleAuthLogin(BuildContext context) async {
    try {
      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // If the user cancels the login, return early
      if (googleUser == null) {
        print("Google sign-in cancelled.");
        return;
      }

      // Obtain the authentication details from the Google account
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential using the Google authentication tokens
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Retrieve user info from UserCredential
      User? user = userCredential.user;

      // Get the current user's email
      String? email = user?.email;
      String? uid = user?.uid;

      print(uid);

      if (email == null) {
        print("Email not found.");
        return;
      }

      // Query Firestore to check if the email already exists
      QuerySnapshot<Map<String, dynamic>> userQuery = await FirebaseFirestore
          .instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // Check if the email is already registered in Firestore
      if (userQuery.docs.isNotEmpty) {
        // User with this email already exists
        print("User with email $email already exists in Firestore.");

        // Fetch the existing user data
        Map<String, dynamic> userData = userQuery.docs.first.data();
        print("User data from Firestore: $userData");

        // Access specific fields
        String fullName = userData['fullname'] ?? 'No Name';
        String city = userData['city'] ?? 'No City';
        String work = userData['work'] ?? 'No Work';
        print("Full Name: $fullName, City: $city, Work: $work");

        User? currentUser = FirebaseAuth.instance.currentUser;
        String? emailUser = currentUser?.email;
        print('anda terdaftar sebagai $emailUser');

        Fluttertoast.showToast(msg: 'Halo $fullName selamat datang kembali!');
      } else {
        // User does not exist, create a new user document
        print("No user found with email $email, creating a new user.");

        // Log the user information before creating the document
        String? fullName = user?.displayName;
        print("Creating new user with: Full Name: $fullName, Email: $email");

        // Call createUser to add the user data to Firestore
        await createUser(fullName ?? '', email, '', '');
        Fluttertoast.showToast(msg: 'akun baru berhasil dibuat!');
      }

      // Optionally sign out from Google after the operation
      await googleAuthLogout();

      Navigator.pushReplacementNamed(context, '/home');
    } catch (error) {
      print("Google sign-in failed: $error");
      Fluttertoast.showToast(msg: 'error 500, gagal login');
    }
  }

  static Future googleAuthLogout() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }

  static Future<void> createUser(
      String fullName, String email, String city, String work) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Add a new document with auto-generated ID
    await users.add({
      'fullname': fullName,
      'email': email,
      'city': city,
      'work': work,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((value) {
      print("User Added: $value");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }

  static Future<void> signOutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      print("User signed out successfully.");
      Fluttertoast.showToast(msg: 'Berhasil Logout!');
      Navigator.pushReplacementNamed(context, "/sign-in");
    } catch (e) {
      print("Error signing out: $e");
      Fluttertoast.showToast(msg: 'Error Logout!');
    }
  }
}
