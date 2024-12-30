// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserServices {
  Future<String?> getCurrentUserProfilePicture() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      // Check if the user is logged in
      if (user != null) {
        // Get the user's document from the "users" collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Check if the document exists and the 'profile_pic' field is available
        if (userDoc.exists) {
          var data = userDoc.data() as Map<String, dynamic>;
          return data['profile_pic']; // Return the profile picture URL
        } else {
          print("User document does not exist.");
          return null;
        }
      } else {
        // User is not logged in
        print("No user logged in.");
        return null;
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching user profile picture: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is logged in
      if (user != null) {
        // Get the user's document from the "users" collection
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Check if the document exists
        if (userDoc.exists) {
          return userDoc.data()
              as Map<String, dynamic>; // Return all user data as a map
        } else {
          print("User document does not exist.");
          return null;
        }
      } else {
        // User is not logged in
        print("No user logged in.");
        return null;
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching user information: $e");
      return null;
    }
  }

  Future<void> updateCurrentUserData(name, email, phone, image) async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      // Check if the user is logged in
      if (user != null) {
        // Get the user's document from the "users" collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'name': name,
          'email': email,
          'phone': phone,
          'profile_pic': image,
        });
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching user profile picture: $e");
      return;
    }
  }
}
