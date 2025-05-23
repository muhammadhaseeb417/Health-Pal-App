import 'package:flutter/material.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/bottom_buttons_in_onBoard.dart';

class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({super.key});

  @override
  State<OnBoardingScreen1> createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {});
  }

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
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Nutrition',
                          style: TextStyle(
                              fontSize: 25,
                              color: CustomColors.blueColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          ',',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Transform Your ',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Health',
                          style: TextStyle(
                              fontSize: 25,
                              color: CustomColors.greenColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Text('Stay healthy by tracking every meal.'),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
            BottomButtonsInOnboard(
              onPressed: prefs == null
                  ? () {} // Provide empty function instead of null
                  : () {
                      // Handle async operation without making the callback async
                      prefs!.setBool('hasSeenOnboardingOfApp', true).then((_) {
                        Navigator.pushNamed(context, '/login');
                      });
                    },
            ),
          ],
        ),
      ),
    );
  }
}
