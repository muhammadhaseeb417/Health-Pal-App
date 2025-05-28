import 'package:flutter/material.dart';
import 'package:health_pal/features/Home/models/food_model.dart';
import 'package:health_pal/features/Home/services/food_service.dart';
import 'package:health_pal/utils/constants/colors.dart';
import '../../Home/widgets/linear_gauge_widget_details.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;
  String _errorMessage = '';
  DateTime _selectedDate = DateTime.now();
  List<FoodItem> _foods = [];
  final FoodService _foodService = FoodService();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> labels = ["All", "Breakfast", "Lunch", "Dinner", "Snack"];
  final List<String> categories = ["all", "breakfast", "lunch", "dinner", "snack"];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadFoods();
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      
      if (_isSearching && _searchController.text.isNotEmpty) {
        // If searching, use the search query
        foods = await _foodService.searchFoods(_searchController.text);
        if (category != "all") {
          // Filter search results by category if a specific category is selected
          foods = foods.where((food) => food.category == category).toList();
        }
      } else {
        // Normal category filtering
        if (category == "all") {
          foods = await _foodService.getAllFoods();
        } else {
          foods = await _foodService.getFoodsByCategory(category);
        }
      }
      
      // Update isFavorite status for all foods
      for (int i = 0; i < foods.length; i++) {
        final isFavorite = await _foodService.isFoodFavorite(foods[i].id);
        foods[i] = foods[i].copyWith(isFavorite: isFavorite);
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
        foodId: food.id ?? '',
        mealType: mealType,
        date: _selectedDate,
        quantity: 1,
        foodItem: food,
      );
      
      // Add the meal to the database
      await _foodService.addMeal(meal);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${food.name} added to your daily intake'),
            backgroundColor: CustomColors.greenColor,
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add food: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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

  // Toggle favorite status for a food item
  Future<void> _toggleFavorite(FoodItem food) async {
    try {
      await _foodService.toggleFavorite(food.id);
      
      // Refresh the food list to update the UI
      await _loadFoods();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(food.isFavorite ? '${food.name} removed from favorites' : '${food.name} added to favorites'),
            backgroundColor: CustomColors.greenColor,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorite status: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  
  // Build the food details popup that appears when a food item is tapped
  void _showFoodDetails(FoodItem food) {
    // Make sure we handle potential null values properly
    final String foodName = food.name ?? 'Unknown Food';
    final double calories = food.calories.toDouble() ?? 0;
    final double proteins = food.proteins ?? 0;
    final double carbs = food.carbs ?? 0;
    final double fats = food.fats ?? 0;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Food image
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: food.imageUrl != null
                  ? Image.asset(
                      food.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                    ),
              ),
            ),
            
            // Food name, calories, and favorite button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          foodName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          food.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: food.isFavorite ? Colors.red : Colors.grey,
                          size: 28,
                        ),
                        onPressed: () => _toggleFavorite(food),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$calories calories per 100g',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Nutrition info
                  const Text(
                    'Nutrition Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Nutrition bars
                  Row(
                    children: [
                      Expanded(
                        child: _buildNutrientBar(
                          'Proteins', 
                          proteins, 
                          90,
                          CustomColors.greenColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNutrientBar(
                          'Carbs', 
                          carbs, 
                          110,
                          CustomColors.yellowColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNutrientBar(
                          'Fats', 
                          fats, 
                          70,
                          CustomColors.orangeColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // Add to meal button
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _addFoodToMeal(food);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.greenColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Today\'s Meals',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Helper method to build nutrient progress bars
  Widget _buildNutrientBar(String label, double value, double target, Color color) {
    final percentage = (value / target).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Container(
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value.toInt()}g / ${target.toInt()}g',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      body: SafeArea(
        child: Column(
          children: [
            // Title and search section
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  if (!_isSearching)
                    Expanded(
                      child: Text(
                        'Choose your meal',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: CustomColors.greenColor,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search foods...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: const TextStyle(fontSize: 18),
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) => _loadFoods(),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _loadFoods();
                          }
                        },
                      ),
                    ),
                  IconButton(
                    icon: Icon(_isSearching ? Icons.close : Icons.search, size: 28),
                    onPressed: () {
                      setState(() {
                        if (_isSearching) {
                          _isSearching = false;
                          _searchController.clear();
                          _loadFoods(); // Reload without search query
                        } else {
                          _isSearching = true;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Category toggle buttons
            _buildToggleButtons(),
            const SizedBox(height: 16),
            
            // Food list section
            Expanded(
              child: _buildFoodList(),
            ),
          ],
        ),
      ),
    );
  }

  // Build the category toggle buttons
  Widget _buildToggleButtons() {
    return Container(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: List.generate(
            labels.length,
            (index) {
              final isSelected = selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  _loadFoods();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? CustomColors.greenColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Build the scrollable food list with proper loading states
  Widget _buildFoodList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadFoods,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_foods.isEmpty) {
      return const Center(
        child: Text(
          'No foods found for this category',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _foods.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final food = _foods[index];
        return GestureDetector(
          onTap: () => _showFoodDetails(food),
          child: _buildFoodCard(food),
        );
      },
    );
  }

  // Build the food card widget
  Widget _buildFoodCard(FoodItem food) {
    // Pre-extract nullable values to avoid lint issues
    final String name = food.name ?? 'Unknown Food';
    final double calories = food.calories.toDouble() ?? 0;
    final double proteins = food.proteins ?? 0;
    final double carbs = food.carbs ?? 0;
    final double fats = food.fats ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.lightyellowColor, width: 2),
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with food info and add button
          Row(
            children: [
              // Food image
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: food.imageUrl != null 
                    ? Image.asset(
                        food.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.restaurant, color: Colors.white),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, color: Colors.white),
                      ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Food details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🔥 $calories kcal - 100g',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action buttons row
              Row(
                children: [
                  // Favorite button
                  InkWell(
                    onTap: () => _toggleFavorite(food),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: food.isFavorite ? Colors.red.shade50 : Colors.grey.shade200,
                        border: Border.all(color: food.isFavorite ? Colors.red : Colors.grey.shade300),
                      ),
                      child: Icon(
                        food.isFavorite ? Icons.favorite : Icons.favorite_border, 
                        size: 24, 
                        color: food.isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 10),
                  
                  // Add button
                  InkWell(
                    onTap: () => _addFoodToMeal(food),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: CustomColors.greenColor,
                      ),
                      child: const Icon(
                        Icons.add, 
                        size: 28, 
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Nutrition info row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: LinearGaugeWidgetDetails(
                  title: "Protein",
                  gainedPortion: proteins,
                  totalPortion: 90,
                  gaugeColor: CustomColors.greenColor,
                  gaugeWidth: 60,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearGaugeWidgetDetails(
                  title: "Fats",
                  gainedPortion: fats,
                  totalPortion: 70,
                  gaugeColor: CustomColors.orangeColor,
                  gaugeWidth: 60,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearGaugeWidgetDetails(
                  title: "Carbs",
                  gainedPortion: carbs,
                  totalPortion: 110,
                  gaugeColor: CustomColors.yellowColor,
                  gaugeWidth: 60,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}