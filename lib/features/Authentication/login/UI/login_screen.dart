import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/login/widgets/custom_text_field.dart';
import '../../services/user_auth.dart';
import '../../services/firebase_database_func.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserAuth _userAuth = UserAuth();
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();
  bool _isLoading = false;

  // Check connectivity status
  Future<bool> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          height: 840,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/logo.png",
                    width: MediaQuery.sizeOf(context).width * 0.6,
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
              const SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/forgot_password');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Forget Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.maxFinite,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isLoading) return;

                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      // Validate inputs
                      if (_emailController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter email and password'),
                          ),
                        );
                        return;
                      }

                      // Check connectivity
                      bool isConnected = await _checkConnectivity();
                      if (!isConnected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'No internet connection. Your data will sync when connected.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }

                      // Get user input data
                      String email = _emailController.text.trim();
                      String password = _passwordController.text;

                      // Login user
                      final credential = await _userAuth
                          .signInWithEmailPassword(email, password);

                      if (credential != null && credential.user != null) {
                        // Sync pending data if connected
                        if (isConnected) {
                          await _dbService.syncPendingData();
                        }

                        try {
                          // Simply update the last login time
                          await _dbService
                              .updateUserData(credential.user!.uid, {
                            'lastLoginAt': DateTime.now().toIso8601String(),
                          });
                        } catch (e) {
                          print('Error updating user login time: $e');
                          // Still proceed with login even if updating time fails
                        }

                        // Navigate to home screen
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, "/navbar");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login successful'),
                          ),
                        );
                      } else {
                        throw Exception('Invalid credentials');
                      }
                    } catch (e) {
                      print('Login error: $e');
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Login failed: ${e.toString()}'),
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Login',
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
                    'Don\'t have an account ? ',
                    style: TextStyle(fontSize: 17),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, "/main_auth_screen"),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
