import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_pal/features/About%20Us/UI/about_us_screen.dart';
import 'package:health_pal/features/Authentication/Splash/UI/splash_screen.dart';
import 'package:health_pal/features/Authentication/login/UI/login_screen.dart';
import 'package:health_pal/features/Authentication/signup/UI/signup_screen.dart';
import 'package:health_pal/features/Bottom%20Navigation%20Bar/UI/custom_bottom_navigation_bar.dart';
import 'package:health_pal/features/Food%20Description%20Page/food_description_page.dart';
import 'package:health_pal/features/Location/location_screen.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_1.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_2.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_3.dart';
import 'package:health_pal/features/On%20Boarding/on_boarding_screen_5.dart';
import 'package:health_pal/features/Profile/UI/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_pal/utils/user_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/Home/UI/home_screen_2.dart';
import 'features/On Boarding/on_boarding_screen_4.dart';
import '../firebase_options.dart'; // Import your UserAuth class
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  // Check if user has seen onboarding
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Pal',
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
        "/onboard4": (context) => const OnBoardingScreen4(),
        "/onboard5": (context) => const OnBoardingScreen5(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreentwo(),
        "/aboutus": (context) => const AboutUsScreen(),
        "/navbar": (context) => const CustomBottomNavigationBar(),
        "/profile": (context) => const ProfileScreen(),
        "/signup": (context) => const SignupScreen(),
        "/food_description_page": (context) => const FoodDescriptionPage(),
      },
      // home: AuthenticationWrapper(hasSeenOnboarding: hasSeenOnboarding),
      home: LocationScreen(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final bool hasSeenOnboarding;

  const AuthenticationWrapper({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: UserAuth.authStateChanges,
      builder: (context, snapshot) {
        // If the snapshot has user data, then user is logged in
        if (snapshot.hasData) {
          // User is logged in, navigate to home
          return const CustomBottomNavigationBar();
        }

        // User is not logged in
        if (hasSeenOnboarding) {
          // User has seen onboarding, go to login
          return const LoginScreen();
        } else {
          // User hasn't seen onboarding, show onboarding
          return const OnBoardingScreen1();
        }
      },
    );
  }
}
