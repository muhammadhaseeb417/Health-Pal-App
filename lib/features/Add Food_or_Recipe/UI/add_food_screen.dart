import 'package:flutter/material.dart';
import 'package:health_pal/utils/constants/colors.dart';

import '../../Home/widgets/linear_gauge_widget_details.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  int selectedIndex = 0;
  int selectedDateIndex = 2;

  final List<String> labels = ["Recipes", "Ingredients", "Products"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Daily Nutrition'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            toggleDateWidget(),
            const SizedBox(height: 30),
            toggleButtonsWidget(),
            const SizedBox(height: 20),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1.15, // Fixed height
              child: ListView.builder(
                physics:
                    const NeverScrollableScrollPhysics(), // Disable internal scrolling
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the food description page
                      Navigator.pushNamed(context, "/food_description_page");
                    },
                    child: recipeCardWidget(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding recipeCardWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        height: 170,
        width: double.maxFinite,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: CustomColors.lightyellowColor, width: 2),
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[100],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //image
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(500),
                        color: Colors.black38,
                      ),
                      child: Center(
                          child: const Text(
                        'Image',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Salad with eggs',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          '🔥 294 kcal -100g',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(500),
                    border: Border.all(
                        color: CustomColors.lightyellowColor, width: 2),
                  ),
                  child: const Center(
                      child: Icon(Icons.more_horiz_rounded, size: 35)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinearGaugeWidgetDetails(
                  title: "Protein",
                  gainedPortion: 78,
                  totalPortion: 90,
                  gaugeColor: CustomColors.greenColor,
                ),
                LinearGaugeWidgetDetails(
                  title: "Fats",
                  gainedPortion: 45,
                  totalPortion: 70,
                  gaugeColor: CustomColors.orangeColor,
                ),
                LinearGaugeWidgetDetails(
                  title: "Carbs",
                  gainedPortion: 95,
                  totalPortion: 110,
                  gaugeColor: CustomColors.yellowColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox toggleDateWidget() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDateIndex = index;
              });
            },
            child: Container(
              width: 80,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: selectedDateIndex == index
                      ? Colors.orange
                      : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(8.0),
                color: selectedDateIndex == index
                    ? CustomColors.orangeColor
                    : Colors.black12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Aug',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: selectedDateIndex == index
                            ? Colors.white
                            : Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    index.toString(),
                    style: TextStyle(
                        fontSize: 24,
                        color: selectedDateIndex == index
                            ? Colors.white
                            : Colors.black38,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container toggleButtonsWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(labels.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color:
                    selectedIndex == index ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: selectedIndex == index
                    ? [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ]
                    : [],
              ),
              child: Text(
                labels[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
