import 'package:firebase_auth/firebase_auth.dart';
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
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] is DateTime
              ? map['createdAt']
              : DateTime.parse(map['createdAt']))
          : DateTime.now(),
      lastLoginAt: map['lastLoginAt'] != null
          ? (map['lastLoginAt'] is DateTime
              ? map['lastLoginAt']
              : DateTime.parse(map['lastLoginAt']))
          : DateTime.now(),
      hasSeenOnboarding: map['hasSeenOnboarding'] ?? false,
      userDetails: map['userDetails'] != null
          ? UserDetails.fromMap(map['userDetails'])
          : null,
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoURL': photoURL,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
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
