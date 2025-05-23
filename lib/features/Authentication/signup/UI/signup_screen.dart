import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import '../../services/user_auth.dart';
import '../../services/firebase_database_func.dart';
import '../../login/widgets/custom_text_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final UserAuth _userAuth = UserAuth();
  final FirebaseDatabaseService _dbService = FirebaseDatabaseService();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;
  XFile? _selectedImage;  // To store the selected image
  
  // Check connectivity status
  Future<bool> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
  
  // Pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting image: $e')),
        );
      }
    }
  }
  
  // Upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;
    
    try {
      final File imageFile = File(_selectedImage!.path);
      final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
      
      // Upload the file
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;
      
      // Get download URL
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.1), // Add some spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo/logo.png",
                    width: MediaQuery.of(context).size.width * 0.6,
                  ),
                ],
              ),
              const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Profile Image Picker
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: _selectedImage != null 
                            ? FileImage(File(_selectedImage!.path)) 
                            : null,
                        child: _selectedImage == null
                            ? const Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Add Profile Picture',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textFieldFor: "Name",
                iconData: Icons.person,
                regExp: RegExp(r'^[a-zA-Z ]+$'),
                controller: _nameController,
              ),
              
              const SizedBox(height: 20),
              CustomTextField(
                textFieldFor: "Email",
                iconData: Icons.mail,
                regExp: RegExp(r'[a-zA-Z0-9@.]'),
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textFieldFor: "Password",
                iconData: Icons.password_rounded,
                controller: _passwordController,
                isPasswordField: true,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                textFieldFor: "Confirm Password",
                iconData: Icons.password_rounded,
                controller: _confirmPasswordController,
                isPasswordField: true,
              ),

              const SizedBox(height: 10),

              const SizedBox(height: 40),
              SizedBox(
                width: double.maxFinite,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isLoading) return;
                    
                    setState(() {
                      _isLoading = true;
                    });
                    
                    try {
                      print("Sign Up button pressed");
                      
                      // Validate inputs
                      if (_nameController.text.isEmpty ||
                          _emailController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _confirmPasswordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all fields'),
                          ),
                        );
                        return;
                      }
                      
                      if (_passwordController.text != _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password and Confirm Password do not match'),
                          ),
                        );
                        return;
                      }
                      
                      // Check connectivity
                      bool isConnected = await _checkConnectivity();
                      if (!isConnected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No internet connection. Please try again when connected.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        return;
                      }
                      
                      // Get user input data
                      String name = _nameController.text.trim();
                      String email = _emailController.text.trim();
                      
                      // Upload profile image if selected
                      String? photoURL;
                      if (_selectedImage != null) {
                        photoURL = await _uploadImage();
                      }
                      
                      // Sign up user
                      final credential = await _userAuth.signUpWithEmailPassword(
                        email, 
                        _passwordController.text
                      );
                      
                      if (credential != null && credential.user != null) {
                        // Create user document with UserModel
                        await _dbService.createUserDocument(
                          credential.user!,
                          name: name,
                          additionalData: {
                            "photoURL": photoURL,
                            "createdAt": DateTime.now().toIso8601String(),
                          }
                        );
                        
                        // Update user profile with photo URL
                        if (photoURL != null) {
                          await _userAuth.updateUserProfile(
                            displayName: name,
                            photoURL: photoURL,
                          );
                        }
                        
                        // Check sync status and update if needed
                        await _dbService.syncPendingData();
                        
                        // Navigate to home screen
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(context, "/navbar");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Sign up successful'),
                          ),
                        );
                      } else {
                        throw Exception('Failed to create account');
                      }
                    } catch (e) {
                      print('Sign up error: $e');
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sign up failed: ${e.toString()}'),
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 17),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/login"),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Add extra padding at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
