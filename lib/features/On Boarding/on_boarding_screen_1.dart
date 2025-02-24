import 'package:flutter/material.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'package:lottie/lottie.dart';

import 'widgets/bottom_buttons_in_onBoard.dart';

class OnBoardingScreen1 extends StatelessWidget {
  const OnBoardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo/logo.png",
                        width: MediaQuery.sizeOf(context).width * 0.4,
                      ),
                      Lottie.asset("assets/animation/onBoard.json"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Track Your ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Nutrition',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: CustomColors.blueColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            ',',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Transform Your ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Health',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              color: CustomColors.greenColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text('Stay healthy by tracking every meal.'),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              BottomButtonsInOnboard(
                onPressed: () => Navigator.pushNamed(context, '/onboard2'),
              ),
            ],
          ),
        ));
  }
}
