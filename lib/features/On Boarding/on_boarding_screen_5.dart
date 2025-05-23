import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/on_boarding_screen_widget_reuseable.dart';

class OnBoardingScreen5 extends StatelessWidget {
  const OnBoardingScreen5({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is logged in');
      }

      // Update hasSeenOnboarding in Firestore
      final firebaseDatabaseService = FirebaseDatabaseService();
      await firebaseDatabaseService.setHasSeenOnboarding(user.uid);

      // Optionally update app-level onboarding in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboardingOfApp', true);

      // Navigate to the main app (bottom navigation bar)
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/navbar');
      }
    } catch (e) {
      // Handle errors (e.g., show a snackbar or dialog)
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error completing onboarding: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> goals = [
      {'title': 'Male', 'image': 'assets/onboardimgs/male.png'},
      {'title': 'Female', 'image': 'assets/onboardimgs/female.png'},
      {'title': 'Other', 'image': 'assets/onboardimgs/other.png'},
    ];

    return OnBoardingScreenWidgetReuseable(
      topText: 'What\'s your gender?',
      goals: goals,
      nextPageRoute: "/navbar",
      pageIndex: 4,
      onComplete: () => _completeOnboarding(context),
    );
  }
}
