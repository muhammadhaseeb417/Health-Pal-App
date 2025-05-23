import 'package:flutter/material.dart';
import 'package:health_pal/features/About%20Us/UI/about_us_screen.dart';
import 'package:health_pal/features/Add%20Food_or_Recipe/UI/add_food_screen.dart';
import 'package:health_pal/features/Home/UI/home_screen_2.dart';
import 'package:health_pal/features/Profile/UI/profile_screen.dart';

import '../../Food Recognization/Food Image Capture Page/UI/food_image_capture_page.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _navBarPages = [
    const HomeScreentwo(),
    const AddFoodScreen(),
    const AboutUsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onFabPressed() {
    // FAB action (e.g., open camera or food recognition)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FoodImageCapturePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _navBarPages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _onFabPressed,
        backgroundColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomItem(Icons.home, 'Home', 0),
              _buildBottomItem(Icons.add, 'Add Food', 1),
              const SizedBox(width: 40), // space for FAB
              _buildBottomItem(Icons.info, 'Info', 2),
              _buildBottomItem(Icons.settings, 'Setting', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
