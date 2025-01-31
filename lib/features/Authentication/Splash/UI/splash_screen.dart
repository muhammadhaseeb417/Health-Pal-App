import 'package:flutter/material.dart';

import '../widgets/signup_with_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
                    btnFor: "FACEBOOK",
                    icon: Icons.facebook,
                    btnColor: Color.fromARGB(255, 4, 83, 148),
                    callBack: () {},
                  ),
                  SizedBox(height: 15),
                  SignupWithWidget(
                    btnFor: "GOOGLE",
                    imgPath: "assets/logo/google_logo.png",
                    btnColor: Color.fromARGB(255, 197, 197, 197),
                    txtColor: Colors.black,
                    callBack: () {},
                  ),
                  SizedBox(height: 15),
                  SignupWithWidget(
                    btnFor: "EMAIL",
                    icon: Icons.mail,
                    btnColor: Colors.blue,
                    callBack: () {},
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account ? '),
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
