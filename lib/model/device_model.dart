import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel {
  final String id;
  final String deviceName;
  final String warehouse;
  final List<WarehouseHistory> warehouseHistory;
  final List<DetectHistory> detectHistory;

  DeviceModel({
    required this.id,
    required this.deviceName,
    required this.warehouse,
    required this.warehouseHistory,
    required this.detectHistory,
  });

  // Factory constructor to create a DeviceModel instance from Firestore data
  factory DeviceModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return DeviceModel(
      id: doc.id,
      deviceName: data['device_name'] ?? '',
      warehouse: data['warehouse'] ?? '',
      warehouseHistory: (data['warehouse_history'] as List<dynamic>? ?? [])
          .map((item) => WarehouseHistory.fromMap(item as Map<String, dynamic>))
          .toList(),
      detectHistory: (data['detect_history'] as List<dynamic>? ?? [])
          .map((item) => DetectHistory.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert a DeviceModel instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'device_name': deviceName,
      'warehouse': warehouse,
      'warehouse_history':
          warehouseHistory.map((item) => item.toMap()).toList(),
      'detect_history': detectHistory.map((item) => item.toMap()).toList(),
    };
  }
}

class WarehouseHistory {
  final Timestamp createdAt;
  final int humidity;
  final int temperature;
  final int lightIntensity;

  WarehouseHistory({
    required this.createdAt,
    required this.humidity,
    required this.temperature,
    required this.lightIntensity,
  });

  // Factory constructor to create WarehouseHistory from a map
  factory WarehouseHistory.fromMap(Map<String, dynamic> data) {
    return WarehouseHistory(
      createdAt: data['created_at'] ?? Timestamp.now(),
      humidity: (data['humidity'] ?? 0),
      temperature: (data['temperature'] ?? 0),
      lightIntensity: (data['light_intensity'] ?? 0),
    );
  }

  // Method to convert a WarehouseHistory instance to a map
  Map<String, dynamic> toMap() {
    return {
      'created_at': createdAt,
      'humidity': humidity,
      'temperature': temperature,
      'light_intensity': lightIntensity,
    };
  }
}

class DetectHistory {
  final Timestamp createdAt;
  final String imageDetect;
  final String resultDetect;

  DetectHistory({
    required this.createdAt,
    required this.imageDetect,
    required this.resultDetect,
  });

  // Factory constructor to create DetectHistory from a map
  factory DetectHistory.fromMap(Map<String, dynamic> data) {
    return DetectHistory(
      createdAt: data['created_at'] ?? Timestamp.now(),
      imageDetect: data['image_detect'] ?? '',
      resultDetect: data['result'] ?? 0,
    );
  }

  // Method to convert a DetectHistory instance to a map
  Map<String, dynamic> toMap() {
    return {
      'created_at': createdAt,
      'image_detect': imageDetect,
      'result': resultDetect,
    };
  }
}
