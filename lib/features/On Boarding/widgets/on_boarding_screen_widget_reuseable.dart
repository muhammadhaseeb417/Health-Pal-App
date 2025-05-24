import 'package:flutter/material.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'bottom_buttons_in_onBoard.dart';
import 'custom_header.dart';
import 'weiight_goal_selector.dart';

class OnBoardingScreenWidgetReuseable extends StatefulWidget {
  final String topText;
  final String nextPageRoute;
  final int pageIndex;
  final List<Map<String, dynamic>> goals; // Updated to include 'value'
  final UserDetails userDetails;
  final Function(UserDetails)? onComplete; // Updated to pass UserDetails

  const OnBoardingScreenWidgetReuseable({
    super.key,
    required this.topText,
    required this.nextPageRoute,
    required this.goals,
 required this.pageIndex,
    required this.userDetails,
    this.onComplete,
  });

  @override
  State<OnBoardingScreenWidgetReuseable> createState() => _OnBoardingScreenWidgetReuseableState();
}

class _OnBoardingScreenWidgetReuseableState extends State<OnBoardingScreenWidgetReuseable> {
  late UserDetails userDetails;
  dynamic selectedValue; // To store Goal or Gender

  @override
  void initState() {
    super.initState();
    userDetails = widget.userDetails;
    // Initialize selectedValue based on pageIndex
    selectedValue = widget.pageIndex == 3 ? userDetails.goal : userDetails.gender;
  }

  void _updateSelection(dynamic value) {
    setState(() {
      selectedValue = value;
      if (widget.pageIndex == 3) {
        userDetails = userDetails.copyWith(goal: value as Goal);
      } else if (widget.pageIndex == 4) {
        userDetails = userDetails.copyWith(gender: value as Gender);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomHeader(pageIndex: widget.pageIndex),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          textAlign: TextAlign.center,
                          widget.topText,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    WeightGoalSelector(
                      goals: widget.goals,
                      selectedValue: selectedValue,
                      onValueSelected: _updateSelection,
                    ),
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
                onPressed: () {
                  if (widget.onComplete != null && widget.pageIndex == 4) {
                    // Call onComplete with updated userDetails for the final screen
                    widget.onComplete!(userDetails);
                  } else {
                    // Navigate to the next screen with updated userDetails
                    Navigator.pushNamed(
                      context,
                      widget.nextPageRoute,
                      arguments: {'userDetails': userDetails},
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}