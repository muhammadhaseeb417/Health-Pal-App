import 'package:flutter/material.dart';
import 'widgets/on_boarding_screen_widget_reuseable.dart';

class OnBoardingScreen5 extends StatelessWidget {
  const OnBoardingScreen5({super.key});

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
    );
  }
}
