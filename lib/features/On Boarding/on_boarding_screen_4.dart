import 'package:flutter/material.dart';
import 'package:health_pal/features/On%20Boarding/widgets/weiight_goal_selector.dart';

import 'widgets/bottom_buttons_in_onBoard.dart';
import 'widgets/custom_header.dart';
import 'widgets/on_boarding_screen_widget_reuseable.dart';

class OnBoardingScreen4 extends StatelessWidget {
  const OnBoardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> goals = [
      {'title': 'Lose weight', 'image': 'assets/onboardimgs/lose_weight.png'},
      {
        'title': 'Maintain weight',
        'image': 'assets/onboardimgs/maintain_weight.png'
      },
      {'title': 'Gain weight', 'image': 'assets/onboardimgs/gain_weight.png'},
    ];

    return OnBoardingScreenWidgetReuseable(
      topText: 'What goal do you\n have in mind?',
      goals: goals,
      nextPageRoute: "/onboard5",
      pageIndex: 3,
    );
  }
}
