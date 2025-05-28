import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class LinearGaugeWidgetDetails extends StatelessWidget {
  final String title;
  final double gainedPortion;
  final double totalPortion;
  final Color gaugeColor;
  final int gaugeWidth;

  const LinearGaugeWidgetDetails({
    super.key,
    required this.title,
    required this.gaugeColor,
    required this.gainedPortion,
    required this.totalPortion,
    this.gaugeWidth = 90,
  });

  @override
  Widget build(BuildContext context) {

    final formattedGainedPortion = gainedPortion.toStringAsFixed(1);
    // Format totalPortion as integer since it's typically a whole number
    final formattedTotalPortion = totalPortion.toInt();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: gaugeWidth != 90 ? double.maxFinite : 90,
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
          '$formattedGainedPortion/$formattedTotalPortion g',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
