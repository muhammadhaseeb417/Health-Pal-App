import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          Image.asset(
            "assets/logo/logo.png",
            width: MediaQuery.sizeOf(context).width * 0.4,
          ),
          const Text(
            '1 to 4',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
