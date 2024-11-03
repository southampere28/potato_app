import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String profilePhoto;
  final String city;
  final String work;
  final Timestamp createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePhoto,
    required this.city,
    required this.work,
    required this.createdAt,
  });

  // Factory constructor to create a UserModel instance from Firestore data
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      fullName: data['fullname'] ?? '',
      email: data['email'] ?? '',
      profilePhoto: data['profile_photo'] ?? '',
      city: data['city'] ?? '',
      work: data['work'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert a UserModel instance to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'fullname': fullName,
      'email': email,
      'profile_photo': profilePhoto,
      'city': city,
      'work': work,
      'createdAt': createdAt,
    };
  }
}
