// Page for capturing or selecting a food image
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../Food Confirmation Page/UI/food_confirmation_page.dart';

class FoodImageCapturePage extends StatefulWidget {
  const FoodImageCapturePage({Key? key}) : super(key: key);

  @override
  State<FoodImageCapturePage> createState() => _FoodImageCapturePageState();
}

class _FoodImageCapturePageState extends State<FoodImageCapturePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _getImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<Map<String, dynamic>> _recognizeFoodWithAPI(File imageFile) async {
    final apiKey = dotenv.env['LOG_MEAL_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('LogMeal API key not found in environment variables');
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.logmeal.com/v2/image/recognition/complete/v1.0'),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $apiKey',
    });

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to recognize food: ${response.statusCode} - ${response.body}');
    }
  }

  Future<void> _recognizeFood() async {
    if (_selectedImage == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Use the actual API call instead of the mock
      final response = await _recognizeFoodWithAPI(_selectedImage!);

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => FoodConfirmationPage(
            recognitionData: response,
            imageFile: _selectedImage!,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Mock API call - replace with actual implementation
  Future<Map<String, dynamic>> _mockApiCall(File imageFile) async {
    // This is where you would implement your actual API call to LogMeal
    // For example:

    final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.logmeal.com/v2/image/recognition/complete/v1.0'));

    request.headers.addAll({
      'Authorization': 'Bearer YOUR_API_KEY',
    });

    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to recognize food');
    }

    // For now, we'll return the sample data you provided
//     return jsonDecode('''{
//     "foodFamily": [
//         {
//             "id": 10,
//             "name": "bread",
//             "prob": 0.7080078125
//         }
//     ],
//     "foodType": [
//         {
//             "id": 1,
//             "name": "food"
//         },
//         {
//             "id": 1,
//             "name": "food"
//         },
//         {
//             "id": 1,
//             "name": "food"
//         },
//         {
//             "id": 1,
//             "name": "food"
//         },
//         {
//             "id": 1,
//             "name": "food"
//         },
//         {
//             "id": 1,
//             "name": "food"
//         }
//     ],
//     "imageId": 1824381,
//     "model_versions": {
//         "drinks": "v1.0",
//         "foodType": "v1.0",
//         "foodgroups": "v1.0",
//         "foodrec": "v1.0",
//         "ingredients": "v1.0"
//     },
//     "occasion": "dinner",
//     "occasion_info": {
//         "id": null,
//         "translation": "dinner"
//     },
//     "recognition_results": [
//         {
//             "hasNutriScore": true,
//             "id": 168,
//             "name": "pizza",
//             "nutri_score": {
//                 "nutri_score_category": "A",
//                 "nutri_score_standardized": 73
//             },
//             "prob": 0.8161768913269043,
//             "subclasses": [
//                 {
//                     "hasNutriScore": true,
//                     "id": 2448,
//                     "name": "cheese pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "D",
//                         "nutri_score_standardized": 52
//                     },
//                     "prob": 0.8161768913269043
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2445,
//                     "name": "margherita pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 77
//                     },
//                     "prob": 0.8161768913269043
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2446,
//                     "name": "pepperoni pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 73
//                     },
//                     "prob": 0.8161768913269043
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2447,
//                     "name": "meat pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 81
//                     },
//                     "prob": 0.8161768913269043
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 1530,
//                     "name": "focaccia ai pomodori",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 84
//                     },
//                     "prob": 0.002864837646484375
//                 }
//             ]
//         },
//         {
//             "hasNutriScore": true,
//             "id": 1530,
//             "name": "focaccia ai pomodori",
//             "nutri_score": {
//                 "nutri_score_category": "A",
//                 "nutri_score_standardized": 84
//             },
//             "prob": 0.002634027972817421,
//             "subclasses": [
//                 {
//                     "hasNutriScore": true,
//                     "id": 168,
//                     "name": "pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 73
//                     },
//                     "prob": 0.8876953125
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2448,
//                     "name": "cheese pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "D",
//                         "nutri_score_standardized": 52
//                     },
//                     "prob": 0.002634027972817421
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2445,
//                     "name": "margherita pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 77
//                     },
//                     "prob": 0.002634027972817421
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2446,
//                     "name": "pepperoni pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 73
//                     },
//                     "prob": 0.002634027972817421
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2447,
//                     "name": "meat pizza",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 81
//                     },
//                     "prob": 0.002634027972817421
//                 }
//             ]
//         },
//         {
//             "hasNutriScore": true,
//             "id": 2263,
//             "name": "bread with cheese",
//             "nutri_score": {
//                 "nutri_score_category": "A",
//                 "nutri_score_standardized": 81
//             },
//             "prob": 0.0014844904653728008,
//             "subclasses": [
//                 {
//                     "hasNutriScore": true,
//                     "id": 2563,
//                     "name": "bread with fresh cheese",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 81
//                     },
//                     "prob": 0.0014844904653728008
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2564,
//                     "name": "bread with hard cheese",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 81
//                     },
//                     "prob": 0.0014844904653728008
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2565,
//                     "name": "bread with soft cheese",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 81
//                     },
//                     "prob": 0.0014844904653728008
//                 }
//             ]
//         },
//         {
//             "hasNutriScore": true,
//             "id": 1506,
//             "name": "roulade",
//             "nutri_score": {
//                 "nutri_score_category": "C",
//                 "nutri_score_standardized": 66
//             },
//             "prob": 0.0012626498937606812,
//             "subclasses": [
//                 {
//                     "hasNutriScore": true,
//                     "id": 2569,
//                     "name": "beef roulade",
//                     "nutri_score": {
//                         "nutri_score_category": "C",
//                         "nutri_score_standardized": 66
//                     },
//                     "prob": 0.0012626498937606812
//                 },
//                 {
//                     "hasNutriScore": true,
//                     "id": 2570,
//                     "name": "chicken roulade",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 81
//                     },
//                     "prob": 0.0012626498937606812
//                 }
//             ]
//         },
//         {
//             "hasNutriScore": true,
//             "id": 296,
//             "name": "pineapple with ham",
//             "nutri_score": {
//                 "nutri_score_category": "B",
//                 "nutri_score_standardized": 70
//             },
//             "prob": 0.001182857435196638,
//             "subclasses": []
//         },
//         {
//             "hasNutriScore": true,
//             "id": 2105,
//             "name": "bacon meat",
//             "nutri_score": {
//                 "nutri_score_category": "A",
//                 "nutri_score_standardized": 81
//             },
//             "prob": 0.0009136674925684929,
//             "subclasses": [
//                 {
//                     "hasNutriScore": true,
//                     "id": 390,
//                     "name": "grilled bacon",
//                     "nutri_score": {
//                         "nutri_score_category": "A",
//                         "nutri_score_standardized": 81
//                     },
//                     "prob": 0.0003306865692138672
//                 }
//             ]
//         }
//     ]
// }''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _selectedImage == null
                ? const Center(
                    child: Text('No image selected'),
                  )
                : Image.file(
                    _selectedImage!,
                    fit: BoxFit.contain,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _getImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take Photo'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _getImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from Gallery'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _selectedImage == null || _isLoading
                      ? null
                      : _recognizeFood,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Recognize Food'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
