import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/pages/admin/home_page.dart';
import 'package:conju_app/pages/boarding/boarding_page.dart';
import 'package:conju_app/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  // Function to handle the user status and navigate accordingly
  Future<void> _checkUserStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _handleUserRole(currentUser.uid);
    } else {
      // Navigate to intro screen if user is not logged in
      Get.to(() => const InteractiveIntroScreen());
    }
  }

  // Function to handle role-based navigation after fetching user data
  Future<void> _handleUserRole(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          String role = userData['role'];
          if (role == 'admin') {
            Get.to(() => const AdminHomePage());
          } else if (role == 'user') {
            Get.to(() => const HomeScreen());
          } else {
            _navigateToIntroScreenWithError("Invalid role.");
          }
        } else {
          _navigateToIntroScreenWithError("User data not found.");
        }
      } else {
        _navigateToIntroScreenWithError("No user record found.");
      }
    } catch (e) {
      _navigateToIntroScreenWithError(e.toString());
    }
  }

  // Helper function to handle navigation and display error messages
  void _navigateToIntroScreenWithError(String errorMessage) {
    Get.snackbar("Error", errorMessage);
    Get.to(() => const InteractiveIntroScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 190,
              width: 190,
            ),
          ],
        ),
      ),
    );
  }
}
