import 'package:flutter/material.dart';

class CustomHeaderAppBar extends StatelessWidget {
  const CustomHeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(500),
            ),
            child: Image.asset("assets/profile/profile_pic.png",
                fit: BoxFit.contain),
          ),
          SizedBox(width: 20),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome'),
              Text(
                'Muhammad H..',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(500),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, size: 22),
            ),
          ),
          SizedBox(width: 10),
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(500),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
