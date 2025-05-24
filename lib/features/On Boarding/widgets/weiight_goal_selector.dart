import 'package:flutter/material.dart';
import 'package:health_pal/utils/constants/colors.dart';

class WeightGoalSelector extends StatelessWidget {
  final List<Map<String, dynamic>> goals; // Updated to include 'value'
  final dynamic selectedValue;
  final Function(dynamic)? onValueSelected;

  const WeightGoalSelector({
    Key? key,
    required this.goals,
    required this.selectedValue,
    this.onValueSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: goals.map((goal) => _buildGoalTile(goal)).toList(),
    );
  }

  Widget _buildGoalTile(Map<String, dynamic> goal) {
    final isSelected = selectedValue == goal['value'];

    return GestureDetector(
      onTap: () {
        if (onValueSelected != null) {
          onValueSelected!(goal['value']);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? CustomColors.greenColor : Colors.grey,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: CustomColors.greenColor.withOpacity(0.5),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(goal['image']!, width: 40, height: 40),
                const SizedBox(width: 12.0),
                Text(
                  goal['title']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? CustomColors.greenColor : Colors.white,
                border: Border.all(color: Colors.grey),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}