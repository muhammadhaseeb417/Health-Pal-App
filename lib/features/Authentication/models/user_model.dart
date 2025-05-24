import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final bool hasSeenOnboarding;
  final UserDetails? userDetails;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoURL,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    required this.hasSeenOnboarding,
    this.userDetails,
  })  : this.createdAt = createdAt ?? DateTime.now(),
        this.lastLoginAt = lastLoginAt ?? DateTime.now();

  // Create a UserModel from Firebase User and additional data
  factory UserModel.fromUser(User user,
      {required String name,
      String? photoURL,
      bool hasSeenOnboarding = false,
      UserDetails? userDetails}) {
    return UserModel(
      uid: user.uid,
      name: name,
      email: user.email ?? '',
      photoURL: photoURL ?? user.photoURL,
      createdAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
      hasSeenOnboarding: hasSeenOnboarding,
      userDetails: userDetails,
    );
  }

  // Create a UserModel from Firestore document data
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoURL: map['photoURL'],
      createdAt: _parseDateTime(map['createdAt']),
      lastLoginAt: _parseDateTime(map['lastLoginAt']),
      hasSeenOnboarding: map['hasSeenOnboarding'] ?? false,
      userDetails: map['userDetails'] != null
          ? UserDetails.fromMap(map['userDetails'])
          : null,
    );
  }

  // Helper method to parse DateTime from various formats
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) {
      return DateTime.now();
    }

    if (dateValue is Timestamp) {
      return dateValue.toDate();
    }

    if (dateValue is DateTime) {
      return dateValue;
    }

    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        print('Error parsing date string: $dateValue, error: $e');
        return DateTime.now();
      }
    }

    print('Unknown date format: $dateValue (${dateValue.runtimeType})');
    return DateTime.now();
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'hasSeenOnboarding': hasSeenOnboarding,
      'userDetails': userDetails?.toMap(),
    };
  }

  // Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoURL,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    bool? hasSeenOnboarding,
    UserDetails? userDetails,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      userDetails: userDetails ?? this.userDetails,
    );
  }

  // Update last login time
  UserModel updateLoginTime() {
    return copyWith(lastLoginAt: DateTime.now());
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, hasSeenOnboarding: $hasSeenOnboarding, userDetails: $userDetails)';
  }
}
