import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class AddFoodWidgetHome extends StatelessWidget {
  final String title;
  final String subTitle;
  final String imgPath;

  const AddFoodWidgetHome(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.maxFinite,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: CustomColors.greenColor, width: 2),
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // Ensures full circular shape
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      500), // Ensures the image remains circular
                  child: Image.asset(imgPath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500),
              color: CustomColors.lightGreenColor,
            ),
            child: const Center(
                child: Icon(Icons.add_circle_outline_rounded,
                    size: 30, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
