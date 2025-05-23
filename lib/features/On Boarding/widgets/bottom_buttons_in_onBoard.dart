import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class BottomButtonsInOnboard extends StatelessWidget {
  final bool bottomGreen;
  final VoidCallback
      onPressed; // Corrected from VoidCallbackAction to VoidCallback

  const BottomButtonsInOnboard({
    super.key,
    this.bottomGreen = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 50, left: 30, right: 30),
      width: double.infinity,
      color: bottomGreen ? CustomColors.greenShadeColor : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.07,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.greenColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onPressed, // No need for extra curly braces
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
