import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_4.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/bottom_buttons_in_onBoard.dart';
import 'widgets/custom_header.dart';

class OnBoardingScreen4Next extends StatefulWidget {
  final UserDetails userDetails;
  const OnBoardingScreen4Next({super.key, required this.userDetails});

  @override
  State<OnBoardingScreen4Next> createState() => _OnBoardingScreen4NextState();
}

class _OnBoardingScreen4NextState extends State<OnBoardingScreen4Next> {
  int selectedHeight = 170; // Default height in cm
  bool isMetric = true; // true for cm, false for ft/in
  int selectedFeet = 5;
  int selectedInches = 7;
  
  final FixedExtentScrollController _heightScrollController =
      FixedExtentScrollController(initialItem: 69); // 170cm - 101 = 69
  final FixedExtentScrollController _feetController =
      FixedExtentScrollController(initialItem: 1); // 5ft - 4 = 1
  final FixedExtentScrollController _inchesController =
      FixedExtentScrollController(initialItem: 7); // 7 inches
      
  bool _isCheckingOnboarding = true;
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();
  late UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    userDetails = widget.userDetails;
    // Initialize height from userDetails if available
    if (userDetails.height != 0) {
      selectedHeight = userDetails.height.round();
      isMetric = true;
      _heightScrollController.jumpToItem(selectedHeight - 101);
    } else {
      selectedHeight = 170;
      isMetric = true;
    }
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

  void _toggleUnit() {
    setState(() {
      isMetric = !isMetric;
      if (isMetric) {
        // Convert ft/in to cm
        selectedHeight = ((selectedFeet * 12 + selectedInches) * 2.54).round();
        _heightScrollController.animateToItem(
          selectedHeight - 101,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        // Convert cm to ft/in
        int totalInches = (selectedHeight / 2.54).round();
        selectedFeet = totalInches ~/ 12;
        selectedInches = totalInches % 12;
        
        // Ensure feet is within range (4-8)
        selectedFeet = selectedFeet.clamp(4, 8);
        
        _feetController.animateToItem(
          selectedFeet - 4,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _inchesController.animateToItem(
          selectedInches,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
      // Update userDetails with the current height
      int heightInCm = isMetric 
          ? selectedHeight 
          : ((selectedFeet * 12 + selectedInches) * 2.54).round();
      userDetails = userDetails.copyWith(height: heightInCm.toDouble());
    });
  }

  Widget _buildMetricPicker() {
    return Column(
      children: [
        Text(
          '$selectedHeight cm',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.greenColor,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: ListWheelScrollView.useDelegate(
            controller: _heightScrollController,
            itemExtent: 60,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedHeight = index + 101; // Height from 101cm to 250cm
                userDetails = userDetails.copyWith(height: selectedHeight.toDouble());
              });
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final height = index + 101;
                final isSelected = height == selectedHeight;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 120 : 100,
                  height: isSelected ? 70 : 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? CustomColors.greenColor : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? CustomColors.greenColor : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    '$height cm',
                    style: TextStyle(
                      fontSize: isSelected ? 18 : 16,
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
              childCount: 150, // From 101cm to 250cm
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImperialPicker() {
    return Column(
      children: [
        Text(
          '$selectedFeet\' $selectedInches"',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: CustomColors.greenColor,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Feet picker
            Container(
              width: 120,
              height: 250,
              child: Column(
                children: [
                  Text(
                    'Feet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: _feetController,
                      itemExtent: 50,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedFeet = index + 4; // Feet from 4 to 8
                          int heightInCm = ((selectedFeet * 12 + selectedInches) * 2.54).round();
                          userDetails = userDetails.copyWith(height: heightInCm.toDouble());
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final feet = index + 4;
                          final isSelected = feet == selectedFeet;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isSelected ? 80 : 60,
                            height: isSelected ? 50 : 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? CustomColors.greenColor : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? CustomColors.greenColor : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              '$feet\'',
                              style: TextStyle(
                                fontSize: isSelected ? 18 : 16,
                                color: isSelected ? Colors.white : Colors.black54,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                        childCount: 5, // From 4ft to 8ft
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Inches picker
            Container(
              width: 120,
              height: 250,
              child: Column(
                children: [
                  Text(
                    'Inches',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: _inchesController,
                      itemExtent: 50,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedInches = index; // Inches from 0 to 11
                          int heightInCm = ((selectedFeet * 12 + selectedInches) * 2.54).round();
                          userDetails = userDetails.copyWith(height: heightInCm.toDouble());
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final inches = index;
                          final isSelected = inches == selectedInches;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: isSelected ? 80 : 60,
                            height: isSelected ? 50 : 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? CustomColors.greenColor : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected ? CustomColors.greenColor : Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              '$inches"',
                              style: TextStyle(
                                fontSize: isSelected ? 18 : 16,
                                color: isSelected ? Colors.white : Colors.black54,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                        childCount: 12, // From 0" to 11"
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
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
                    const CustomHeader(pageIndex: 3),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    const Text(
                      'What\'s your Height?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                    
                    // Unit toggle buttons
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (!isMetric) _toggleUnit();
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: isMetric ? CustomColors.greenColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'CM',
                                style: TextStyle(
                                  color: isMetric ? Colors.white : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isMetric) _toggleUnit();
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              decoration: BoxDecoration(
                                color: !isMetric ? CustomColors.greenColor : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'FT/IN',
                                style: TextStyle(
                                  color: !isMetric ? Colors.white : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 30),
                    
                    // Height picker
                    isMetric ? _buildMetricPicker() : _buildImperialPicker(),
                  ],
                ),
              ),
            ),
            
            // Bottom fixed buttons
            BottomButtonsInOnboard(
  onPressed: () {
    Navigator.pushNamed(
      context,
      '/onboard4',
      arguments: {'userDetails': userDetails},
    );
  },
)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heightScrollController.dispose();
    _feetController.dispose();
    _inchesController.dispose();
    super.dispose();
  }
}