import 'package:flutter/material.dart';
import 'package:health_pal/utils/constants/colors.dart';

class ButtonsInOnboard3 extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ButtonsInOnboard3({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : CustomColors.greenColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? CustomColors.greenColor : Colors.white,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isSelected ? CustomColors.greenColor : Colors.white,
          ),
        ),
      ),
    );
  }
}
