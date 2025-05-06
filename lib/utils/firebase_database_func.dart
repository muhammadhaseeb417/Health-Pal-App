import 'dart:developer';

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseFunc {
  // FirebaseDatabase instance
  static final database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://life-hero-app-118e4-default-rtdb.firebaseio.com/',
  );

  static final userRef = database.ref("lifehero_db").child("users_data");

  // Method to get data from the database
  void getData() {
    // Implementation for getting data from the database
  }

  // Method to set data in the database
  void setData({required Map<String, dynamic> userData}) async {
    try {
      await userRef.push().set(userData);
      log("Data saved successfully: ${userData['email']}");
    } catch (e) {
      log("Error saving data: $e");
      // Consider throwing the error to handle it upstream
    }
  }
}
