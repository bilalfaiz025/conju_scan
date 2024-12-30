// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/pages/admin/home_page.dart';
import 'package:conju_app/pages/auth/sign_in.dart';
import 'package:conju_app/pages/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAuthServices {
  Future<void> signup(String email, String password, var imageFile, String name,
      String phone) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Upload profile image to Firebase Storage
      final storage = FirebaseStorage.instance;
      final reference =
          storage.ref().child('images/${DateTime.now().toIso8601String()}.jpg');
      final uploadTask = reference.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      print("imageUrl: $imageUrl");
      // Add user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'profile_pic': imageUrl,
        'email': email,
        'name': name,
        'phone': phone,
        'role': 'user',
        'disabled': false,
      });

      // Navigate to home screen
      Get.offAll(const SignInScreen());
      Get.snackbar(
          "Account Created", "Your account has been successfully registered.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Weak Password", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Email In Use",
            "The email is already registered. Please log in instead.");
      } else {
        Get.snackbar("Authentication Error", e.message ?? "An error occurred.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // Sign in with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the logged-in user's UID
      String userId = userCredential.user?.uid ?? '';

      // Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Check if the user is disabled
          bool isDisabled = userData['disabled'] ?? false;

          if (isDisabled) {
            Get.snackbar(
              "Account Disabled",
              "Your account has been disabled. Please contact support.",
              colorText: Colors.red,
            );
            await auth.signOut(); // Log out the disabled user
            return;
          }

          // Check the role
          String role = userData['role'];

          if (role == 'admin') {
            // Navigate to Admin Screen
            Get.to(() => const AdminHomePage());
          } else if (role == 'user') {
            // Navigate to User Home Screen
            Get.to(() => const HomeScreen());
          } else {
            // Default fallback
            Get.to(() => const HomeScreen());
          }
        } else {
          Get.snackbar("Error", "User data not found.");
        }
      } else {
        Get.snackbar("Error", "No user record found in Firestore.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("User Not Found", "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Incorrect Credentials", "Wrong password provided.");
      } else {
        Get.snackbar("Error", e.message ?? "An unexpected error occurred.");
      }
    } catch (e) {
      Get.snackbar("Error", "An unexpected error occurred: $e");
    }
  }

  Future<void> resetPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Success",
        "Password reset email sent successfully",
      );
      Get.to(const SignInScreen());
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred, please try again.";
      Get.snackbar("Error", errorMessage);
      if (e.code == 'user-not-found') {
        errorMessage = "No user found with this email address.";
      }
      Get.snackbar("Error", e.toString());
    }
  }
}
