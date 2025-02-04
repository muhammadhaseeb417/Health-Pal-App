import 'package:flutter/material.dart';
import '../../login/widgets/custom_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.1), // Add some spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/logo.png",
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                ],
              ),
              const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const CustomTextField(
                textFieldFor: "Name",
                iconData: Icons.person,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                textFieldFor: "Email",
                iconData: Icons.mail,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                textFieldFor: "Password",
                iconData: Icons.password_rounded,
              ),
              const SizedBox(height: 20),
              const CustomTextField(
                textFieldFor: "Confirm Password",
                iconData: Icons.password_rounded,
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 40),
              SizedBox(
                width: double.maxFinite,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/navbar");
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 17),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/login"),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Add extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
