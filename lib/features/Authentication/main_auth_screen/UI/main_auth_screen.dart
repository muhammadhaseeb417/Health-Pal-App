import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/services/user_auth.dart';
import '../widgets/signup_with_widget.dart';

class MainAuthScreen extends StatefulWidget {
  const MainAuthScreen({super.key});

  @override
  State<MainAuthScreen> createState() => _MainAuthScreenState();
}

class _MainAuthScreenState extends State<MainAuthScreen> {
  bool _isLoading = false;
  final UserAuth userAuth = UserAuth();

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    if (_isLoading) return;
    
    setState(() => _isLoading = true);
    
    try {
      await userAuth.signInWithGoogle();
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signed in with Google'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, "/onboard2");
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    "assets/logo/logo.png",
                    width: MediaQuery.sizeOf(context).width * 0.6,
                  ),
                  const Text(
                    'Nutritionist\n in your\n pocket',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.w500,
                      height: 0.95,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SignupWithWidget(
                    btnFor: "GOOGLE",
                    imgPath: "assets/logo/google_logo.png",
                    btnColor: const Color.fromARGB(255, 197, 197, 197),
                    txtColor: Colors.black,
                    callBack: () => _handleGoogleSignIn(context),
                  ),
                  const SizedBox(height: 15),
                  SignupWithWidget(
                    btnFor: "EMAIL",
                    icon: Icons.mail,
                    btnColor: Colors.blue,
                    callBack: () {
                      Navigator.pushNamed(context, "/signup");
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, "/login"),
                        child: const Text(
                          'LOG IN',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
