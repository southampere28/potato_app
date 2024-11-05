import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:potato_apps/configuration/app_constant.dart';
import 'package:potato_apps/model/device_model.dart';


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

  // Function to retrieve warehouse history for a specific device
  static Future<List<WarehouseHistory>> getWarehouseHistory(String deviceId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('device').doc(deviceId).collection('warehouse_history').get();
      return querySnapshot.docs.map((doc) => WarehouseHistory.fromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error retrieving warehouse history: $e');
      return [];
    }
  }

}