import 'package:flutter/material.dart';
import 'package:health_pal/features/Authentication/models/user_model.dart';
import 'package:health_pal/features/Authentication/services/firebase_database_func.dart';

class CustomHeaderAppBar extends StatelessWidget {
  const CustomHeaderAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseDatabaseService _databaseService = FirebaseDatabaseService();

    return Container(
      child: StreamBuilder<UserModel?>(
        stream: _databaseService.streamCurrentUserData(),
        builder: (context, snapshot) {
          // Default values for loading/error states
          String userName = 'Loading...';
          String? userPhotoURL;

          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            userName = user.name.isNotEmpty ? _getFirstName(user.name) : 'User';
            userPhotoURL = user.photoURL;
          } else if (snapshot.hasError) {
            userName = 'User';
          }

          return Row(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(500),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: userPhotoURL != null
                      ? Image.network(
                          userPhotoURL,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              "assets/images/profile_img.png",
                              fit: BoxFit.cover,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          "assets/images/profile_img.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(500),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement search functionality
                  },
                  icon: const Icon(Icons.search, size: 22),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(500),
                ),
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement notifications functionality
                  },
                  icon: const Icon(Icons.notifications, size: 22),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to get first name from full name
  String _getFirstName(String fullName) {
    if (fullName.isEmpty) return 'User';

    List<String> nameParts = fullName.trim().split(' ');
    String firstName = nameParts[0];

    // Truncate if too long (like "Muhammad H..")
    if (firstName.length > 12) {
      return '${firstName.substring(0, 10)}..';
    }

    return firstName;
  }
}
