import 'package:flutter/material.dart';
import 'package:health_pal/features/Home/models/food_model.dart';
import 'package:health_pal/features/Home/services/food_service.dart';
import 'package:health_pal/utils/constants/colors.dart';

class FavoritesFoodScreen extends StatefulWidget {
  const FavoritesFoodScreen({super.key});

  @override
  State<FavoritesFoodScreen> createState() => _FavoritesFoodScreenState();
}

class _FavoritesFoodScreenState extends State<FavoritesFoodScreen> {
  final FoodService _foodService = FoodService();
  bool _isLoading = true;
  String _errorMessage = '';
  List<FoodItem> _favoriteFoods = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteFoods();
  }

  Future<void> _loadFavoriteFoods() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final foods = await _foodService.getFavoriteFoods();

      setState(() {
        _favoriteFoods = foods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load favorite foods: ${e.toString()}';
      });
    }
  }

  Future<void> _removeFromFavorites(FoodItem food) async {
    try {
      await _foodService.toggleFavorite(food.id);
      
      // Refresh the list
      await _loadFavoriteFoods();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${food.name} removed from favorites'),
            backgroundColor: CustomColors.greenColor,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove from favorites: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addFoodToMeal(FoodItem food) async {
    try {
      // Generate a unique ID for the meal
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Determine meal type based on time of day
      String mealType = _getMealTypeBasedOnTime();
      
      // Create a UserMeal object
      final meal = UserMeal(
        id: id,
        userId: _foodService.currentUserId ?? '',
        foodId: food.id ?? '',
        mealType: mealType,
        date: DateTime.now(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Favorite Foods",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? _buildErrorWidget()
              : _favoriteFoods.isEmpty
                  ? _buildEmptyWidget()
                  : _buildFoodsList(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadFavoriteFoods,
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.greenColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No favorite foods yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add foods to your favorites to see them here',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/add_food');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.greenColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Browse Foods'),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodsList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _favoriteFoods.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final food = _favoriteFoods[index];
        return _buildFoodCard(food);
      },
    );
  }

  Widget _buildFoodCard(FoodItem food) {
    // Pre-extract nullable values to avoid lint issues
    final String name = food.name ?? 'Unknown Food';
    final double calories = food.calories.toDouble() ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.lightyellowColor, width: 1),
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[50],
      ),
      child: Row(
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
          
          const SizedBox(width: 16),
          
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '🔥 $calories kcal',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Action buttons
          Row(
            children: [
              // Remove from favorites button
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => _removeFromFavorites(food),
              ),
              
              // Add to meal button
              IconButton(
                icon:  Icon(Icons.add_circle, color: CustomColors.greenColor, size: 32),
                onPressed: () => _addFoodToMeal(food),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
