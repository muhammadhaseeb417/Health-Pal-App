import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_database_func.dart';

class UserAuth {
  static final firebaseInstance = FirebaseAuth.instance;

  // Stream to listen to auth changes
  static Stream<User?> get authStateChanges =>
      firebaseInstance.authStateChanges();

  static Future<bool> signup({
    required Map<String, dynamic> userData,
    required String password,
  }) async {
    try {
      final email = userData["email"];

      if (email == null || password == null) {
        log("Email or password is missing in userData");
        return false;
      }

      UserCredential userCred = await firebaseInstance
          .createUserWithEmailAndPassword(email: email, password: password);

      final userId = userCred.user?.uid;
      userData["userId"] = userId;
      FirebaseDatabaseFunc().setData(userData: userData);
      return true;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          log("The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          log("The account already exists for that email.");
        } else if (e.code == 'invalid-email') {
          log("The email address is badly formatted.");
        } else {
          log("Error: ${e.message}");
        }
      } else {
        log("Error: $e");
      }
      return false;
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      await firebaseInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          log("No user found for that email.");
        } else if (e.code == 'wrong-password') {
          log("Wrong password provided for that user.");
        } else if (e.code == 'invalid-email') {
          log("The email address is badly formatted.");
        } else if (e.code == 'user-disabled') {
          log("User account has been disabled.");
        } else {
          log("Error: ${e.message}");
        }
      } else {
        log("Error: $e");
      }
      return false;
    }
  }

  static Future<bool> logout() async {
    try {
      await firebaseInstance.signOut();
      return true;
    } catch (e) {
      log("Error signing out: $e");
      return false;
    }
  }

  // Get current user
  static User? get currentUser => firebaseInstance.currentUser;

  // Check if user is logged in
  static bool get isLoggedIn => currentUser != null;

  // Listen to user authentication state changes
  static void listenToAuthChanges(Function(User?) onAuthStateChanged) {
    firebaseInstance.authStateChanges().listen(onAuthStateChanged);
  }

  // Get user ID
  static String? get userId => currentUser?.uid;

  // Password reset email
  static Future<bool> resetPassword(String email) async {
    try {
      await firebaseInstance.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      log("Error sending password reset email: $e");
      return false;
    }
  }

  // Update user profile
  static Future<bool> updateProfile(
      {String? displayName, String? photoURL}) async {
    try {
      await currentUser?.updateDisplayName(displayName);
      await currentUser?.updatePhotoURL(photoURL);
      return true;
    } catch (e) {
      log("Error updating profile: $e");
      return false;
    }
  }

  // Delete user account
  static Future<bool> deleteAccount() async {
    try {
      await currentUser?.delete();
      return true;
    } catch (e) {
      log("Error deleting account: $e");
      return false;
    }
  }
}
