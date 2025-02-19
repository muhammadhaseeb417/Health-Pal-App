import 'package:flutter/material.dart';
import 'package:health_pal/features/Home/widgets/custom_header_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomHeaderAppBar(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        'Track your diet \njourney',
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Image.asset("assets/images/avacado.png", height: 200),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
