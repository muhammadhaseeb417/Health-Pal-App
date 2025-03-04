import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FoodDescriptionGaugeStyle extends StatelessWidget {
  final String title;
  final String assetImage;
  final double gainedPortion;
  final double totalPortion;
  final Color gaugeColor;
  final int gaugeWidth;
  const FoodDescriptionGaugeStyle(
      {super.key,
      required this.title,
      required this.gainedPortion,
      required this.totalPortion,
      required this.gaugeColor,
      required this.gaugeWidth,
      required this.assetImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(assetImage, height: 60, width: 70, fit: BoxFit.cover),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$gainedPortion g',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
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
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
