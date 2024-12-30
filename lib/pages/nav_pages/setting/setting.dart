import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/services/firebase_services/user/user_services.dart';
import 'package:conju_app/pages/auth/sign_in.dart';
import 'package:conju_app/pages/nav_pages/setting/help_center.dart';
import 'package:conju_app/pages/nav_pages/setting/my_profile.dart';
import 'package:conju_app/pages/splash_screen.dart';
import 'package:conju_app/widgets/others/custom_expansion_tile.dart';
import 'package:conju_app/widgets/botton/rounded_button.dart';
import 'package:conju_app/widgets/text_styles.dart';
import 'package:equal_space/equal_space.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SpacedColumn(
              space: 10,
              children: [
                const SizedBox(height: 20),
                const ProfilePic(),
                const SizedBox(height: 20),
                ProfileMenu(
                  text: "My Account",
                  icon: "assets/svgs/outline_person.svg",
                  press: () => {Get.to(const MyProfileScreen())},
                ),

                // ProfileMenu(
                //   text: "Change Password",
                //   icon: "assets/svgs/lock.svg",
                //   press: () {
                //     Get.to(const Edit());
                //   },
                // ),
                ProfileMenu(
                  text: "Help Center",
                  icon: "assets/svgs/help.svg",
                  press: () {
                    Get.to(const HelpCenterScreen());
                  },
                ),
                CustomExpansionTileWidget(
                    leading: SvgPicture.asset("assets/svgs/message.svg"),
                    title: const Text("Contact us"),
                    trailing: SvgPicture.asset("assets/svgs/forward_icon.svg"),
                    children: [
                      InkWell(
                        onTap: () {
                          launchUrl(Uri(
                            scheme: 'mailto',
                            path: 'conjuscanTeam@gmail.com',
                            query: 'subject=Help in App Inquiry&body=Hello!',
                          ));
                        },
                        child: ListTile(
                          leading: const Icon(Icons.email_outlined),
                          title: Text(
                            "conjuscanTeam@gmail.com",
                            style: MyTextStyle.smallText(context),
                          ),
                        ),
                      )
                    ]),
                ProfileMenu(
                  text: "Log Out",
                  icon: "assets/svgs/logout.svg",
                  press: () {
                    showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        backgroundColor: AppColors.white,
                        builder: (context) {
                          return Container(
                            height: h * 0.24,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: AppColors.white),
                            child: Column(
                              children: [
                                Text(
                                  'Logout',
                                  style: MyTextStyle.largeText(context,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: h * 0.02,
                                ),
                                Text("Are you sure you want to log out?",
                                    style: MyTextStyle.normalText(
                                      context,
                                      color: AppColors.borderSide,
                                    )),
                                SizedBox(
                                  height: h * 0.02,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomRoundButton(
                                    onPressed: () async {
                                      FirebaseAuth.instance.signOut();
                                      Get.snackbar("Good Bye",
                                          "User signed off successfully");
                                      Get.offAll(const SplashScreen());
                                    },
                                    horizontalPadding: h * 0.05,
                                    text: 'Yes, Logout',
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: MyTextStyle.smallText(context,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500),
                                    ))
                              ],
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: FirebaseUserServices().getCurrentUserProfilePicture(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator
        } else if (snapshot.hasError) {
          return const Text("Error fetching profile picture"); // Handle error
        } else if (snapshot.hasData) {
          return Container(
            height: 115,
            width: 115,
            decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.borderLite)),
            child: CircleAvatar(
              backgroundImage: NetworkImage(snapshot.data!),
            ),
          ); // Display the image
        } else {
          return CustomRoundButton(
            onPressed: () {
              Get.offAll(const SignInScreen());
            },
            text: 'Sign In',
          );
        }
      },
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.mediumAquarine,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: AppColors.skyColor,
      ),
      onPressed: press,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter:
                const ColorFilter.mode(Color(0xFF000000), BlendMode.srcIn),
            width: 22,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF757575),
              ),
            ),
          ),
          SvgPicture.asset("assets/svgs/forward_icon.svg"),
        ],
      ),
    );
  }
}
