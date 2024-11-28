import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:potato_apps/model/user_model.dart';
import 'package:path_provider/path_provider.dart';

class PersonController {
  static final googleSignIn = GoogleSignIn();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseStorage _storage = FirebaseStorage.instance;

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
          "profile_photo": currentUser?.photoURL ?? "",
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
  static Future<UserModel?> getUserData() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) {
      print("No user is currently logged in.");
      return null;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      // Query the Firestore collection for a document with the specified uid
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      // Check if document exists
      if (userDoc.exists) {
        // Return the user data as a Map
        return UserModel.fromFirestore(userDoc);
      } else {
        print("User with UID $uid does not exist.");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  // get profile user with stream
  static Stream<UserModel?> getUserDataStream() {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) {
      print("No user is currently logged in.");
      return Stream.value(null);
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Listen to changes in the document and map them to UserModel
    return _firestore.collection('users').doc(uid).snapshots().map((userDoc) {
      if (userDoc.exists) {
        // Convert document data to UserModel
        return UserModel.fromFirestore(userDoc);
      } else {
        print("User with UID $uid does not exist.");
        return null;
      }
    });
  }

  static Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    if (uid == null) {
      print("No user is currently logged in.");
      return null;
    }

    try {
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Update the document with the new data
      await userDoc.update(updatedData);
      print('User data updated successfully.');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  static Future<Uint8List> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 60,
    );
    print(file.lengthSync());
    print(result!.length);

    return result;
  }

  static Future<String?> uploadImage(File imageFile, String userId) async {
    try {
      Uint8List compressed = await testCompressFile(imageFile);

      File compressedFinish =
          await uint8ListToFile(compressed, 'compressedimagefile.jpg');

      // Define the storage path and file name in Firebase
      String filePath = 'photo/profileimg/$userId.jpg';

      // Upload the compressed file to Firebase Storage
      final uploadTask = await _storage.ref(filePath).putFile(
            compressedFinish,
            SettableMetadata(contentType: "image/jpeg"),
          );

      // Get the download URL of the uploaded image
      String downloadURL = await uploadTask.ref.getDownloadURL();

      print("Image uploaded successfully. URL: $downloadURL");

      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  static Future<File> uint8ListToFile(Uint8List data, String fileName) async {
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();

    // Create a full file path in the temporary directory
    String filePath = '${tempDir.path}/$fileName';

    // Write the data to the file
    File file = File(filePath);
    return await file.writeAsBytes(data);
  }

  static Future<bool> updateProfilePhoto(File? imgFile) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final uid = currentUser?.uid;

    try {
      // Check if an image file is provided
      if (imgFile == null) {
        print("No image selected.");
        return false;
      }

      // Upload the image and get the download URL
      String? imageUrl = await uploadImage(imgFile, uid!);
      if (imageUrl == null) {
        print("Failed to get image URL.");
        return false;
      }

      // Save detection history with the image URL
      bool success = await updateLinkImage(uid, imageUrl);
      if (success) {
        print("Profile saved with image URL.");
      }
      return success; // Return the success status of addNewDetectionHistory
    } catch (e) {
      print("Error in saving detection with image: $e");
      return false; // Return false in case of an exception
    }
  }

  static Future<bool> updateLinkImage(String userId, String linkImage) async {
    try {
      // Reference to the user's document
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      // Update the document with the new field
      await userDoc.update({'profile_photo': linkImage});
      print('User data updated successfully.');
      return true; // Indicating success
    } catch (e) {
      print('Error updating user data: $e');
      return false; // Indicating failure
    }
  }
}
