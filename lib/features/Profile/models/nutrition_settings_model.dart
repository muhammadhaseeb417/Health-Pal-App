// Add this to lib/features/Profile/models/nutrition_settings_model.dart

class NutritionSettings {
  final int dailyCalorieTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatsTarget;

  NutritionSettings({
    this.dailyCalorieTarget = 2500,
    this.proteinTarget = 90.0,
    this.carbsTarget = 110.0,
    this.fatsTarget = 70.0,
  });

  // Create from map for Firebase
  factory NutritionSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return NutritionSettings();
    }
    
    return NutritionSettings(
      dailyCalorieTarget: map['dailyCalorieTarget'] ?? 2500,
      proteinTarget: (map['proteinTarget'] ?? 90.0).toDouble(),
      carbsTarget: (map['carbsTarget'] ?? 110.0).toDouble(),
      fatsTarget: (map['fatsTarget'] ?? 70.0).toDouble(),
    );
  }

  // Convert to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'dailyCalorieTarget': dailyCalorieTarget,
      'proteinTarget': proteinTarget,
      'carbsTarget': carbsTarget,
      'fatsTarget': fatsTarget,
    };
  }

  // Create a copy with changes
  NutritionSettings copyWith({
    int? dailyCalorieTarget,
    double? proteinTarget,
    double? carbsTarget, 
    double? fatsTarget,
  }) {
    return NutritionSettings(
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatsTarget: fatsTarget ?? this.fatsTarget,
    );
  }
}