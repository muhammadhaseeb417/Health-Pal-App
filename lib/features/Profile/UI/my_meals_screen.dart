import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_pal/features/Home/models/food_model.dart';
import 'package:intl/intl.dart';

class MyMealsScreen extends StatefulWidget {
  const MyMealsScreen({Key? key}) : super(key: key);

  @override
  State<MyMealsScreen> createState() => _MyMealsScreenState();
}

class _MyMealsScreenState extends State<MyMealsScreen> {
  DateTime _selectedDate = DateTime.now();
  final DateFormat _dateFormat = DateFormat('EEEE, MMMM d, yyyy');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Meals",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Date selector
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                    });
                  },
                ),
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Text(
                    _dateFormat.format(_selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _selectedDate.isBefore(DateTime.now()) 
                    ? () {
                        setState(() {
                          _selectedDate = _selectedDate.add(const Duration(days: 1));
                        });
                      }
                    : null,
                  color: _selectedDate.isBefore(DateTime.now()) 
                    ? Colors.black 
                    : Colors.grey,
                ),
              ],
            ),
          ),
          
          // Meals list
          Expanded(
            child: StreamBuilder<List<UserMeal>>(
              stream: _getUserMealsForDate(_selectedDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading meals: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                
                final meals = snapshot.data ?? [];
                
                if (meals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.no_food,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No meals recorded for this day',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                // Group meals by type
                Map<String, List<UserMeal>> mealsByType = {
                  'breakfast': [],
                  'lunch': [],
                  'dinner': [],
                  'snack': [],
                };
                
                for (var meal in meals) {
                  String type = meal.mealType.toLowerCase();
                  if (mealsByType.containsKey(type)) {
                    mealsByType[type]!.add(meal);
                  }
                }
                
                // Calculate daily totals
                int totalCalories = 0;
                double totalProteins = 0;
                double totalCarbs = 0;
                double totalFats = 0;
                
                for (var meal in meals) {
                  if (meal.foodItem != null) {
                    totalCalories += meal.foodItem!.calories * meal.quantity;
                    totalProteins += meal.foodItem!.proteins * meal.quantity;
                    totalCarbs += meal.foodItem!.carbs * meal.quantity;
                    totalFats += meal.foodItem!.fats * meal.quantity;
                  }
                }
                
                return Column(
                  children: [
                    // Daily summary
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Daily Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNutrientSummary('Calories', totalCalories.toString(), Colors.red),
                              _buildNutrientSummary('Protein', '${totalProteins.toStringAsFixed(1)}g', Colors.blue),
                              _buildNutrientSummary('Carbs', '${totalCarbs.toStringAsFixed(1)}g', Colors.orange),
                              _buildNutrientSummary('Fats', '${totalFats.toStringAsFixed(1)}g', Colors.purple),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Meals by category
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          if (mealsByType['breakfast']!.isNotEmpty)
                            _buildMealTypeSection('Breakfast', mealsByType['breakfast']!, Colors.amber),
                          if (mealsByType['lunch']!.isNotEmpty)
                            _buildMealTypeSection('Lunch', mealsByType['lunch']!, Colors.orange),
                          if (mealsByType['dinner']!.isNotEmpty)
                            _buildMealTypeSection('Dinner', mealsByType['dinner']!, Colors.deepPurple),
                          if (mealsByType['snack']!.isNotEmpty)
                            _buildMealTypeSection('Snacks', mealsByType['snack']!, Colors.teal),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNutrientSummary(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMealTypeSection(String title, List<UserMeal> meals, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              children: [
                Container(
                  height: 24,
                  width: 4,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...meals.map((meal) => _buildMealCard(meal, color)),
        ],
      ),
    );
  }
  
  Widget _buildMealCard(UserMeal meal, Color color) {
    final foodItem = meal.foodItem;
    if (foodItem == null) {
      return const SizedBox.shrink();
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Food image or placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: foodItem.imageUrl != null && foodItem.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        foodItem.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.fastfood,
                            color: color.withOpacity(0.5),
                            size: 30,
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.fastfood,
                      color: color.withOpacity(0.5),
                      size: 30,
                    ),
            ),
            const SizedBox(width: 12),
            // Food details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (meal.quantity > 1)
                    Text(
                      '${meal.quantity} servings',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            // Calories
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${foodItem.calories * meal.quantity} kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'P: ${(foodItem.proteins * meal.quantity).toStringAsFixed(1)}g • '
                  'C: ${(foodItem.carbs * meal.quantity).toStringAsFixed(1)}g • '
                  'F: ${(foodItem.fats * meal.quantity).toStringAsFixed(1)}g',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Stream<List<UserMeal>> _getUserMealsForDate(DateTime date) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    
    // Start of the selected day
    final startOfDay = DateTime(date.year, date.month, date.day);
    // Start of the next day
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    return FirebaseFirestore.instance
        .collection('user_meals')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => UserMeal.fromDocument(doc))
              .toList();
        });
  }
}
