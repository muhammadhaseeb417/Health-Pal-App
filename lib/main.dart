import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_pal/features/About%20Us/UI/about_us_screen.dart';
import 'package:health_pal/features/Authentication/Splash/UI/splash_screen.dart';
import 'package:health_pal/features/Authentication/login/UI/login_screen.dart';
import 'package:health_pal/features/Authentication/signup/UI/signup_screen.dart';
import 'package:health_pal/features/Bottom%20Navigation%20Bar/UI/custom_bottom_navigation_bar.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_1.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_2.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_3.dart';
import 'package:health_pal/features/Profile/UI/profile_screen.dart';

import 'features/Home/UI/home_screen_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: GoogleFonts.poppins().fontFamily,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/splash": (context) => const SplashScreen(),
        "/onboard1": (context) => const OnBoardingScreen1(),
        "/onboard2": (context) => const OnBoardingScreen2(),
        "/onboard3": (context) => const OnBoardingScreen3(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreentwo(),
        "/aboutus": (context) => const AboutUsScreen(),
        "/navbar": (context) => const CustomBottomNavigationBar(),
        "/profile": (context) => const ProfileScreen(),
        "/signup": (context) => const SignupScreen(),
      },
      initialRoute: "/onboard1",
    );
  }
}
