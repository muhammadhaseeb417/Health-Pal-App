import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/on_boarding_screen_widget_reuseable.dart';

class OnBoardingScreen5 extends StatelessWidget {
  const OnBoardingScreen5({super.key});

  Future<void> _completeOnboarding(BuildContext context) async {
    // Save that user has completed onboarding
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    // Navigate to login screen
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, "/login");
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
      nextPageRoute: "/login",
      pageIndex: 4,
      onComplete: () => _completeOnboarding(context),
    );
  }
}
