import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:health_pal/features/Home/UI/food_selection_screen.dart';
import 'package:health_pal/features/Home/models/food_model.dart';
import 'package:health_pal/features/Home/services/food_service.dart';
import 'package:health_pal/features/Home/widgets/calorie_gauge_widget.dart';
import 'package:health_pal/features/Home/widgets/custom_header_app_bar.dart';
import 'package:health_pal/features/Home/widgets/nutrition_graph_widget.dart';
// Removed unused import
import 'package:health_pal/utils/constants/colors.dart';

import '../widgets/add_food_widget_home.dart';

class HomeScreentwo extends StatefulWidget {
  const HomeScreentwo({super.key});

  @override
  State<HomeScreentwo> createState() => _HomeScreentwoState();
}

class _HomeScreentwoState extends State<HomeScreentwo> {
  final FoodService _foodService = FoodService();
  final FirebaseDatabaseService _databaseService = FirebaseDatabaseService();
  DateTime _selectedDate = DateTime.now();
  DailyNutrition? _dailyNutrition;
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Nutrition targets from user settings
  int _calorieTarget = 2500; // Default values
  double _proteinTarget = 90.0;
  double _carbsTarget = 110.0;
  double _fatsTarget = 70.0;
  
  // Food items for the meal types
  final List<Map<String, String>> foodItems = [
    {
      'title': 'Add Breakfast',
      'subTitle': 'Recommended 450-650 cal',
      'imgPath': 'assets/images/breakfast.png',
      'type': 'breakfast',
    },
    {
      'title': 'Add Snack',
      'subTitle': 'Recommended 150-250 cal',
      'imgPath': 'assets/images/snack.webp',
      'type': 'snack',
    },
    {
      'title': 'Add Lunch',
      'subTitle': 'Recommended 450-650 cal',
      'imgPath': 'assets/images/lunch.png',
      'type': 'lunch',
    },
    {
      'title': 'Add Dinner',
      'subTitle': 'Recommended 450-650 cal',
      'imgPath': 'assets/images/dinner.jpg',
      'type': 'dinner',
    },
  ];
  
  @override
  void initState() {
    super.initState();
    _initializeFoodData();
    _loadDailyNutrition();
    _loadNutritionSettings();
  }
  
  // Load user's nutrition settings from Firebase
  Future<void> _loadNutritionSettings() async {
    try {
      final settings = await _databaseService.getNutritionSettings();
      
      setState(() {
        _calorieTarget = settings.dailyCalorieTarget;
        _proteinTarget = settings.proteinTarget;
        _carbsTarget = settings.carbsTarget;
        _fatsTarget = settings.fatsTarget;
      });
    } catch (e) {
      print('Failed to load nutrition settings: $e');
      // Continue with default values
    }
  }
  
  Future<void> _initializeFoodData() async {
    try {
      await _foodService.initializeFoodDatabase();
    } catch (e) {
      print('Error initializing food database: $e');
    }
  }
  
  Future<void> _loadDailyNutrition() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final dailyNutrition = await _foodService.getDailyNutrition(_selectedDate);
      
      setState(() {
        _dailyNutrition = dailyNutrition;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load nutrition data: $e';
      });
    }
  }
  
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _loadDailyNutrition();
  }
  
  Future<void> _navigateToFoodSelection(String title, String type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoodSelectionScreen(
          mealType: title,
          selectedDate: _selectedDate,
        ),
      ),
    );
    
    if (result == true) {
      // Reload nutrition data if a meal was added
      _loadDailyNutrition();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total calories for the day
    final totalCalories = _dailyNutrition?.totalCalories ?? 0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : SingleChildScrollView(
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
                            // Use the actual calorie count for the gauge
                            Center(
                              child: CalorieGaugeWidget(
                                calories: totalCalories,
                                maxCalories: _calorieTarget, // Using dynamic target from user settings
                                proteins: _dailyNutrition?.totalProteins ?? 0,
                                carbs: _dailyNutrition?.totalCarbs ?? 0,
                                fats: _dailyNutrition?.totalFats ?? 0,
                              ),
                            ),
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
                                'Today Calorie: $totalCalories',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.orangeColor),
                              ),
                              const SizedBox(height: 40),
                              // Pass the nutrition data to the graph with dynamic targets
                              NutritionGraph(
                                proteins: _dailyNutrition?.totalProteins ?? 0,
                                carbs: _dailyNutrition?.totalCarbs ?? 0,
                                fats: _dailyNutrition?.totalFats ?? 0,
                                proteinTarget: _proteinTarget,
                                carbsTarget: _carbsTarget,
                                fatsTarget: _fatsTarget,
                              ),
                              const SizedBox(height: 40),
                              _buildDateSelector(),
                              const SizedBox(height: 40),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: foodItems.length,
                                itemBuilder: (context, index) {
                                  final item = foodItems[index];
                                  final type = item['type']!;
                                  final meals = _dailyNutrition?.meals[type] ?? [];
                                  
                                  return Column(
                                    children: [
                                      AddFoodWidgetHome(
                                        title: item['title']!,
                                        subTitle: item['subTitle']!,
                                        imgPath: item['imgPath']!,
                                        onTap: () => _navigateToFoodSelection(
                                          item['title']!,
                                          type,
                                        ),
                                        meals: meals,
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

  Widget _buildDateSelector() {
    // Generate 15 days before and after the current date
    final dates = List.generate(
      31,
      (index) => DateTime.now().subtract(Duration(days: 15 - index)),
    );
    
    // Find the index of the selected date
    final selectedIndex = dates.indexWhere(
      (date) =>
          date.year == _selectedDate.year &&
          date.month == _selectedDate.month &&
          date.day == _selectedDate.day,
    );
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.subtract(const Duration(days: 1));
            });
            _loadDailyNutrition();
          },
        ),
        Expanded(
          child: SizedBox(
            height: 60,
            child: ListView.builder(
              itemCount: dates.length,
              scrollDirection: Axis.horizontal,
              controller: ScrollController(initialScrollOffset: (selectedIndex - 2) * 65.0),
              itemBuilder: (context, index) {
                final date = dates[index];
                final isSelected = date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;
                
                // Get day of week (e.g., Mon, Tue)
                final dayName = DateFormat('E').format(date);
                
                return InkWell(
                  onTap: () => _selectDate(date),
                  child: Container(
                    width: 55,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: isSelected ? CustomColors.greenColor.withOpacity(0.2) : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 14,
                            color: isSelected ? CustomColors.greenColor : Colors.black,
                          ),
                        ),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 16,
                            color: isSelected ? CustomColors.greenColor : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            setState(() {
              _selectedDate = _selectedDate.add(const Duration(days: 1));
            });
            _loadDailyNutrition();
          },
        ),
      ],
    );
  }
}
