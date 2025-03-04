import 'package:flutter/material.dart';
import 'package:health_pal/features/On%20Boarding/widgets/custom_header.dart';
import 'package:health_pal/utils/constants/colors.dart';

import 'widgets/bottom_buttons_in_onBoard.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({super.key});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
  int selectedAge = 1;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0); // Start at age 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomHeader(pageIndex: 1),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    const Text(
                      'What’s your Age?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.1,
                    ),
                    SizedBox(
                      height: 250,
                      child: ListWheelScrollView.useDelegate(
                        controller: _scrollController,
                        itemExtent: 60,
                        diameterRatio: 1.5,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedAge = index + 1;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                          builder: (context, index) {
                            final age = index + 1;
                            final isSelected = age == selectedAge;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isSelected ? 100 : 80,
                              height: isSelected ? 70 : 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? CustomColors.greenColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$age',
                                style: TextStyle(
                                  fontSize: isSelected ? 50 : 40,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                          childCount: 150, // From 1 to 150
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom fixed buttons
            BottomButtonsInOnboard(
              onPressed: () => Navigator.pushNamed(context, '/onboard3'),
            ),
          ],
        ),
      ),
    );
  }
}
