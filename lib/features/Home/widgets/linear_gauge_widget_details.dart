import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../utils/constants/colors.dart';

class LinearGaugeWidgetDetails extends StatelessWidget {
  final String title;
  final double gainedPortion;
  final double totalPortion;
  final Color gaugeColor;

  const LinearGaugeWidgetDetails(
      {super.key,
      required this.title,
      required this.gaugeColor,
      required this.gainedPortion,
      required this.totalPortion});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 90,
          child: SfLinearGauge(
            minimum: 0,
            maximum: totalPortion,
            showLabels: false,
            showTicks: false,
            barPointers: [
              LinearBarPointer(
                value: gainedPortion,
                color: gaugeColor,
                animationDuration: 15000,
                animationType: LinearAnimationType.ease,
                enableAnimation: true,
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '$gainedPortion/$totalPortion g',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
