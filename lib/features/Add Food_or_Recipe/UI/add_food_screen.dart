import 'package:flutter/material.dart';
import 'package:health_pal/features/Home/models/food_model.dart';
import 'package:health_pal/features/Home/services/food_service.dart';
import 'package:health_pal/utils/constants/colors.dart';
import 'package:intl/intl.dart';

import '../../Home/widgets/linear_gauge_widget_details.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  int selectedIndex = 0;
  int selectedDateIndex = 2;
  bool _isLoading = true;
  String _errorMessage = '';
  DateTime _selectedDate = DateTime.now();
  List<FoodItem> _foods = [];
  final FoodService _foodService = FoodService();
  
  // Generate dates for the calendar
  late final List<DateTime> _dates;

  final List<String> labels = ["All", "Breakfast", "Lunch", "Dinner", "Snack"];
  final List<String> categories = ["all", "breakfast", "lunch", "dinner", "snack"];

  @override
  void initState() {
    super.initState();
    // Generate 10 dates starting from 5 days ago
    _dates = List.generate(
      10,
      (index) => DateTime.now().subtract(Duration(days: 5 - index)),
    );
    _selectedDate = _dates[selectedDateIndex];
    _loadFoods();
  }
  
  Future<void> _loadFoods() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      // Initialize food database if needed
      await _foodService.initializeFoodDatabase();
      
      // Get all foods or filter by category
      List<FoodItem> foods;
      String category = categories[selectedIndex];
      
      if (category == "all") {
        foods = await _foodService.getAllFoods();
      } else {
        foods = await _foodService.getFoodsByCategory(category);
      }
      
      setState(() {
        _foods = foods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load foods: ${e.toString()}';
      });
    }
  }
  
  Future<void> _addFoodToMeal(FoodItem food) async {
    try {
      // Generate a unique ID for the meal
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Determine meal type based on time of day or selection
      String mealType = selectedIndex == 0 
          ? _getMealTypeBasedOnTime() 
          : categories[selectedIndex];
      
      // Create a UserMeal object
      final meal = UserMeal(
        id: id,
        userId: _foodService.currentUserId ?? '',
        foodId: food.id,
        mealType: mealType,
        date: _selectedDate,
        quantity: 1,
        foodItem: food,
      );
      
      // Add the meal to the database
      await _foodService.addMeal(meal);
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${food.name} added to your daily intake'),
          backgroundColor: CustomColors.greenColor,
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add food: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // Determine meal type based on current time
  String _getMealTypeBasedOnTime() {
    final hour = DateTime.now().hour;
    
    if (hour < 11) {
      return 'breakfast';
    } else if (hour < 15) {
      return 'lunch';
    } else if (hour < 18) {
      return 'snack';
    } else {
      return 'dinner';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Add Daily Nutrition'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      toggleDateWidget(),
                      const SizedBox(height: 30),
                      toggleButtonsWidget(),
                      const SizedBox(height: 20),
                      _foods.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(30.0),
                                child: Text('No foods found for this category',
                                    style: TextStyle(fontSize: 16)),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _foods.length,
                              itemBuilder: (context, index) {
                                final food = _foods[index];
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to the food description page
                                    Navigator.pushNamed(
                                        context, "/food_description_page");
                                  },
                                  child: foodCardWidget(food),
                                );
                              },
                            ),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }

  Padding foodCardWidget(FoodItem food) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Stack(
        children: [
          Container(
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
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.asset(
                              food.imageUrl ?? 'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.restaurant, color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              food.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '🔥 ${food.calories} kcal - 100g',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => _addFoodToMeal(food),
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: CustomColors.greenColor,
                        ),
                        child: const Center(
                            child: Icon(Icons.add, size: 30, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LinearGaugeWidgetDetails(
                      title: "Protein",
                      gainedPortion: food.proteins,
                      totalPortion: 90,
                      gaugeColor: CustomColors.greenColor,
                      gaugeWidth: 70,
                    ),
                    LinearGaugeWidgetDetails(
                      title: "Fats",
                      gainedPortion: food.fats,
                      totalPortion: 70,
                      gaugeColor: CustomColors.orangeColor,
                      gaugeWidth: 70,
                    ),
                    LinearGaugeWidgetDetails(
                      title: "Carbs",
                      gainedPortion: food.carbs,
                      totalPortion: 110,
                      gaugeColor: CustomColors.yellowColor,
                      gaugeWidth: 70,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (food.isFavorite)
            Positioned(
              top: 0,
              right: 10,
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(Icons.favorite, color: Colors.white, size: 15),
              ),
            ),
        ],
      ),
    );
  }

  SizedBox toggleDateWidget() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        itemBuilder: (context, index) {
          final date = _dates[index];
          final month = DateFormat('MMM').format(date);
          final day = date.day.toString();
          
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDateIndex = index;
                _selectedDate = date;
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
                    month,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: selectedDateIndex == index
                            ? Colors.white
                            : Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    day,
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
                // Reload foods when changing category
                _loadFoods();
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