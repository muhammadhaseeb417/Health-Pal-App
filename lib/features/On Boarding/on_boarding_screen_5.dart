import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';
import 'package:health_pal/features/On%20Boarding/widgets/on_boarding_screen_widget_reuseable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen5 extends StatelessWidget {
  const OnBoardingScreen5({super.key});

  Future<void> _completeOnboarding(BuildContext context, UserDetails userDetails) async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is logged in');
      }

      // Save userDetails to Firestore
      final firebaseDatabaseService = FirebaseDatabaseService();
      await firebaseDatabaseService.updateUserDetails(user.uid, userDetails);

      // Update hasSeenOnboarding in Firestore
      await firebaseDatabaseService.setHasSeenOnboarding(user.uid);

      // Update app-level onboarding in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboardingOfApp', true);

      // Navigate to the main app
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/navbar');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error completing onboarding: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract userDetails from route arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final UserDetails userDetails = args?['userDetails'] ?? UserDetails(
      age: 0,
      weight: 0,
      weightUnit: WeightUnit.kg,
      goal: Goal.loseWeight,
      gender: Gender.male,
      height: 0,
    );

    final List<Map<String, dynamic>> goals = [
      {'title': 'Male', 'image': 'assets/onboardimgs/male.png', 'value': Gender.male},
      {'title': 'Female', 'image': 'assets/onboardimgs/female.png', 'value': Gender.female},
      {'title': 'Other', 'image': 'assets/onboardimgs/other.png', 'value': Gender.other},
    ];

    return OnBoardingScreenWidgetReuseable(
      topText: 'What\'s your gender?',
      goals: goals,
      nextPageRoute: "/navbar",
      pageIndex: 4,
      userDetails: userDetails,
      onComplete: (updatedUserDetails) => _completeOnboarding(context, updatedUserDetails),
    );
  }
}