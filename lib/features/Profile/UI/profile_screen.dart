import 'package:flutter/material.dart';
import 'package:health_pal/features/Profile/widgets/setting_menu_bar.dart';
import 'package:health_pal/main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Profile"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(500),
                  ),
                  child: Image.asset("assets/profile/profile_pic.png",
                      fit: BoxFit.contain),
                ),
              ),
              const Text('Muhammad Haseeb',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('@mhhaseeb'),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SettingMenuBar(
                      title: "Daily Intake",
                      icon: Icons.person,
                    ),
                    SizedBox(height: 15),
                    SettingMenuBar(
                      title: "My Meals",
                      icon: Icons.food_bank_outlined,
                    ),
                    SizedBox(height: 15),
                    SettingMenuBar(
                      title: "Nutrition Report",
                      icon: Icons.report,
                    ),
                    SizedBox(height: 15),
                    SettingMenuBar(
                      title: "Favorites Food",
                      icon: Icons.favorite,
                    ),
                    SizedBox(height: 15),
                    SettingMenuBar(
                      title: "Log out",
                      icon: Icons.login,
                      function: () {
                        userAuth.signOut();
                        Navigator.pushNamed(context, "/login");
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
