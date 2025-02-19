import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health_pal/features/Bottom%20Navigation%20Bar/UI/custom_bottom_navigation_bar.dart';
import 'package:health_pal/features/Home/widgets/calorie_gauge_widget.dart';
import 'package:health_pal/features/Home/widgets/custom_header_app_bar.dart';
import 'package:health_pal/features/Home/widgets/linear_gauge_widget_details.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeScreentwo extends StatelessWidget {
  const HomeScreentwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomHeaderAppBar(),
              ),
              Stack(
                children: [
                  const Center(child: CalorieGaugeWidget()),
                  Positioned(
                      right: 0,
                      top: -10,
                      child: Image.asset("assets/images/avacado.png",
                          height: 150)),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Track your diet \njourney',
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Today Calorie: 1721',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.orangeColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
