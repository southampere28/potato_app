import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/model/device_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DeviceController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: AppConstant.databaseURL,
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

  // Function to get device data by device ID as a stream
  static Stream<Map<String, dynamic>?> streamDeviceData(String deviceId) {
    return _database.child('device/$deviceId').onValue.map((event) {
      if (event.snapshot.value != null) {
        return Map<String, dynamic>.from(event.snapshot.value as Map);
      } else {
        print("No data found for device ID: $deviceId");
        return null;
      }
    }).handleError((error) {
      print("Error getting device data: $error");
      return null;
    });
  }

  // Function to set device blower mode to auto or manual in the realtime database
  static Future<void> setBlowerMode(String deviceId, bool isOn) async {
    try {
      // Set mode in the device node
      await _database
          .child('device/$deviceId/blower_status')
          .set(isOn ? 'ON' : 'OFF');
      print(
          "Device mode set to ${isOn ? 'ON' : 'OFF'} for device ID: $deviceId");
    } catch (e) {
      print("Error setting device mode: $e");
    }
  }

  // Function to return boolean blowermode
  static Future<bool?> getBlowerMode(String deviceId) async {
    try {
      // Get the current mode value from the device node
      DatabaseEvent event =
          await _database.child('device/$deviceId/blower_status').once();
      String? status = event.snapshot.value as String?;

      // Check the mode value and return true for 'auto', false for 'manual'
      if (status == 'ON') {
        return true;
      } else if (status == 'OFF') {
        return false;
      } else {
        print("Invalid mode value for device ID: $deviceId");
        return null; // Return null if mode value is invalid
      }
    } catch (e) {
      print("Error getting device mode: $e");
      return null;
    }
  }

  // Function to set device mode to auto or manual in the realtime database
  static Future<void> setDeviceMode(String deviceId, bool isAuto) async {
    try {
      // Set mode in the device node
      await _database
          .child('device/$deviceId/mode')
          .set(isAuto ? 'auto' : 'manual');
      print(
          "Device mode set to ${isAuto ? 'auto' : 'manual'} for device ID: $deviceId");
    } catch (e) {
      print("Error setting device mode: $e");
    }
  }

  // Function to return boolean mode
  static Future<bool?> getDeviceMode(String deviceId) async {
    try {
      // Get the current mode value from the device node
      DatabaseEvent event =
          await _database.child('device/$deviceId/mode').once();
      String? mode = event.snapshot.value as String?;

      // Check the mode value and return true for 'auto', false for 'manual'
      if (mode == 'auto') {
        return true;
      } else if (mode == 'manual') {
        return false;
      } else {
        print("Invalid mode value for device ID: $deviceId");
        return null; // Return null if mode value is invalid
      }
    } catch (e) {
      print("Error getting device mode: $e");
      return null;
    }
  }

  static Future<bool> addNewWarehouseHistory(String deviceId, int humidity,
      int lightIntensity, int temperature) async {
    try {
      // Create a new document with the given parameters and current timestamp
      await _firestore
          .collection('device')
          .doc(deviceId)
          .collection('warehouse_history')
          .add({
        'created_at': FieldValue.serverTimestamp(),
        'humidity': humidity,
        'light_intensity': lightIntensity,
        'temperature': temperature,
      });
      print("Warehouse history added successfully.");
      return true;
    } catch (e) {
      print("Error adding new warehouse history: $e");
      return false;
    }
  }

  // Function to retrieve warehouse history for a specific device
  static Future<List<WarehouseHistory>> getWarehouseHistory(
      String deviceId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('device')
          .doc(deviceId)
          .collection('warehouse_history')
          .orderBy('created_at', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) =>
              WarehouseHistory.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error retrieving warehouse history: $e');
      return [];
    }
  }

  // Function to send image data to the Flask API and receive JSON response
  static Future<Map<String, dynamic>?> sendImageForAnalysis(
      File imageFile) async {
    try {
      // API endpoint URL
      final url = Uri.parse("${AppConstant.flaskURL}/predict");

      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add the image file to the request
      request.files
          .add(await http.MultipartFile.fromPath('image_file', imageFile.path));

      // Send the request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        return jsonDecode(responseData.body) as Map<String, dynamic>;
      } else {
        print("Failed to analyze image. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error sending image for analysis: $e");
      return null;
    }
  }

  // Function to capture image from ESP32-CAM
  static Future<File?> captureImage() async {
    try {
      final response = await http
          .get(Uri.parse(AppConstant.espCamURL))
          .timeout(const Duration(seconds: 10)); // Adjust the timeout here

      if (response.statusCode == 200) {
        print("Gambar berhasil diambil dari ESP32-CAM.");

        // Get the temporary directory
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/captured_image.jpg';

        // Save the image to a file
        final imageFile = File(filePath);
        await imageFile.writeAsBytes(response.bodyBytes);

        return imageFile;
      } else {
        print(
            "Gagal menangkap gambar dari ESP32-CAM. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error capturing image from ESP32-CAM: $e");
      return null;
    }
  }
}
