import 'package:flutter/material.dart';
import 'package:health_pal/features/Home/models/food_model.dart';
import 'package:health_pal/features/Home/services/food_service.dart';
import 'package:health_pal/utils/constants/colors.dart';

class FoodSelectionScreen extends StatefulWidget {
  final String mealType;
  final DateTime selectedDate;

  const FoodSelectionScreen({
    Key? key,
    required this.mealType,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _FoodSelectionScreenState createState() => _FoodSelectionScreenState();
}

class _FoodSelectionScreenState extends State<FoodSelectionScreen> {
  final FoodService _foodService = FoodService();
  List<FoodItem> _foods = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
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

      // Get foods by category
      final foods = await _foodService.getFoodsByCategory(
          widget.mealType.toLowerCase().split(' ').last);
      
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

      // Create a UserMeal object
      final meal = UserMeal(
        id: id,
        userId: _foodService.currentUserId ?? '',
        foodId: food.id,
        mealType: widget.mealType.toLowerCase().split(' ').last,
        date: widget.selectedDate,
        quantity: 1,
        foodItem: food,
      );

      // Add the meal to the database
      await _foodService.addMeal(meal);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${food.name} added to ${widget.mealType}'),
          backgroundColor: CustomColors.greenColor,
        ),
      );

      // Navigate back to the home screen
      Navigator.pop(context, true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select ${widget.mealType}'),
        backgroundColor: CustomColors.greenColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _foods.isEmpty
                  ? const Center(child: Text('No foods available'))
                  : ListView.builder(
                      itemCount: _foods.length,
                      itemBuilder: (context, index) {
                        final food = _foods[index];
                        return _buildFoodItem(food);
                      },
                    ),
    );
  }

  Widget _buildFoodItem(FoodItem food) {
    return InkWell(
      onTap: () => _addFoodToMeal(food),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Food image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(food.imageUrl ?? 'assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Food details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${food.calories} calories',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildNutrientItem('P', food.proteins),
                      const SizedBox(width: 8),
                      _buildNutrientItem('C', food.carbs),
                      const SizedBox(width: 8),
                      _buildNutrientItem('F', food.fats),
                    ],
                  ),
                ],
              ),
            ),
            // Add button
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: CustomColors.lightGreenColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientItem(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomColors.lightGreenColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label: ${value.toStringAsFixed(1)}g',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
