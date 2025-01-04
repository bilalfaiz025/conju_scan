import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/services/firebase_services/user/user_services.dart';
import 'package:conju_app/pages/auth/sign_in.dart';
import 'package:conju_app/pages/nav_pages/setting/edit_profile.dart';
import 'package:conju_app/widgets/botton/rounded_button.dart';
import 'package:conju_app/widgets/others/info_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.greenish,
        title: const Text("Profile"),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: FirebaseUserServices()
            .getCurrentUserInfo(), // Fetch user info asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show loading spinner
          } else if (snapshot.hasError) {
            return const Center(
                child: Text(
                    "Error fetching user information")); // Show error message
          } else if (snapshot.hasData && snapshot.data != null) {
            Map<String, dynamic> userInfo = snapshot.data!;

            // Extract user info from the map
            String name = userInfo['name'] ?? 'No name available';
            String email = userInfo['email'] ?? 'No email available';
            String phone = userInfo['phone'] ?? 'No phone number available';
            String uid = userInfo['uid'] ?? 'No user ID available';
            String profilePic = userInfo['profile_pic'] ??
                'https://i.postimg.cc/ht3vkJJj/logo.png'; // Default profile pic

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ProfilePic(image: profilePic), // Display the profile picture
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(height: 16.0 * 2),
                  Info(infoKey: "User ID", info: uid),
                  // Example, you can update this from Firestore if available
                  Info(infoKey: "Phone", info: phone),
                  Info(infoKey: "Email Address", info: email),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity,
                    child: CustomRoundButton(
                      color: AppColors.greenish,
                      text: 'Edit Profile',
                      onPressed: () {
                        Get.to(EditProfileScreen(
                          email: email,
                          phone: phone,
                          name: name,
                          profilePic: profilePic,
                        ));
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: CustomRoundButton(
                onPressed: () {
                  Get.offAll(const SignInScreen());
                },
                text: 'Sign In',
              ),
            );
          }
        },
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(image),
      ),
    );
  }
}
