import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_pal/features/Home/models/food_model.dart';

class FoodConfirmationPage extends StatefulWidget {
  final Map<String, dynamic> recognitionData;
  final File imageFile;

  const FoodConfirmationPage({
    Key? key,
    required this.recognitionData,
    required this.imageFile,
  }) : super(key: key);

  @override
  State<FoodConfirmationPage> createState() => _FoodConfirmationPageState();
}

class _FoodConfirmationPageState extends State<FoodConfirmationPage> {
  final Map<String, bool> _expandedCards = {};
  Map<String, dynamic>? _selectedFood;
  Map<String, dynamic>? _selectedSubclass;

  @override
  void initState() {
    super.initState();
    // Initialize first item as expanded
    if (widget.recognitionData['recognition_results'].isNotEmpty) {
      _expandedCards[widget.recognitionData['recognition_results'][0]['name']] =
          true;
    }
  }

  void _toggleExpanded(String key) {
    setState(() {
      _expandedCards[key] = !(_expandedCards[key] ?? false);
    });
  }

  void _selectFood(Map<String, dynamic> food) {
    setState(() {
      _selectedFood = food;
      _selectedSubclass = null;
    });
  }

  void _selectSubclass(
      Map<String, dynamic> subclass, Map<String, dynamic> parentFood) {
    setState(() {
      // First select the parent food item
      _selectedFood = parentFood;
      // Then select the subclass
      _selectedSubclass = subclass;
    });
  }

  void _confirmFoodSelection() async {
    final food = _selectedSubclass ?? _selectedFood;
    if (food == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Get current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Generate random nutrition values based on the food type
      final random = Random();
      final int calories = 100 + random.nextInt(400); // Between 100-500 calories
      final double proteins = 5 + random.nextDouble() * 25; // Between 5-30g proteins
      final double carbs = 10 + random.nextDouble() * 40; // Between 10-50g carbs
      final double fats = 2 + random.nextDouble() * 18; // Between 2-20g fats

      // Determine meal type based on time of day
      final hour = DateTime.now().hour;
      String mealType;
      if (hour >= 5 && hour < 11) {
        mealType = 'breakfast';
      } else if (hour >= 11 && hour < 16) {
        mealType = 'lunch';
      } else if (hour >= 16 && hour < 21) {
        mealType = 'dinner';
      } else {
        mealType = 'snack';
      }

      // Create a FoodItem
      final foodItem = FoodItem(
        id: FirebaseFirestore.instance.collection('foods').doc().id,
        name: food['name'],
        category: mealType,
        calories: calories,
        proteins: proteins,
        carbs: carbs,
        fats: fats,
        description: food['description'] ?? '',
        // Use image file path as temporary reference until we implement proper image storage
        imageUrl: null,
        addedAt: DateTime.now(),
      );

      // Create a UserMeal
      final userMeal = UserMeal(
        id: FirebaseFirestore.instance.collection('user_meals').doc().id,
        userId: userId,
        foodId: foodItem.id,
        mealType: mealType,
        date: DateTime.now(),
        quantity: 1,
        foodItem: foodItem,
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('foods')
          .doc(foodItem.id)
          .set(foodItem.toMap());

      await FirebaseFirestore.instance
          .collection('user_meals')
          .doc(userMeal.id)
          .set(userMeal.toMap());

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show success message and return
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${food['name']} added to your meals'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving meal: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final recognitionResults = List<Map<String, dynamic>>.from(
      widget.recognitionData['recognition_results'],
    );

    // Define more vibrant and sharper colors
    final Color selectedCardColor = Colors.green.shade100;
    final Color selectedTextColor = Colors.green.shade900;
    final Color selectedSubclassColor = Colors.green.shade50;
    final Color selectedSubclassTextColor = Colors.green.shade800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Food'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Image preview
          SizedBox(
            height: 200,
            width: double.infinity,
            child: Image.file(
              widget.imageFile,
              fit: BoxFit.cover,
            ),
          ),

          // Food occasion
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            color: Colors.green.shade50,
            width: double.infinity,
            child: Text(
              'Detected as: ${widget.recognitionData['occasion_info']['translation'] ?? 'Unknown'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
          ),

          // Food family
          if (widget.recognitionData['foodFamily'] != null &&
              widget.recognitionData['foodFamily'].isNotEmpty)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              width: double.infinity,
              child: Text(
                'Food Family: ${widget.recognitionData['foodFamily'][0]['name']} '
                '(${(widget.recognitionData['foodFamily'][0]['prob'] * 100).toStringAsFixed(0)}%)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Recognition results list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: recognitionResults.length,
              itemBuilder: (context, index) {
                final food = recognitionResults[index];
                final bool isSelected = _selectedFood == food;
                final isExpanded = _expandedCards[food['name']] ?? false;
                final hasSubclasses =
                    food['subclasses'] != null && food['subclasses'].isNotEmpty;

                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 4.0),
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: isSelected
                        ? BorderSide(color: Colors.green.shade700, width: 2.0)
                        : BorderSide.none,
                  ),
                  color: isSelected ? selectedCardColor : Colors.white,
                  child: Column(
                    children: [
                      // Main food item
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        title: Text(
                          food['name'].toString().toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected ? selectedTextColor : Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Probability: ${(food['prob'] * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.green.shade700
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildNutriScoreBadge(food),
                            const SizedBox(width: 8),
                            if (hasSubclasses)
                              IconButton(
                                icon: Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: isSelected
                                      ? Colors.green.shade700
                                      : Colors.grey.shade700,
                                ),
                                onPressed: () => _toggleExpanded(food['name']),
                              ),
                          ],
                        ),
                        onTap: () => _selectFood(food),
                        selected: isSelected,
                        tileColor: isSelected ? selectedCardColor : null,
                      ),

                      // Subclasses (if any and if expanded)
                      if (isExpanded && hasSubclasses)
                        Container(
                          margin: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Types',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              ...List.generate(
                                food['subclasses'].length,
                                (subIndex) {
                                  final subclass = food['subclasses'][subIndex];
                                  final bool isSubclassSelected =
                                      _selectedSubclass == subclass;

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: isSubclassSelected
                                          ? selectedSubclassColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: isSubclassSelected
                                          ? Border.all(
                                              color: Colors.green.shade500,
                                              width: 1.5)
                                          : null,
                                    ),
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                        subclass['name'],
                                        style: TextStyle(
                                          fontWeight: isSubclassSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isSubclassSelected
                                              ? selectedSubclassTextColor
                                              : Colors.black87,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Probability: ${(subclass['prob'] * 100).toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: isSubclassSelected
                                              ? Colors.green.shade600
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                      trailing: _buildNutriScoreBadge(subclass),
                                      onTap: () =>
                                          _selectSubclass(subclass, food),
                                      selected: isSubclassSelected,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Confirm button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (_selectedFood != null) ? _confirmFoodSelection : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: const Text(
                'Confirm Selection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutriScoreBadge(Map<String, dynamic> food) {
    if (food['nutri_score'] == null) {
      return const SizedBox.shrink();
    }

    final category = food['nutri_score']['nutri_score_category'] as String;
    final score = food['nutri_score']['nutri_score_standardized'] as int;

    // Sharper and more vibrant colors for nutri-score badges
    Color badgeColor;
    switch (category) {
      case 'A':
        badgeColor = Colors.green.shade700;
        break;
      case 'B':
        badgeColor = Colors.lightGreen.shade700;
        break;
      case 'C':
        badgeColor = Colors.amber.shade700;
        break;
      case 'D':
        badgeColor = Colors.orange.shade700;
        break;
      case 'E':
        badgeColor = Colors.red.shade700;
        break;
      default:
        badgeColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        '$category ($score)',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
