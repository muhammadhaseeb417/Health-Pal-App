import 'package:flutter/material.dart';

class SettingMenuBar extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? function;
  final bool makeRed;

  const SettingMenuBar({
    super.key,
    required this.title,
    required this.icon,
    this.function,
    this.makeRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      splashColor: Colors.grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 30, color: !makeRed ? Colors.black87 : Colors.red),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: !makeRed ? Colors.black87 : Colors.red,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: !makeRed ? Colors.grey : Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
