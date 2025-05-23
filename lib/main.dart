import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_pal/features/About%20Us/UI/about_us_screen.dart';
import 'package:health_pal/features/Authentication/main_auth_screen/UI/main_auth_screen.dart';
import 'package:health_pal/features/Authentication/login/UI/login_screen.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
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
import 'package:health_pal/features/Authentication/services/user_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/Home/UI/home_screen_2.dart';
import 'features/On%20Boarding/on_boarding_screen_4.dart';
import '../firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Create a global instance or use dependency injection
final UserAuth userAuth = UserAuth();
final FirebaseDatabaseService firebaseDatabaseService =
    FirebaseDatabaseService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");

  // Check app-level onboarding
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboardingOfApp =
      prefs.getBool('hasSeenOnboardingOfApp') ?? false;

  // Check user-specific onboarding (only if user is logged in)
  bool userHasSeenOnboarding = false;
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      userHasSeenOnboarding =
          await firebaseDatabaseService.getHasSeenOnboarding(currentUser.uid);
    } catch (e) {
      print('Error fetching user onboarding status: $e');
      // Default to false if there's an error
      userHasSeenOnboarding = false;
    }
  }

  runApp(MyApp(
    hasSeenOnboardingOfApp: hasSeenOnboardingOfApp,
    userHasSeenOnboarding: userHasSeenOnboarding,
  ));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboardingOfApp;
  final bool userHasSeenOnboarding;

  const MyApp({
    super.key,
    required this.hasSeenOnboardingOfApp,
    required this.userHasSeenOnboarding,
  });

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
        "/location": (context) => const LocationScreen(),
        "/food_description_page": (context) => const FoodDescriptionPage(),
      },
      home: AuthenticationWrapper(
        hasSeenOnboardingOfApp: hasSeenOnboardingOfApp,
        userHasSeenOnboarding: userHasSeenOnboarding,
        userAuth: userAuth,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final bool hasSeenOnboardingOfApp;
  final bool userHasSeenOnboarding;
  final UserAuth userAuth;

  const AuthenticationWrapper({
    super.key,
    required this.hasSeenOnboardingOfApp,
    required this.userHasSeenOnboarding,
    required this.userAuth,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: userAuth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show splash screen while waiting for auth state
          return const CircularProgressIndicator();
        }

        // If the snapshot has user data, then user is logged in
        if (snapshot.hasData) {
          // Check user-specific onboarding
          if (!userHasSeenOnboarding) {
            // User is logged in but hasn't seen user-specific onboarding
            return const OnBoardingScreen2();
          }
          // User is logged in and has seen onboarding, go to home
          return const CustomBottomNavigationBar();
        }

        // User is not logged in
        if (hasSeenOnboardingOfApp) {
          // User has seen app-level onboarding, go to login
          return const LoginScreen();
        } else {
          // User hasn't seen app-level onboarding, show onboarding
          return const OnBoardingScreen1();
        }
      },
    );
  }
}
