import 'package:flutter/material.dart';
import 'package:health_pal/features/On%20Boarding/widgets/weiight_goal_selector.dart';

import 'bottom_buttons_in_onBoard.dart';
import 'custom_header.dart';

class OnBoardingScreenWidgetReuseable extends StatelessWidget {
  final String topText;
  final String nextPageRoute;
  final int pageIndex;
  final List<Map<String, String>> goals;
  const OnBoardingScreenWidgetReuseable(
      {super.key,
      required this.topText,
      required this.nextPageRoute,
      required this.goals,
      required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomHeader(pageIndex: pageIndex),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        textAlign: TextAlign.center,
                        topText,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  WeightGoalSelector(goals: goals),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomButtonsInOnboard(
              onPressed: () => Navigator.pushNamed(context, nextPageRoute),
            ),
          ),
        ],
      )),
    );
  }
}
