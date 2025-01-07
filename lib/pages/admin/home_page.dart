import 'package:conju_app/pages/admin/services/doctor/add_doctor.dart';
import 'package:conju_app/pages/admin/services/doctor/manage_docts.dart';
import 'package:conju_app/pages/admin/services/product/add_product.dart';
import 'package:conju_app/pages/admin/services/product/manage_products.dart';
import 'package:conju_app/pages/admin/services/slider/update_slider.dart';
import 'package:conju_app/pages/admin/services/user/manage_users.dart';
import 'package:conju_app/pages/splash_screen.dart';
import 'package:conju_app/widgets/botton/rounded_button.dart';
import 'package:conju_app/widgets/others/small_check.dart';
import 'package:conju_app/widgets/text_styles.dart';
import 'package:equal_space/equal_space.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/color_constant.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  // Method to build the row with two SmallCheckWidgets
  Widget _buildRow({
    required Function()? onTap,
    required Function()? secondOnTap,
    required String title,
    required String secondTitle,
    required IconData icon,
    required IconData secondIcon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SmallCheckWidget(
            color: Colors.white,
            icon: icon,
            onTap: onTap,
            height: 50,
            title: title,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SmallCheckWidget(
            color: Colors.white,
            icon: secondIcon,
            onTap: secondOnTap,
            height: 50,
            title: secondTitle,
          ),
        ),
      ],
    );
  }

  // Method to show the logout confirmation modal
  void _showLogoutModal(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (context) {
        return Container(
          height: h * 0.24,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: AppColors.white,
          ),
          child: Column(
            children: [
              Text(
                'Logout',
                style:
                    MyTextStyle.largeText(context, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: h * 0.02),
              Text(
                "Are you sure you want to log out?",
                style: MyTextStyle.normalText(context,
                    color: AppColors.borderSide),
              ),
              SizedBox(height: h * 0.02),
              SizedBox(
                width: double.infinity,
                child: CustomRoundButton(
                  onPressed: () async {
                    FirebaseAuth.instance.signOut();
                    Get.snackbar(
                        "See you soon Admin ;-) ", "Signed off successfully");
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
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Text.rich(
              const TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.black),
                  ),
                  TextSpan(
                    text: "Admin",
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Color(0xFF00BF6D)),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            SpacedColumn(
              space: 20,
              children: [
                _buildRow(
                  onTap: () => Get.to(const UsersListScreen()),
                  secondOnTap: () => Get.to(const AddProductScreen()),
                  title: 'Check users',
                  secondTitle: 'Add Product',
                  icon: Icons.manage_accounts,
                  secondIcon: Icons.add,
                ),
                _buildRow(
                  onTap: () => Get.to(const ManageProductScreen()),
                  secondOnTap: () => Get.to(const AddAdSliderScreen()),
                  title: 'Edit Products',
                  secondTitle: 'Add Slider',
                  icon: Icons.list,
                  secondIcon: CupertinoIcons.dial,
                ),
                _buildRow(
                  onTap: () {
                    Get.to(() => const AddDoctorScreen());
                  },
                  secondOnTap: () {
                    Get.to(() => const ManageDoctorScreen());
                  },
                  title: 'Add Doctor',
                  secondTitle: 'Remove Doctor',
                  icon: Icons.dangerous,
                  secondIcon: Icons.add,
                ),
                SmallCheckWidget(
                  color: AppColors.cleanerAppBarColor,
                  icon: Icons.logout,
                  height: 80,
                  onTap: () => _showLogoutModal(context),
                  title: 'Log out',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
