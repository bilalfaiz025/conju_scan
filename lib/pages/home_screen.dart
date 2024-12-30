import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/nav_pages/doctors_page.dart';
import 'package:conju_app/pages/nav_pages/products_page.dart';
import 'package:conju_app/pages/nav_pages/setting/setting.dart';
import 'package:conju_app/pages/nav_pages/user_home_page.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Define your screen list for easy navigation, using const constructors
  static const List<Widget> screenList = [
    UserHomePage(),
    DoctorContactListScreen(),
    ProductsScreen(),
    ProfileScreen(),
  ];

  // Function to handle tab change
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update the current index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CrystalNavigationBar(
        currentIndex: _currentIndex, // Set the selected index
        onTap: onTabTapped, // Handle the tab change
        indicatorColor: Colors.white,
        height: 60, // Adjusted height for better visual consistency
        borderRadius: 10,
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: Colors.white,
        marginR: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 20), // Adjusted margins for balance
        items: [
          CrystalNavigationBarItem(icon: CupertinoIcons.camera_circle),
          CrystalNavigationBarItem(icon: CupertinoIcons.bandage_fill),
          CrystalNavigationBarItem(icon: CupertinoIcons.plus_bubble),
          CrystalNavigationBarItem(icon: CupertinoIcons.person_crop_circle),
        ],
      ),
      // Dynamically load the widget based on the selected tab index
      body: screenList[_currentIndex],
    );
  }
}
