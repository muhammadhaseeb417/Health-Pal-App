import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../utils/user_auth.dart' show UserAuth;
import '../../login/widgets/custom_text_field.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _confirmPasswordController =
        TextEditingController();

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
              CustomTextField(
                textFieldFor: "Name",
                iconData: Icons.person,
                regExp: RegExp(r'^[a-zA-Z ]+$'),
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textFieldFor: "Email",
                iconData: Icons.mail,
                regExp: RegExp(r'[a-zA-Z0-9@.]'),
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textFieldFor: "Password",
                iconData: Icons.password_rounded,
                controller: _passwordController,
                isPasswordField: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textFieldFor: "Confirm Password",
                iconData: Icons.password_rounded,
                controller: _confirmPasswordController,
                isPasswordField: true,
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 40),
              SizedBox(
                width: double.maxFinite,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    print("Sign Up button pressed");

                    Map<String, dynamic> data = {
                      "name": _nameController.text,
                      "email": _emailController.text,
                    };

                    if (_nameController.text.isEmpty ||
                        _emailController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields'),
                        ),
                      );
                      if (_passwordController.text !=
                          _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Password and Confirm Password do not match'),
                          ),
                        );
                      }
                      return;
                    } else {
                      final result = await UserAuth.signup(
                          userData: data, password: _passwordController.text);
                      if (result == true) {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, "/navbar");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login successful'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login failed'),
                          ),
                        );
                      }
                    }
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
