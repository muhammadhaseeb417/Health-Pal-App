import 'package:flutter/material.dart';

class SettingMenuBar extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? function;
  const SettingMenuBar(
      {super.key, required this.title, required this.icon, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 40),
              SizedBox(width: 5),
              Text(title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))
            ],
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios_sharp),
        ],
      ),
    );
  }
}
