import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../utils/constants/colors.dart';
import 'linear_gauge_widget_details.dart';

class CalorieGaugeWidget extends StatelessWidget {
  const CalorieGaugeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double currentCalories = 1721;
    final double goalCalories = 2213;

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
                          "$currentCalories Kcal",
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
                              gainedPortion: 78,
                              totalPortion: 90,
                              gaugeColor: CustomColors.greenColor,
                            ),
                            LinearGaugeWidgetDetails(
                              title: "Fats",
                              gainedPortion: 45,
                              totalPortion: 70,
                              gaugeColor: CustomColors.orangeColor,
                            ),
                            LinearGaugeWidgetDetails(
                              title: "Carbs",
                              gainedPortion: 95,
                              totalPortion: 110,
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
