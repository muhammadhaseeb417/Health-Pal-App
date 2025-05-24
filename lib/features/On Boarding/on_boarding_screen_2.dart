import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_3.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/bottom_buttons_in_onBoard.dart';
import 'widgets/custom_header.dart';

class OnBoardingScreen2 extends StatefulWidget {
  final UserDetails? userDetails; // Accept UserDetails as a parameter
  const OnBoardingScreen2({super.key, this.userDetails});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
  int selectedAge = 1;
  final FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);
  bool _isCheckingOnboarding = true;
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();
  late UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    // Initialize userDetails from widget or create a new one
    userDetails = widget.userDetails ?? UserDetails(
      age: 0,
      weight: 0,
      weightUnit: WeightUnit.kg,
      goal: Goal.loseWeight,
      gender: Gender.male,
      height: 0,
    );
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        bool hasSeenOnboarding = await _getUserOnboardingStatus(user.uid);
        if (hasSeenOnboarding && mounted) {
          Navigator.pushReplacementNamed(context, '/navbar');
        }
      }
    } catch (e) {
      print('Error checking onboarding status: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingOnboarding = false;
        });
      }
    }
  }

  Future<bool> _getUserOnboardingStatus(String uid) async {
    try {
      return await _dbService.getHasSeenOnboarding(uid);
    } catch (e) {
      if (e.toString().contains('User data not found')) {
        await Future.delayed(Duration(seconds: 1));
        return await _dbService.getHasSeenOnboarding(uid);
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingOnboarding) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                      'What\'s your Age?',
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
                            userDetails = userDetails.copyWith(age: selectedAge);
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
              onPressed: () {
                // Pass updated userDetails to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnBoardingScreen3(userDetails: userDetails),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}