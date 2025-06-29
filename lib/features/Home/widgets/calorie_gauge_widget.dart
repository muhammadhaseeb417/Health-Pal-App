import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:health_pal/features/Profile/models/nutrition_settings_model.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../utils/constants/colors.dart';
import 'linear_gauge_widget_details.dart';

class CalorieGaugeWidget extends StatefulWidget {
  final int calories;
  final int maxCalories;
  final double proteins;
  final double carbs;
  final double fats;

  const CalorieGaugeWidget({
    super.key,
    required this.calories,
    required this.maxCalories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  @override
  State<CalorieGaugeWidget> createState() => _CalorieGaugeWidgetState();
}

class _CalorieGaugeWidgetState extends State<CalorieGaugeWidget> {
  // Local variables to store the nutrition settings
  late int _maxCalories;
  late double _proteinTarget;
  late double _carbsTarget;
  late double _fatsTarget;
  
  @override
  void initState() {
    super.initState();
    // Initialize with the passed values
    _maxCalories = widget.maxCalories;
    _proteinTarget = 90.0; // Default values
    _carbsTarget = 110.0;
    _fatsTarget = 70.0;
    _loadNutritionSettings();
  }

  Future<void> _loadNutritionSettings() async {
    try {
      final FirebaseDatabaseService _databaseService = FirebaseDatabaseService();
      final settings = await _databaseService.getNutritionSettings();
      
      setState(() {
        // Update local variables with user settings
        _maxCalories = settings.dailyCalorieTarget;
        _proteinTarget = settings.proteinTarget;
        _carbsTarget = settings.carbsTarget;
        _fatsTarget = settings.fatsTarget;
      });
    } catch (e) {
      print('Failed to load nutrition settings: $e');
      // Continue with default values
    }
  }
  @override
  Widget build(BuildContext context) {
    final double currentCalories = widget.calories.toDouble();
    final double goalCalories = _maxCalories.toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 250,
          child: SfRadialGauge(
            axes: [
              RadialAxis(
                startAngle: 180,
                endAngle: 0,
                minimum: 0,
                maximum: goalCalories,
                showLabels: false,
                showTicks: false,
                axisLineStyle: AxisLineStyle(
                  thickness: 35,
                  cornerStyle: CornerStyle.bothCurve,
                  color: Colors.grey.shade300,
                ),
                pointers: [
                  RangePointer(
                    animationDuration: 15000,
                    animationType: AnimationType.ease,
                    enableAnimation: true,
                    value: currentCalories,
                    cornerStyle: CornerStyle.bothCurve,
                    width: 35,
                    color: CustomColors.orangeColor,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 45,
                        ),
                        const Text(
                          '🔥',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          "${currentCalories.toStringAsFixed(1)} Kcal",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "of $goalCalories kcal",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LinearGaugeWidgetDetails(
                              title: "Protein",
                              gainedPortion: widget.proteins,
                              totalPortion: _proteinTarget, // Using dynamic target
                              gaugeColor: CustomColors.greenColor,
                            ),
                            LinearGaugeWidgetDetails(
                              title: "Fats",
                              gainedPortion: widget.fats,
                              totalPortion: _fatsTarget, // Using dynamic target
                              gaugeColor: CustomColors.orangeColor,
                            ),
                            LinearGaugeWidgetDetails(
                              title: "Carbs",
                              gainedPortion: widget.carbs,
                              totalPortion: _carbsTarget, // Using dynamic target
                              gaugeColor: CustomColors.yellowColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

// class CalorieGaugeWidget extends StatelessWidget {
//   final double currentCalories = 1721;
//   final double goalCalories = 2213;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: 150,
//           child: SfRadialGauge(
//             axes: <RadialAxis>[
//               RadialAxis(
//                 minimum: 0,
//                 maximum: goalCalories,
//                 startAngle: 180,
//                 endAngle: 0,
//                 showLabels: false,
//                 showTicks: false,
//                 axisLineStyle: AxisLineStyle(
//                   thickness: 20,
//                   cornerStyle: CornerStyle.bothCurve,
//                   color: Colors.grey.shade300,
//                 ),
//                 pointers: <GaugePointer>[
//                   RangePointer(
//                     value: currentCalories,
//                     width: 20,
//                     cornerStyle: CornerStyle.bothCurve,
//                     color: Colors.orange,
//                   ),
//                 ],
//                 annotations: <GaugeAnnotation>[
//                   GaugeAnnotation(
//                     positionFactor: 0.1,
//                     angle: 90,
//                     widget: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.local_fire_department,
//                             color: Colors.orange, size: 24),
//                         Text(
//                           "$currentCalories Kcal",
//                           style: TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "of $goalCalories kcal",
//                           style: TextStyle(fontSize: 14, color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
