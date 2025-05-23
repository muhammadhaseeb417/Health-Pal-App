enum WeightUnit { kg, lbs }

enum Goal { loseWeight, maintainWeight, gainWeight }

enum Gender { male, female, other }

class UserDetails {
  final int age;
  final double weight;
  final WeightUnit weightUnit;
  final Goal goal;
  final Gender gender;
  final double height; // Height in centimeters

  UserDetails({
    required this.age,
    required this.weight,
    required this.weightUnit,
    required this.goal,
    required this.gender,
    required this.height,
  });

  // Create UserDetails from Map for Firestore
  factory UserDetails.fromMap(Map<String, dynamic> map) {
    return UserDetails(
      age: map['age'] ?? 0,
      weight: (map['weight'] ?? 0.0).toDouble(),
      weightUnit: WeightUnit.values.firstWhere(
        (e) => e.toString() == 'WeightUnit.${map['weightUnit']}',
        orElse: () => WeightUnit.kg,
      ),
      goal: Goal.values.firstWhere(
        (e) => e.toString() == 'Goal.${map['goal']}',
        orElse: () => Goal.maintainWeight,
      ),
      gender: Gender.values.firstWhere(
        (e) => e.toString() == 'Gender.${map['gender']}',
        orElse: () => Gender.other,
      ),
      height: (map['height'] ?? 0.0).toDouble(),
    );
  }

  // Convert UserDetails to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'age': age,
      'weight': weight,
      'weightUnit': weightUnit.toString().split('.').last,
      'goal': goal.toString().split('.').last,
      'gender': gender.toString().split('.').last,
      'height': height,
    };
  }

  // Create a copy of UserDetails with updated fields
  UserDetails copyWith({
    int? age,
    double? weight,
    WeightUnit? weightUnit,
    Goal? goal,
    Gender? gender,
    double? height,
  }) {
    return UserDetails(
      age: age ?? this.age,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      goal: goal ?? this.goal,
      gender: gender ?? this.gender,
      height: height ?? this.height,
    );
  }
}
