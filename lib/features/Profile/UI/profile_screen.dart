import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/models/user_model.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';
import 'package:health_pal/features/Profile/widgets/setting_menu_bar.dart';
import 'package:health_pal/main.dart';
import 'package:health_pal/features/On%20Boarding/models/user_details_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseDatabaseService _databaseService = FirebaseDatabaseService();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.arrow_back_ios, color: Colors.transparent),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<UserModel?>(
        stream: _databaseService.streamCurrentUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading profile: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final UserModel? user = snapshot.data;
          if (user == null) {
            return const Center(
              child: Text('No user data found'),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(60),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: user.photoURL != null
                            ? Image.network(
                                user.photoURL!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/images/profile_img.png",
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                "assets/images/profile_img.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        SettingMenuBar(
                          title: "User Details",
                          icon: Icons.person_outline,
                          function: () {
                            _showUserDetailsDialog(context, user);
                          },
                        ),
                        const SizedBox(height: 12),
                        SettingMenuBar(
  title: "Daily Intake",
  icon: Icons.person,
  function: () {
    Navigator.pushNamed(context, '/daily_intake');
  },
),
                        const SizedBox(height: 12),
                        SettingMenuBar(
                          title: "My Meals",
                          icon: Icons.food_bank_outlined,
                          function: () {
                            Navigator.pushNamed(context, '/my_meals');
                          },
                        ),
                        const SizedBox(height: 12),
                        SettingMenuBar(
                          title: "Favorites Food",
                          icon: Icons.favorite,
                          function: () {
                            Navigator.pushNamed(context, '/favorites_food');
                          },
                        ),
                        const SizedBox(height: 12),
                        SettingMenuBar(
                          title: "About Us",
                          icon: Icons.info,
                          function: () {
                            Navigator.pushNamed(context, '/aboutus');
                          },
                        ),
                        const SizedBox(height: 12),
                        SettingMenuBar(
                          title: "Log out",
                          icon: Icons.logout,
                          makeRed: true,
                          function: () async {
                            await userAuth.signOut();
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (context) => UserDetailsDialog(user: user),
    );
  }
}

class UserDetailsDialog extends StatefulWidget {
  final UserModel user;

  const UserDetailsDialog({super.key, required this.user});

  @override
  State<UserDetailsDialog> createState() => _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<UserDetailsDialog> {
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late WeightUnit _selectedWeightUnit;
  late Goal _selectedGoal;
  late Gender _selectedGender;
  bool _isLoading = false;

  final FirebaseDatabaseService _databaseService = FirebaseDatabaseService();

  @override
  void initState() {
    super.initState();
    final userDetails = widget.user.userDetails;

    _ageController = TextEditingController(
      text: userDetails?.age.toString() ?? '',
    );
    _weightController = TextEditingController(
      text: userDetails?.weight.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: userDetails?.height.toString() ?? '',
    );
    _selectedWeightUnit = userDetails?.weightUnit ?? WeightUnit.kg;
    _selectedGoal = userDetails?.goal ?? Goal.maintainWeight;
    _selectedGender = userDetails?.gender ?? Gender.other;
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _ageController,
                      label: 'Age',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _weightController,
                      label: 'Weight',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown<WeightUnit>(
                      label: 'Weight Unit',
                      value: _selectedWeightUnit,
                      items: WeightUnit.values,
                      onChanged: (value) =>
                          setState(() => _selectedWeightUnit = value!),
                      displayText: (unit) =>
                          unit.toString().split('.').last.toUpperCase(),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _heightController,
                      label: 'Height (cm)',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown<Gender>(
                      label: 'Gender',
                      value: _selectedGender,
                      items: Gender.values,
                      onChanged: (value) =>
                          setState(() => _selectedGender = value!),
                      displayText: (gender) => gender
                          .toString()
                          .split('.')
                          .last
                          .replaceFirst(
                              gender.toString().split('.').last[0],
                              gender
                                  .toString()
                                  .split('.')
                                  .last[0]
                                  .toUpperCase()),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown<Goal>(
                      label: 'Goal',
                      value: _selectedGoal,
                      items: Goal.values,
                      onChanged: (value) =>
                          setState(() => _selectedGoal = value!),
                      displayText: (goal) {
                        switch (goal) {
                          case Goal.loseWeight:
                            return 'Lose Weight';
                          case Goal.maintainWeight:
                            return 'Maintain Weight';
                          case Goal.gainWeight:
                            return 'Gain Weight';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _isLoading ? null : () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveUserDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required void Function(T?) onChanged,
    required String Function(T) displayText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(displayText(item)),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Future<void> _saveUserDetails() async {
    if (!_validateInputs()) return;

    setState(() => _isLoading = true);

    try {
      final userDetails = UserDetails(
        age: int.parse(_ageController.text),
        weight: double.parse(_weightController.text),
        weightUnit: _selectedWeightUnit,
        goal: _selectedGoal,
        gender: _selectedGender,
        height: double.parse(_heightController.text),
      );

      await _databaseService.updateCurrentUserDetails(userDetails);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User details updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating user details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateInputs() {
    if (_ageController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _heightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    try {
      int.parse(_ageController.text);
      double.parse(_weightController.text);
      double.parse(_heightController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid numbers'),
          backgroundColor: Colors.orange,
        ),
      );
      return false;
    }

    return true;
  }
}
