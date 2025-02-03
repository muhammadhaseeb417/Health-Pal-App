import 'package:flutter/material.dart';
import 'package:health_pal/features/Bottom%20Navigation%20Bar/UI/custom_bottom_navigation_bar.dart';
import 'package:health_pal/features/Home/widgets/custom_header_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Column(
              children: [
                CustomHeaderAppBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
