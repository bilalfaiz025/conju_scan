// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';

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

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final doctorsCollection =
        FirebaseFirestore.instance.collection('Doctors'); // Firebase Collection
    final snapshot = await doctorsCollection.get();
    return snapshot.docs
        .map((doc) => {
              'name': doc['name'] ?? 'Unknown',
              'address': doc['address'] ?? 'Unknown',
              'phone': doc['phone'] ?? '',
              'profile_picture':
                  doc['profile_picture'] ?? 'https://via.placeholder.com/150',
              'specialization': doc['specialization'] ?? '',
            })
        .toList();
  }

  Future<void> downloadAndOpenImage(Uint8List imageData) async {
    PermissionStatus status = await Permission.manageExternalStorage.request();
    if (status.isDenied || status.isRestricted) {
      await Permission.storage.request();
    }

    if (status.isGranted) {
      try {
        // Get the path to the Downloads directory
        final directory = Directory('/storage/emulated/0/Download');
        if (await directory.exists()) {
          // Create a file in the Downloads directory
          final imagePath =
              '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';

          // Save the image as a file
          final file = File(imagePath);
          await file.writeAsBytes(imageData);

          // Notify user of success
          Get.snackbar("Success", "Image saved to your Downloads folder!");

          OpenFilex.open(imagePath).then((result) {
            if (result.type != ResultType.done) {
              // If it fails to open, display an error message
              Get.snackbar("Error", "Failed to open image.");
            }
          });
        } else {
          // Notify if the Downloads folder doesn't exist
          Get.snackbar("Error", "Downloads folder not found.");
        }
      } catch (e) {
        // Error saving the file
        Get.snackbar("Error", "Failed to save image: $e");
      }
    } else {
      // Notify user if permission is denied
      Get.snackbar("Permission Denied",
          "Please grant storage permission to download images.");
    }
  }

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final productsCollection =
        FirebaseFirestore.instance.collection('Products');
    final snapshot = await productsCollection.get();
    return snapshot.docs.map((doc) {
      return {
        'title': doc['name'] ?? 'No Title',
        'description': doc['description'] ?? 'No Description',
        'image':
            doc['image'] ?? 'https://via.placeholder.com/150', // Fallback image
        'link': doc['link'] ?? '',
        'price': doc['price'] ?? '0',
      };
    }).toList();
  }
}
