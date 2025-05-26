import 'package:cloud_firestore/cloud_firestore.dart';

class FoodItem {
  final String id;
  final String name;
  final String category; // breakfast, lunch, dinner, snack
  final int calories;
  final double proteins;
  final double carbs;
  final double fats;
  final String? imageUrl;
  final String? description;
  final DateTime? addedAt;
  final bool isFavorite;

  FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    this.imageUrl,
    this.description,
    this.addedAt,
    this.isFavorite = false,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'imageUrl': imageUrl,
      'description': description,
      'addedAt': addedAt != null ? Timestamp.fromDate(addedAt!) : null,
      'isFavorite': isFavorite,
    };
  }

  // Create FoodItem from Firestore document
  factory FoodItem.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FoodItem(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      calories: data['calories'] ?? 0,
      proteins: data['proteins'] ?? 0.0,
      carbs: data['carbs'] ?? 0.0,
      fats: data['fats'] ?? 0.0,
      imageUrl: data['imageUrl'],
      description: data['description'],
      addedAt: data['addedAt'] != null
          ? (data['addedAt'] as Timestamp).toDate()
          : null,
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  // Create a copy of FoodItem with changes
  FoodItem copyWith({
    String? id,
    String? name,
    String? category,
    int? calories,
    double? proteins,
    double? carbs,
    double? fats,
    String? imageUrl,
    String? description,
    DateTime? addedAt,
    bool? isFavorite,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      calories: calories ?? this.calories,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      addedAt: addedAt ?? this.addedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class UserMeal {
  final String id;
  final String userId;
  final String foodId;
  final String mealType; // breakfast, lunch, dinner, snack
  final DateTime date;
  final int quantity; // Number of servings
  final FoodItem? foodItem; // Denormalized data for easy access

  UserMeal({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.mealType,
    required this.date,
    this.quantity = 1,
    this.foodItem,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'foodId': foodId,
      'mealType': mealType,
      'date': Timestamp.fromDate(date),
      'quantity': quantity,
      'foodData': foodItem?.toMap(), // Store denormalized food data
    };
  }

  // Create UserMeal from Firestore document
  factory UserMeal.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Create a FoodItem from the denormalized data if available
    FoodItem? foodItem;
    if (data['foodData'] != null) {
      foodItem = FoodItem(
        id: data['foodId'],
        name: data['foodData']['name'] ?? '',
        category: data['foodData']['category'] ?? '',
        calories: data['foodData']['calories'] ?? 0,
        proteins: data['foodData']['proteins'] ?? 0.0,
        carbs: data['foodData']['carbs'] ?? 0.0,
        fats: data['foodData']['fats'] ?? 0.0,
        imageUrl: data['foodData']['imageUrl'],
        description: data['foodData']['description'],
        addedAt: data['foodData']['addedAt'] != null
            ? (data['foodData']['addedAt'] as Timestamp).toDate()
            : null,
        isFavorite: data['foodData']['isFavorite'] ?? false,
      );
    }

    return UserMeal(
      id: doc.id,
      userId: data['userId'] ?? '',
      foodId: data['foodId'] ?? '',
      mealType: data['mealType'] ?? '',
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      quantity: data['quantity'] ?? 1,
      foodItem: foodItem,
    );
  }
}

class DailyNutrition {
  final DateTime date;
  final int totalCalories;
  final double totalProteins;
  final double totalCarbs;
  final double totalFats;
  final Map<String, List<UserMeal>> meals;

  DailyNutrition({
    required this.date,
    this.totalCalories = 0,
    this.totalProteins = 0.0,
    this.totalCarbs = 0.0,
    this.totalFats = 0.0,
    required this.meals,
  });

  // Calculate total nutrition from meals
  factory DailyNutrition.fromMeals(DateTime date, List<UserMeal> meals) {
    // Group meals by type
    final mealsByType = <String, List<UserMeal>>{
      'breakfast': [],
      'lunch': [],
      'dinner': [],
      'snack': [],
    };

    int totalCalories = 0;
    double totalProteins = 0.0;
    double totalCarbs = 0.0;
    double totalFats = 0.0;

    for (final meal in meals) {
      if (meal.foodItem != null) {
        totalCalories += meal.foodItem!.calories * meal.quantity;
        totalProteins += meal.foodItem!.proteins * meal.quantity;
        totalCarbs += meal.foodItem!.carbs * meal.quantity;
        totalFats += meal.foodItem!.fats * meal.quantity;
      }

      if (mealsByType.containsKey(meal.mealType)) {
        mealsByType[meal.mealType]!.add(meal);
      }
    }

    return DailyNutrition(
      date: date,
      totalCalories: totalCalories,
      totalProteins: totalProteins,
      totalCarbs: totalCarbs,
      totalFats: totalFats,
      meals: mealsByType,
    );
  }
}
