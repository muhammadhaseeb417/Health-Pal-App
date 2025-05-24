import 'package:flutter/material.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';
import 'package:health_pal/features/On%20Boarding/widgets/on_boarding_screen_widget_reuseable.dart';

class OnBoardingScreen4 extends StatelessWidget {
  const OnBoardingScreen4({super.key});

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
      {'title': 'Lose weight', 'image': 'assets/onboardimgs/lose_weight.png', 'value': Goal.loseWeight},
      {'title': 'Maintain weight', 'image': 'assets/onboardimgs/maintain_weight.png', 'value': Goal.maintainWeight},
      {'title': 'Gain weight', 'image': 'assets/onboardimgs/gain_weight.png', 'value': Goal.gainWeight},
    ];

    return OnBoardingScreenWidgetReuseable(
      topText: 'What goal do you\n have in mind?',
      goals: goals,
      nextPageRoute: "/onboard5",
      pageIndex: 3,
      userDetails: userDetails,
    );
  }
}