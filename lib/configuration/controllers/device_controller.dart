import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:potato_apps/configuration/app_constant.dart';


class DeviceController {
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
}