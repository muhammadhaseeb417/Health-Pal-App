import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_pal/features/Home/models/food_model.dart';

class FoodService {
  static final FoodService _instance = FoodService._internal();

  factory FoodService() => _instance;

  FoodService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Collection references
  CollectionReference get foodsCollection => _firestore.collection('foods');
  CollectionReference get userMealsCollection => _firestore.collection('user_meals');

  // Add a food item to the database
  Future<DocumentReference> addFood(FoodItem food) async {
    try {
      final docRef = await foodsCollection.add(food.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to add food item: ${e.toString()}');
    }
  }

  // Add multiple food items to the database
  Future<List<DocumentReference>> addFoods(List<FoodItem> foods) async {
    try {
      final batch = _firestore.batch();
      final refs = <DocumentReference>[];

      for (final food in foods) {
        final docRef = foodsCollection.doc();
        batch.set(docRef, food.toMap());
        refs.add(docRef);
      }

      await batch.commit();
      return refs;
    } catch (e) {
      throw Exception('Failed to add food items: ${e.toString()}');
    }
  }

  // Cache for all foods
  List<FoodItem>? _allFoodsCache;
  DateTime? _lastAllFoodsLoadTime;
  
  // Get all food items with caching
  Future<List<FoodItem>> getAllFoods() async {
    try {
      // Return cached foods if available and not expired
      final now = DateTime.now();
      if (_allFoodsCache != null && 
          _lastAllFoodsLoadTime != null && 
          now.difference(_lastAllFoodsLoadTime!).inMilliseconds < _cacheExpirationTime) {
        return List.from(_allFoodsCache!); // Return a copy to avoid modifying cache
      }
      
      final snapshot = await foodsCollection.get();
      final foods = snapshot.docs
          .map((doc) => FoodItem.fromDocument(doc))
          .toList();
      
      // Update cache
      _allFoodsCache = List.from(foods);
      _lastAllFoodsLoadTime = now;
      
      return foods;
    } catch (e) {
      throw Exception('Failed to get food items: ${e.toString()}');
    }
  }

  // Cache for foods by category
  Map<String, List<FoodItem>> _foodsByCategoryCache = {};
  Map<String, DateTime> _lastCategoryLoadTime = {};
  
  // Get food items by category with caching
  Future<List<FoodItem>> getFoodsByCategory(String category) async {
    try {
      // Return cached category foods if available and not expired
      final now = DateTime.now();
      if (_foodsByCategoryCache.containsKey(category) && 
          _lastCategoryLoadTime.containsKey(category) && 
          now.difference(_lastCategoryLoadTime[category]!).inMilliseconds < _cacheExpirationTime) {
        return List.from(_foodsByCategoryCache[category]!); // Return a copy
      }
      
      // If all foods are cached, filter from cache instead of querying
      if (_allFoodsCache != null && 
          _lastAllFoodsLoadTime != null && 
          now.difference(_lastAllFoodsLoadTime!).inMilliseconds < _cacheExpirationTime) {
        final categoryFoods = _allFoodsCache!
            .where((food) => food.category == category)
            .toList();
            
        // Update category cache
        _foodsByCategoryCache[category] = List.from(categoryFoods);
        _lastCategoryLoadTime[category] = now;
        
        return categoryFoods;
      }
      
      // If not cached, query from Firestore
      final snapshot = await foodsCollection
          .where('category', isEqualTo: category)
          .get();
      final foods = snapshot.docs
          .map((doc) => FoodItem.fromDocument(doc))
          .toList();
      
      // Update cache
      _foodsByCategoryCache[category] = List.from(foods);
      _lastCategoryLoadTime[category] = now;
      
      return foods;
    } catch (e) {
      throw Exception('Failed to get food items by category: ${e.toString()}');
    }
  }

  // Get a food item by ID
  Future<FoodItem?> getFoodById(String foodId) async {
    try {
      final doc = await foodsCollection.doc(foodId).get();
      if (!doc.exists) {
        return null;
      }
      return FoodItem.fromDocument(doc);
    } catch (e) {
      throw Exception('Failed to get food item: ${e.toString()}');
    }
  }

  // Add a meal for the current user
  Future<DocumentReference> addMeal(UserMeal meal) async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }

      // Create a meal with the current user ID
      final userMeal = UserMeal(
        id: meal.id,
        userId: currentUserId!,
        foodId: meal.foodId,
        mealType: meal.mealType,
        date: meal.date,
        quantity: meal.quantity,
        foodItem: meal.foodItem,
      );

      final docRef = await userMealsCollection.add(userMeal.toMap());
      return docRef;
    } catch (e) {
      throw Exception('Failed to add meal: ${e.toString()}');
    }
  }

  // Get all meals for the current user
  Future<List<UserMeal>> getUserMeals() async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }

      final snapshot = await userMealsCollection
          .where('userId', isEqualTo: currentUserId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => UserMeal.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user meals: ${e.toString()}');
    }
  }

  // Get user meals for a specific date
  Future<List<UserMeal>> getUserMealsForDate(DateTime date) async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }

      // Create start and end of the selected day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await userMealsCollection
          .where('userId', isEqualTo: currentUserId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs
          .map((doc) => UserMeal.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user meals for date: ${e.toString()}');
    }
  }

  // Get user meals by meal type for a specific date
  Future<List<UserMeal>> getUserMealsByTypeForDate(
      String mealType, DateTime date) async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }

      // Create start and end of the selected day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await userMealsCollection
          .where('userId', isEqualTo: currentUserId)
          .where('mealType', isEqualTo: mealType)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      return snapshot.docs
          .map((doc) => UserMeal.fromDocument(doc))
          .toList();
    } catch (e) {
      throw Exception(
          'Failed to get user meals by type for date: ${e.toString()}');
    }
  }

  // Calculate daily nutrition from meals
  Future<DailyNutrition> getDailyNutrition(DateTime date) async {
    try {
      final meals = await getUserMealsForDate(date);
      return DailyNutrition.fromMeals(date, meals);
    } catch (e) {
      throw Exception('Failed to calculate daily nutrition: ${e.toString()}');
    }
  }

  // Delete a user meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await userMealsCollection.doc(mealId).delete();
    } catch (e) {
      throw Exception('Failed to delete meal: ${e.toString()}');
    }
  }

  // Initialize the database with predefined food items
  Future<void> initializeFoodDatabase() async {
    try {
      // Check if foods collection is empty
      final snapshot = await foodsCollection.limit(1).get();
      if (snapshot.docs.isNotEmpty) {
        // Foods already exist, no need to initialize
        return;
      }

      // Add predefined foods
      await addFoods(_predefinedFoods);
    } catch (e) {
      throw Exception('Failed to initialize food database: ${e.toString()}');
    }
  }
  
  // Toggle favorite status for a food item
  Future<void> toggleFavorite(String foodId) async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }
      
      // Reference to the user favorites collection
      final userFavoritesRef = _firestore.collection('user_favorites')
          .doc(currentUserId)
          .collection('foods');
      
      // Check if this food is already a favorite using the cached method
      final isFavorite = await isFoodFavorite(foodId);
      
      if (isFavorite) {
        // If already a favorite, remove it
        await userFavoritesRef.doc(foodId).delete();
      } else {
        // If not a favorite, add it
        await userFavoritesRef.doc(foodId).set({
          'foodId': foodId,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
      
      // Invalidate cache after changing favorite status
      _favoriteFoodIds = null;
      _lastFavoriteCheckTime = null;
    } catch (e) {
      throw Exception('Failed to toggle favorite status: ${e.toString()}');
    }
  }
  

  
  // Cache of favorite food IDs for the current user
  Set<String>? _favoriteFoodIds;
  DateTime? _lastFavoriteCheckTime;
  
  // Cache expiration time in milliseconds (5 minutes)
  static const int _cacheExpirationTime = 300000; // 5 minutes
  
  // Get all favorite food IDs for the current user
  Future<Set<String>> _getFavoriteFoodIds() async {
    try {
      // Return cached ids if available and not expired
      final now = DateTime.now();
      if (_favoriteFoodIds != null && 
          _lastFavoriteCheckTime != null && 
          now.difference(_lastFavoriteCheckTime!).inMilliseconds < _cacheExpirationTime) {
        return _favoriteFoodIds!;
      }
      
      if (currentUserId == null) {
        return {};
      }
      
      // Get the user's favorite food IDs
      final favoritesSnapshot = await _firestore.collection('user_favorites')
          .doc(currentUserId)
          .collection('foods')
          .get();
      
      // Update cache
      _favoriteFoodIds = favoritesSnapshot.docs.map((doc) => doc.id).toSet();
      _lastFavoriteCheckTime = now;
      
      return _favoriteFoodIds!;
    } catch (e) {
      // If there's an error, return empty set but don't update cache
      return {};
    }
  }
  
  // Check if a food is favorited by the user (using cache)
  Future<bool> isFoodFavorite(String foodId) async {
    try {
      if (currentUserId == null) {
        return false;
      }
      
      final favoriteIds = await _getFavoriteFoodIds();
      return favoriteIds.contains(foodId);
    } catch (e) {
      return false;
    }
  }
  
  // Get all favorite foods for the current user
  Future<List<FoodItem>> getFavoriteFoods() async {
    try {
      if (currentUserId == null) {
        throw Exception('No current user');
      }
      
      // Get favorite IDs using the cached method
      final favoriteIds = await _getFavoriteFoodIds();
      
      if (favoriteIds.isEmpty) {
        return [];
      }
      
      // Convert set to list for batch processing
      final foodIds = favoriteIds.toList();
      
      // Fetch the actual food items
      final foodsList = <FoodItem>[];
      
      // Fetch foods in batches (Firestore has a limit on 'in' queries)
      for (int i = 0; i < foodIds.length; i += 10) {
        final end = (i + 10 < foodIds.length) ? i + 10 : foodIds.length;
        final batch = foodIds.sublist(i, end);
        
        final snapshot = await foodsCollection
            .where(FieldPath.documentId, whereIn: batch)
            .get();
            
        foodsList.addAll(snapshot.docs
            .map((doc) => FoodItem.fromDocument(doc).copyWith(isFavorite: true)));
      }
      
      return foodsList;
    } catch (e) {
      throw Exception('Failed to get favorite foods: ${e.toString()}');
    }
  }
  
  // Search foods by name
  Future<List<FoodItem>> searchFoods(String query) async {
    try {
      if (query.isEmpty) {
        return getAllFoods();
      }
      
      // Convert query to lowercase for case-insensitive search
      final lowerQuery = query.toLowerCase();
      
      // Get all foods and filter locally (Firestore doesn't support partial text search natively)
      final allFoods = await getAllFoods();
      final matchingFoods = allFoods.where(
        (food) => food.name.toLowerCase().contains(lowerQuery)
      ).toList();
      
      // Get all favorite IDs in one batch
      final favoriteIds = await _getFavoriteFoodIds();
      
      // Update favorite status for all matching foods at once
      return matchingFoods.map((food) => 
        food.copyWith(isFavorite: favoriteIds.contains(food.id))
      ).toList();
    } catch (e) {
      throw Exception('Failed to search foods: ${e.toString()}');
    }
  }

  // Predefined list of food items
  static final List<FoodItem> _predefinedFoods = [
    // Breakfast items
    FoodItem(
      id: 'breakfast_1',
      name: 'Oatmeal with Berries',
      category: 'breakfast',
      calories: 250,
      proteins: 8.0,
      carbs: 45.0,
      fats: 5.0,
      imageUrl: 'assets/images/breakfast.png',
      description: 'Rolled oats cooked with almond milk and topped with mixed berries and a drizzle of honey.',
    ),
    FoodItem(
      id: 'breakfast_2',
      name: 'Avocado Toast',
      category: 'breakfast',
      calories: 320,
      proteins: 10.0,
      carbs: 30.0,
      fats: 18.0,
      imageUrl: 'assets/images/breakfast.png',
      description: 'Whole grain toast topped with mashed avocado, a poached egg, and red pepper flakes.',
    ),
    FoodItem(
      id: 'breakfast_3',
      name: 'Greek Yogurt Parfait',
      category: 'breakfast',
      calories: 280,
      proteins: 15.0,
      carbs: 35.0,
      fats: 8.0,
      imageUrl: 'assets/images/breakfast.png',
      description: 'Greek yogurt layered with granola, honey, and fresh fruit.',
    ),
    FoodItem(
      id: 'breakfast_4',
      name: 'Vegetable Omelette',
      category: 'breakfast',
      calories: 350,
      proteins: 22.0,
      carbs: 10.0,
      fats: 24.0,
      imageUrl: 'assets/images/breakfast.png',
      description: 'Three-egg omelette with spinach, bell peppers, onions, and a sprinkle of cheese.',
    ),
    FoodItem(
      id: 'breakfast_5',
      name: 'Smoothie Bowl',
      category: 'breakfast',
      calories: 380,
      proteins: 12.0,
      carbs: 65.0,
      fats: 9.0,
      imageUrl: 'assets/images/breakfast.png',
      description: 'Blended frozen bananas and berries topped with chia seeds, coconut flakes, and sliced fruits.',
    ),
    
    // Lunch items
    FoodItem(
      id: 'lunch_1',
      name: 'Grilled Chicken Salad',
      category: 'lunch',
      calories: 420,
      proteins: 35.0,
      carbs: 20.0,
      fats: 22.0,
      imageUrl: 'assets/images/lunch.png',
      description: 'Mixed greens topped with grilled chicken breast, cherry tomatoes, cucumber, and balsamic vinaigrette.',
    ),
    FoodItem(
      id: 'lunch_2',
      name: 'Quinoa Bowl',
      category: 'lunch',
      calories: 480,
      proteins: 18.0,
      carbs: 65.0,
      fats: 15.0,
      imageUrl: 'assets/images/lunch.png',
      description: 'Cooked quinoa with roasted vegetables, chickpeas, and tahini dressing.',
    ),
    FoodItem(
      id: 'lunch_3',
      name: 'Turkey Wrap',
      category: 'lunch',
      calories: 450,
      proteins: 28.0,
      carbs: 40.0,
      fats: 20.0,
      imageUrl: 'assets/images/lunch.png',
      description: 'Whole wheat wrap filled with sliced turkey, avocado, lettuce, tomato, and mustard.',
    ),
    FoodItem(
      id: 'lunch_4',
      name: 'Lentil Soup',
      category: 'lunch',
      calories: 320,
      proteins: 18.0,
      carbs: 45.0,
      fats: 6.0,
      imageUrl: 'assets/images/lunch.png',
      description: 'Hearty soup made with lentils, carrots, celery, onions, and spices.',
    ),
    FoodItem(
      id: 'lunch_5',
      name: 'Salmon Poke Bowl',
      category: 'lunch',
      calories: 520,
      proteins: 30.0,
      carbs: 55.0,
      fats: 22.0,
      imageUrl: 'assets/images/lunch.png',
      description: 'Brown rice topped with raw salmon, avocado, cucumber, edamame, and soy-ginger dressing.',
    ),
    
    // Dinner items
    FoodItem(
      id: 'dinner_1',
      name: 'Grilled Salmon',
      category: 'dinner',
      calories: 480,
      proteins: 40.0,
      carbs: 15.0,
      fats: 28.0,
      imageUrl: 'assets/images/dinner.jpg',
      description: 'Grilled salmon fillet served with roasted asparagus and quinoa.',
    ),
    FoodItem(
      id: 'dinner_2',
      name: 'Vegetable Stir-Fry',
      category: 'dinner',
      calories: 380,
      proteins: 15.0,
      carbs: 50.0,
      fats: 12.0,
      imageUrl: 'assets/images/dinner.jpg',
      description: 'Mixed vegetables stir-fried with tofu and served over brown rice with a light soy sauce.',
    ),
    FoodItem(
      id: 'dinner_3',
      name: 'Turkey Meatballs',
      category: 'dinner',
      calories: 450,
      proteins: 35.0,
      carbs: 30.0,
      fats: 20.0,
      imageUrl: 'assets/images/dinner.jpg',
      description: 'Lean turkey meatballs in tomato sauce served with whole wheat pasta and a side salad.',
    ),
    FoodItem(
      id: 'dinner_4',
      name: 'Stuffed Bell Peppers',
      category: 'dinner',
      calories: 410,
      proteins: 25.0,
      carbs: 40.0,
      fats: 15.0,
      imageUrl: 'assets/images/dinner.jpg',
      description: 'Bell peppers stuffed with a mixture of ground turkey, brown rice, black beans, and spices.',
    ),
    FoodItem(
      id: 'dinner_5',
      name: 'Baked Cod',
      category: 'dinner',
      calories: 350,
      proteins: 35.0,
      carbs: 20.0,
      fats: 10.0,
      imageUrl: 'assets/images/dinner.jpg',
      description: 'Baked cod fillet with lemon and herbs, served with steamed vegetables and sweet potato.',
    ),
    
    // Snack items
    FoodItem(
      id: 'snack_1',
      name: 'Apple with Almond Butter',
      category: 'snack',
      calories: 200,
      proteins: 5.0,
      carbs: 25.0,
      fats: 10.0,
      imageUrl: 'assets/images/snack.webp',
      description: 'Sliced apple served with a tablespoon of almond butter.',
    ),
    FoodItem(
      id: 'snack_2',
      name: 'Greek Yogurt with Honey',
      category: 'snack',
      calories: 180,
      proteins: 15.0,
      carbs: 20.0,
      fats: 2.0,
      imageUrl: 'assets/images/snack.webp',
      description: 'Plain Greek yogurt drizzled with honey and topped with a sprinkle of walnuts.',
    ),
    FoodItem(
      id: 'snack_3',
      name: 'Hummus with Vegetables',
      category: 'snack',
      calories: 160,
      proteins: 6.0,
      carbs: 15.0,
      fats: 9.0,
      imageUrl: 'assets/images/snack.webp',
      description: 'Homemade hummus served with carrot and cucumber sticks.',
    ),
    FoodItem(
      id: 'snack_4',
      name: 'Trail Mix',
      category: 'snack',
      calories: 220,
      proteins: 7.0,
      carbs: 18.0,
      fats: 14.0,
      imageUrl: 'assets/images/snack.webp',
      description: 'Mix of almonds, walnuts, dried cranberries, and dark chocolate chips.',
    ),
    FoodItem(
      id: 'snack_5',
      name: 'Protein Smoothie',
      category: 'snack',
      calories: 240,
      proteins: 20.0,
      carbs: 25.0,
      fats: 5.0,
      imageUrl: 'assets/images/snack.webp',
      description: 'Blend of protein powder, banana, berries, and almond milk.',
    ),
  ];
}
