import 'package:flutter/material.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_4_next.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'widgets/bottom_buttons_in_onBoard.dart';
import 'widgets/buttons_in_onBoard3.dart';
import 'widgets/custom_header.dart';
import 'widgets/weight_scale_widget.dart';

class OnBoardingScreen3 extends StatefulWidget {
  final UserDetails userDetails;
  const OnBoardingScreen3({super.key, required this.userDetails});

  @override
  State<OnBoardingScreen3> createState() => _OnBoardingScreen3State();
}

class _OnBoardingScreen3State extends State<OnBoardingScreen3> {
  late double _currentWeight;
  late String _weightUnit;
  late UserDetails userDetails;

  @override
  void initState() {
    super.initState();
    userDetails = widget.userDetails;
    _currentWeight = userDetails.weight != 0 ? userDetails.weight : 62.0;
    _weightUnit = userDetails.weightUnit == WeightUnit.kg ? 'Kg' : 'Lbs';
  }

  void _updateWeight(double value) {
    setState(() {
      _currentWeight = value;
      userDetails = userDetails.copyWith(weight: _currentWeight);
    });
  }

  void _toggleWeightUnit(String unit) {
    setState(() {
      _weightUnit = unit;
      userDetails = userDetails.copyWith(
        weightUnit: unit == 'Kg' ? WeightUnit.kg : WeightUnit.lbs,
        weight: _currentWeight, // Preserve the current weight
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.greenShadeColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const CustomHeader(makeItemsWhite: true, pageIndex: 2),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    const Text(
                      textAlign: TextAlign.center,
                      'What\'s your current weight right now?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ButtonsInOnboard3(
                          label: 'Kg',
                          isSelected: _weightUnit == 'Kg',
                          onTap: () => _toggleWeightUnit('Kg'),
                        ),
                        const SizedBox(width: 20),
                        ButtonsInOnboard3(
                          label: 'Lbs',
                          isSelected: _weightUnit == 'Lbs',
                          onTap: () => _toggleWeightUnit('Lbs'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Text(
                      '${_currentWeight.toStringAsFixed(1)} $_weightUnit',
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    WeightScaleWidget(
                      minValue: 1.0,
                      maxValue: 1000.0,
                      initialValue: _currentWeight,
                      onValueChanged: (value) {
                        _updateWeight(value);
                      },
                      showDecimal: true,
                      decimalPlaces: 1,
                    ),
                  ],
                ),
              ),
            ),
            BottomButtonsInOnboard(
              bottomGreen: true,
              onPressed: () {
                // Pass updated userDetails to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnBoardingScreen4Next(userDetails: userDetails),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}