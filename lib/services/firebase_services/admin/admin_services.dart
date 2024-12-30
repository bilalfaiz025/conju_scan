import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminServices {
  Future<void> disableUser(String userId, bool isDisabled) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'disabled': !isDisabled,
      });
      String action = isDisabled ? 'enabled' : 'disabled';
      Get.snackbar('Success', 'User $action successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user status: $e');
    }
  }
  
}
