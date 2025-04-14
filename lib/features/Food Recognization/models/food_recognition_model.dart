// Model class for food recognition response
class FoodRecognitionResponse {
  final List<FoodFamily> foodFamily;
  final List<FoodType> foodType;
  final int imageId;
  final Map<String, String> modelVersions;
  final String occasion;
  final OccasionInfo occasionInfo;
  final List<RecognitionResult> recognitionResults;

  FoodRecognitionResponse({
    required this.foodFamily,
    required this.foodType,
    required this.imageId,
    required this.modelVersions,
    required this.occasion,
    required this.occasionInfo,
    required this.recognitionResults,
  });

  factory FoodRecognitionResponse.fromJson(Map<String, dynamic> json) {
    return FoodRecognitionResponse(
      foodFamily: (json['foodFamily'] as List)
          .map((x) => FoodFamily.fromJson(x))
          .toList(),
      foodType:
          (json['foodType'] as List).map((x) => FoodType.fromJson(x)).toList(),
      imageId: json['imageId'],
      modelVersions: Map<String, String>.from(json['model_versions']),
      occasion: json['occasion'],
      occasionInfo: OccasionInfo.fromJson(json['occasion_info']),
      recognitionResults: (json['recognition_results'] as List)
          .map((x) => RecognitionResult.fromJson(x))
          .toList(),
    );
  }
}

class FoodFamily {
  final int id;
  final String name;
  final double prob;

  FoodFamily({
    required this.id,
    required this.name,
    required this.prob,
  });

  factory FoodFamily.fromJson(Map<String, dynamic> json) {
    return FoodFamily(
      id: json['id'],
      name: json['name'],
      prob: json['prob'].toDouble(),
    );
  }
}

class FoodType {
  final int id;
  final String name;

  FoodType({
    required this.id,
    required this.name,
  });

  factory FoodType.fromJson(Map<String, dynamic> json) {
    return FoodType(
      id: json['id'],
      name: json['name'],
    );
  }
}

class OccasionInfo {
  final dynamic id;
  final String translation;

  OccasionInfo({
    required this.id,
    required this.translation,
  });

  factory OccasionInfo.fromJson(Map<String, dynamic> json) {
    return OccasionInfo(
      id: json['id'],
      translation: json['translation'],
    );
  }
}

class RecognitionResult {
  final bool hasNutriScore;
  final int id;
  final String name;
  final NutriScore? nutriScore;
  final double prob;
  final List<Subclass> subclasses;

  RecognitionResult({
    required this.hasNutriScore,
    required this.id,
    required this.name,
    this.nutriScore,
    required this.prob,
    required this.subclasses,
  });

  factory RecognitionResult.fromJson(Map<String, dynamic> json) {
    return RecognitionResult(
      hasNutriScore: json['hasNutriScore'],
      id: json['id'],
      name: json['name'],
      nutriScore: json['nutri_score'] != null
          ? NutriScore.fromJson(json['nutri_score'])
          : null,
      prob: json['prob'].toDouble(),
      subclasses: json['subclasses'] != null
          ? (json['subclasses'] as List)
              .map((x) => Subclass.fromJson(x))
              .toList()
          : [],
    );
  }
}

class NutriScore {
  final String nutriScoreCategory;
  final int nutriScoreStandardized;

  NutriScore({
    required this.nutriScoreCategory,
    required this.nutriScoreStandardized,
  });

  factory NutriScore.fromJson(Map<String, dynamic> json) {
    return NutriScore(
      nutriScoreCategory: json['nutri_score_category'],
      nutriScoreStandardized: json['nutri_score_standardized'],
    );
  }
}

class Subclass {
  final bool hasNutriScore;
  final int id;
  final String name;
  final NutriScore? nutriScore;
  final double prob;

  Subclass({
    required this.hasNutriScore,
    required this.id,
    required this.name,
    this.nutriScore,
    required this.prob,
  });

  factory Subclass.fromJson(Map<String, dynamic> json) {
    return Subclass(
      hasNutriScore: json['hasNutriScore'],
      id: json['id'],
      name: json['name'],
      nutriScore: json['nutri_score'] != null
          ? NutriScore.fromJson(json['nutri_score'])
          : null,
      prob: json['prob'].toDouble(),
    );
  }
}
