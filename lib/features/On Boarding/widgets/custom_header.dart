import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {
  final bool makeItemsWhite;
  final int pageIndex;
  const CustomHeader(
      {super.key, this.makeItemsWhite = false, required this.pageIndex});

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
            icon: Icon(
              Icons.arrow_back_ios,
              color: makeItemsWhite ? Colors.white : Colors.black,
            ),
          ),
          Image.asset(
            "assets/logo/logo.png",
            width: MediaQuery.sizeOf(context).width * 0.4,
          ),
          Text(
            '$pageIndex to 4',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: makeItemsWhite ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
