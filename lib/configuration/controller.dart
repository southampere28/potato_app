import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class PersonController {
  static final googleSignIn = GoogleSignIn();

  static String nameCurrentUser = "";

  static String emailCurrentUser = "";

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
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? currentUser = FirebaseAuth.instance.currentUser;

      bool check = await checkIfDocExists(currentUser);

      if (check) {
        Fluttertoast.showToast(msg: 'user already exist');
      } else {
        String uid = currentUser?.uid ?? '';
        Map<String, dynamic> data = {
          "fullname": currentUser?.displayName ?? currentUser?.email,
          "email": currentUser?.email ?? '',
          "city": "",
          "work": "",
          "createdAt": Timestamp.now(),
        };
        createOrUpdateDocument(uid, data);
        Fluttertoast.showToast(msg: 'register successfull');
      }

      googleAuthLogout();

      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<bool> checkIfDocExists(User? currentUser) async {
    String uid = currentUser?.uid ?? '';

    try {
      // Referensi ke koleksi, misalnya 'users'
      DocumentReference document =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Mengambil data dokumen berdasarkan ID
      DocumentSnapshot docSnapshot = await document.get();

      // Mengecek apakah dokumen ada
      if (docSnapshot.exists) {
        print('Document with ID $uid exists.');
        return true;
      } else {
        print('Document with ID does not exist, create new user');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static void createOrUpdateDocument(
      String customId, Map<String, dynamic> data) async {
    try {
      // Referensi ke koleksi, misalnya 'users'
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Menyimpan data dengan custom ID
      await users.doc(customId).set(data);

      print('Document created or updated with custom ID: $customId');
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future googleAuthLogout() async {
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
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

  // get profile user
  static Future<Map<String, dynamic>?> getUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the Firestore collection for a document with the specified uid
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      // Check if document exists
      if (userDoc.exists) {
        // Return the user data as a Map
        return userDoc.data() as Map<String, dynamic>?;
      } else {
        print("User with UID $uid does not exist.");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}

class DeviceController {
  static final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        "https://potato-base-34d80-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref();

  // Function to get device data by device ID
  static Future<Map<String, dynamic>?> getDeviceData(String deviceId) async {
    try {
      // Retrieve data from the specific device node
      DatabaseEvent event = await _database.child('device/$deviceId').once();

      // Check if the data exists
      if (event.snapshot.value != null) {
        // Return the data as a Map
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      } else {
        print("No data found for device ID: $deviceId");
        return null;
      }
    } catch (e) {
      print("Error getting device data: $e");
      return null;
    }
  }
}
