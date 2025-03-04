import 'package:flutter/material.dart';

class WeightGoalSelector extends StatefulWidget {
  final List<Map<String, String>> goals;
  const WeightGoalSelector({Key? key, required this.goals}) : super(key: key);
  @override
  _WeightGoalSelectorState createState() => _WeightGoalSelectorState();
}

class _WeightGoalSelectorState extends State<WeightGoalSelector> {
  String? selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.goals.map((goal) => _buildGoalTile(goal)).toList(),
    );
  }

  Widget _buildGoalTile(Map<String, String> goal) {
    final isSelected = selectedGoal == goal['title'];

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGoal = goal['title'];
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected ? Colors.orange : Colors.grey,
            width: isSelected ? 2.0 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.orange.withOpacity(0.5),
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
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Colors.white,
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
