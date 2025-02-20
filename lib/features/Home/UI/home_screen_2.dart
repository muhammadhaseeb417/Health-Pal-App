import 'package:flutter/material.dart';
import 'package:health_pal/features/Home/widgets/calorie_gauge_widget.dart';
import 'package:health_pal/features/Home/widgets/custom_header_app_bar.dart';
import 'package:health_pal/features/Home/widgets/nutrition_graph_widget.dart';
import 'package:health_pal/utils/constants/colors.dart';

import '../widgets/add_food_widget_home.dart';

class HomeScreentwo extends StatelessWidget {
  const HomeScreentwo({super.key});

  @override
  Widget build(BuildContext context) {
    const List<Map<String, String>> foodItems = [
      {
        'title': 'Add Breakfast',
        'subTitle': 'Recommended 450-650 cal',
        'imgPath':
            'assets/images/breakfast.png', // Add actual image path if available
      },
      {
        'title': 'Add Snack',
        'subTitle': 'Recommended 150-250 cal',
        'imgPath': 'assets/images/snack.webp',
      },
      {
        'title': 'Add Lunch',
        'subTitle': 'Recommended 450-650 cal',
        'imgPath': 'assets/images/lunch.png',
      },
      {
        'title': 'Add Dinner',
        'subTitle': 'Recommended 450-650 cal',
        'imgPath': 'assets/images/dinner.jpg',
      },
    ];

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
                    const SizedBox(height: 40),
                    NutritionGraph(),
                    const SizedBox(height: 40),
                    listViewForDatesBelow(),
                    const SizedBox(height: 40),
                    ListView.builder(
                      shrinkWrap:
                          true, // Important for nesting in SingleChildScrollView
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable internal scrolling
                      itemCount: foodItems.length,
                      itemBuilder: (context, index) {
                        final item = foodItems[index];
                        return Column(
                          children: [
                            AddFoodWidgetHome(
                              title: item['title']!,
                              subTitle: item['subTitle']!,
                              imgPath: item['imgPath']!,
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      },
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

  Row listViewForDatesBelow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.arrow_back_ios),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ListView.builder(
              itemCount: 30,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      const Text(
                        'Mon',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        (index + 1).toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        const Icon(Icons.arrow_forward_ios),
      ],
    );
  }
}
