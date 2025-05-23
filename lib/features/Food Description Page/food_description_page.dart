import 'package:flutter/material.dart';
import 'package:health_pal/features/Food%20Description%20Page/widgets/food_description_gauge_style.dart';

import '../../utils/constants/colors.dart';

class FoodDescriptionPage extends StatelessWidget {
  const FoodDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Nutrition'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Image.asset("assets/images/avacado_img.jpg"),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Avocado Dish',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text('Nutrition value',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('100g',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            )),
                        Text('457 cal',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FoodDescriptionGaugeStyle(
                  title: "Protein",
                  assetImage: "assets/food_description/protein.png",
                  gainedPortion: 78,
                  totalPortion: 90,
                  gaugeColor: CustomColors.greenColor,
                  gaugeWidth: 100,
                ),
                FoodDescriptionGaugeStyle(
                  title: "Fats",
                  assetImage: "assets/food_description/carbs.png",
                  gainedPortion: 45,
                  totalPortion: 70,
                  gaugeColor: CustomColors.orangeColor,
                  gaugeWidth: 100,
                ),
                FoodDescriptionGaugeStyle(
                  title: "Carbs",
                  assetImage: "assets/food_description/fats.png",
                  gainedPortion: 95,
                  totalPortion: 110,
                  gaugeColor: CustomColors.yellowColor,
                  gaugeWidth: 100,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      // Avocado image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          'https://cdn-icons-png.flaticon.com/512/415/415733.png', // Replace with your asset if needed
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Text content
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Health body comes with good nutrition',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Get good nutrition now!',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Arrow icon with background
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 18.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
