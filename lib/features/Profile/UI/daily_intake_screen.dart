// Create this file at lib/features/Profile/UI/daily_intake_screen.dart

import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:health_pal/features/Profile/models/nutrition_settings_model.dart';
import 'package:health_pal/utils/constants/colors.dart';

class DailyIntakeScreen extends StatefulWidget {
  const DailyIntakeScreen({super.key});

  @override
  State<DailyIntakeScreen> createState() => _DailyIntakeScreenState();
}

class _DailyIntakeScreenState extends State<DailyIntakeScreen> {
  final FirebaseDatabaseService _databaseService = FirebaseDatabaseService();
  
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _caloriesController;
  late TextEditingController _proteinsController;
  late TextEditingController _carbsController;
  late TextEditingController _fatsController;
  
  bool _isLoading = true;
  String _errorMessage = '';
  NutritionSettings _settings = NutritionSettings();
  
  @override
  void initState() {
    super.initState();
    _initControllers();
    _loadSettings();
  }
  
  void _initControllers() {
    _caloriesController = TextEditingController();
    _proteinsController = TextEditingController();
    _carbsController = TextEditingController();
    _fatsController = TextEditingController();
  }
  
  Future<void> _loadSettings() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final settings = await _databaseService.getNutritionSettings();
      
      setState(() {
        _settings = settings;
        _caloriesController.text = settings.dailyCalorieTarget.toString();
        _proteinsController.text = settings.proteinTarget.toString();
        _carbsController.text = settings.carbsTarget.toString();
        _fatsController.text = settings.fatsTarget.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load nutrition settings: ${e.toString()}';
      });
    }
  }
  
  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final settings = NutritionSettings(
        dailyCalorieTarget: int.parse(_caloriesController.text),
        proteinTarget: double.parse(_proteinsController.text),
        carbsTarget: double.parse(_carbsController.text),
        fatsTarget: double.parse(_fatsController.text),
      );
      
      await _databaseService.updateNutritionSettings(settings);
      
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nutrition settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to save nutrition settings: ${e.toString()}';
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save settings: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinsController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Nutrition Targets'),
        backgroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Daily Calorie Target'),
                        _buildTextField(
                          controller: _caloriesController,
                          label: 'Calories',
                          hint: '2500',
                          icon: Icons.local_fire_department,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter calorie target';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildSectionHeader('Macronutrient Targets (grams)'),
                        _buildTextField(
                          controller: _proteinsController,
                          label: 'Protein',
                          hint: '90',
                          icon: Icons.fitness_center,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter protein target';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _carbsController,
                          label: 'Carbohydrates',
                          hint: '110',
                          icon: Icons.grain,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter carbs target';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _fatsController,
                          label: 'Fats',
                          hint: '70',
                          icon: Icons.opacity,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter fats target';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColors.greenColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Save Settings',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CustomColors.greenColor,
        ),
      ),
    );
  }
  
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: CustomColors.greenColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CustomColors.greenColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}