import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Health Pal"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome to Health Pal!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
              "Health Pal is your AI-powered health assistant that helps you track calories, plan meals, and improve your diet for a healthier lifestyle.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text("🌟 Features:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(
                "✔️ AI Diet Assistant\n✔️ Food Logging & Calorie Tracking\n✔️ Meal Planning & Grocery Lists\n✔️ Hydration Reminders\n✔️ Voice Commands Support"),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
