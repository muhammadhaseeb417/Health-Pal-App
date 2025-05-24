import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';
import 'dart:async';
import '../models/user_model.dart';

class FirebaseDatabaseService {
  static final FirebaseDatabaseService _instance =
      FirebaseDatabaseService._internal();

  factory FirebaseDatabaseService() => _instance;

  FirebaseDatabaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get healthDataCollection =>
      _firestore.collection('health_data');

  // Create user document in Firestore with UserModel
  Future<void> createUserDocument(User user,
      {required String name, Map<String, dynamic>? additionalData}) async {
    try {
      // Create UserModel instance
      UserModel userModel = UserModel.fromUser(
        user,
        name: name,
      );

      // Convert to map and add any additional data
      Map<String, dynamic> userData = userModel.toMap();
      if (additionalData != null) {
        userData.addAll(additionalData);
      }

      // Check if document exists before setting
      DocumentSnapshot doc = await usersCollection.doc(user.uid).get();
      if (doc.exists) {
        // Update only the last login time if user already exists
        await usersCollection.doc(user.uid).update({
          'lastLoginAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new document if user doesn't exist
        await usersCollection.doc(user.uid).set(userData);
      }
    } catch (e) {
      throw Exception('Failed to create user document: ${e.toString()}');
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserId == null) return null;

      DocumentSnapshot doc = await usersCollection.doc(currentUserId!).get();
      if (!doc.exists) {
        return null;
      }
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get current user data: ${e.toString()}');
    }
  }

  // Stream current user data for real-time updates
  Stream<UserModel?> streamCurrentUserData() {
    try {
      if (currentUserId == null) {
        return Stream.value(null);
      }

      return usersCollection
          .doc(currentUserId!)
          .snapshots()
          .handleError((error) {
        print('Error streaming current user data: $error');
        throw Exception(
            'Failed to stream current user data: ${error.toString()}');
      }).map((snapshot) {
        if (!snapshot.exists) {
          return null;
        }
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      });
    } catch (e) {
      print('Error setting up current user data stream: $e');
      throw Exception(
          'Failed to set up current user data stream: ${e.toString()}');
    }
  }

  // Update user profile (name, photoURL)
  Future<void> updateUserProfile({String? name, String? photoURL}) async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }

      Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (photoURL != null) updateData['photoURL'] = photoURL;

      if (updateData.isNotEmpty) {
        await usersCollection.doc(currentUserId!).update(updateData);
      }
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // Update user details in Firestore
  Future<void> updateUserDetails(String userId, UserDetails userDetails) async {
    try {
      await usersCollection.doc(userId).update({
        'userDetails': userDetails.toMap(),
      });
    } catch (e) {
      throw Exception('Failed to update user details: ${e.toString()}');
    }
  }

  // Update current user details
  Future<void> updateCurrentUserDetails(UserDetails userDetails) async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }
      await updateUserDetails(currentUserId!, userDetails);
    } catch (e) {
      throw Exception('Failed to update current user details: ${e.toString()}');
    }
  }

  // Update user data with UserModel
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user data: ${e.toString()}');
    }
  }

  // Get user data and convert to UserModel
  Future<UserModel> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (!doc.exists) {
        throw Exception('User data not found');
      }
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  // Fetch hasSeenOnboarding status for a user by UID
  Future<bool> getHasSeenOnboarding(String userId) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(userId).get();
      if (!doc.exists) {
        throw Exception('User data not found');
      }
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['hasSeenOnboarding'] ?? false;
    } catch (e) {
      throw Exception('Failed to fetch onboarding status: ${e.toString()}');
    }
  }

  // Set hasSeenOnboarding to true for a user by UID
  Future<void> setHasSeenOnboarding(String userId) async {
    try {
      await usersCollection.doc(userId).update({
        'hasSeenOnboarding': true,
      });
    } catch (e) {
      throw Exception('Failed to set onboarding status: ${e.toString()}');
    }
  }

  // Stream user data as UserModel for real-time updates with error handling
  Stream<UserModel> streamUserData(String userId) {
    try {
      return usersCollection.doc(userId).snapshots().handleError((error) {
        print('Error streaming user data: $error');
        throw Exception('Failed to stream user data: ${error.toString()}');
      }).map((snapshot) {
        if (!snapshot.exists) {
          throw Exception('User data not found');
        }
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      });
    } catch (e) {
      print('Error setting up user data stream: $e');
      throw Exception('Failed to set up user data stream: ${e.toString()}');
    }
  }

  // Save health data with retry mechanism
  Future<DocumentReference> saveHealthData(
      String userId, Map<String, dynamic> healthData,
      {int retries = 3}) async {
    try {
      // Add timestamp and userId to the data
      healthData['timestamp'] = FieldValue.serverTimestamp();
      healthData['userId'] = userId;

      return await healthDataCollection.add(healthData);
    } catch (e) {
      if (retries > 0) {
        print('Retrying save health data (${retries} attempts left)');
        // Wait before retrying
        await Future.delayed(Duration(seconds: 1));
        return saveHealthData(userId, healthData, retries: retries - 1);
      } else {
        throw Exception('Failed to save health data: ${e.toString()}');
      }
    }
  }

  // Get health data for a specific user with caching
  Future<QuerySnapshot> getHealthData(String userId) async {
    try {
      return await healthDataCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
    } catch (e) {
      throw Exception('Failed to get health data: ${e.toString()}');
    }
  }

  // Stream health data for real-time updates with error handling
  Stream<QuerySnapshot> streamHealthData(String userId) {
    try {
      return healthDataCollection
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .handleError((error) {
        print('Error streaming health data: $error');
        throw Exception('Failed to stream health data: ${error.toString()}');
      });
    } catch (e) {
      print('Error setting up health data stream: $e');
      throw Exception('Failed to set up health data stream: ${e.toString()}');
    }
  }

  // Delete specific health data entry with retry
  Future<void> deleteHealthData(String documentId, {int retries = 3}) async {
    try {
      await healthDataCollection.doc(documentId).delete();
    } catch (e) {
      if (retries > 0) {
        print('Retrying delete health data (${retries} attempts left)');
        // Wait before retrying
        await Future.delayed(Duration(seconds: 1));
        return deleteHealthData(documentId, retries: retries - 1);
      } else {
        throw Exception('Failed to delete health data: ${e.toString()}');
      }
    }
  }

  // Delete user account and all associated data with transaction
  Future<void> deleteUserAccount(String userId) async {
    try {
      return _firestore.runTransaction((transaction) async {
        // Delete all health data documents for this user
        QuerySnapshot healthDataSnapshot =
            await healthDataCollection.where('userId', isEqualTo: userId).get();

        // Delete each health data document within the transaction
        for (DocumentSnapshot doc in healthDataSnapshot.docs) {
          transaction.delete(doc.reference);
        }

        // Delete user document
        transaction.delete(usersCollection.doc(userId));
      });
    } catch (e) {
      print('Error deleting user account: $e');
      throw Exception('Failed to delete user data: ${e.toString()}');
    }
  }

  // Simplified data sync method - just a placeholder now that we've removed sync status
  Future<void> syncPendingData() async {
    // No longer tracking sync status, so this is a no-op
    return Future.value();
  }

  // Check connectivity status
  Future<bool> checkConnectivity() async {
    try {
      // Simple connectivity check by trying to get a document
      await _firestore.collection('connectivity_check').doc('test').get();
      return true; // If we reach here, we're connected
    } catch (e) {
      print('Error checking connectivity: $e');
      return false; // Assume not connected if there's an error
    }
  }
}
