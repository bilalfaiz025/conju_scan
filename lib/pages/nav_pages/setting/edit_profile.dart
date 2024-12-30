import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/nav_pages/setting/my_profile.dart';
import 'package:conju_app/widgets/botton/rounded_button.dart';
import 'package:conju_app/widgets/others/circular_avatar.dart';
import 'package:conju_app/widgets/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String profilePic;

  const EditProfileScreen({
    super.key,
    required this.email,
    required this.name,
    required this.phone,
    required this.profilePic,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  File? image;
  bool isLoading = false;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar("Validation Failed", "Please fill all fields correctly.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar("Error", "User not logged in.");
        return;
      }

      String? imageUrl = widget.profilePic;

      // Upload new image if selected
      if (image != null) {
        final storage = FirebaseStorage.instance;
        final reference =
            storage.ref().child('images/${DateTime.now().toString()}.jpg');
        final uploadTask = reference.putFile(image!);
        final snapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await snapshot.ref.getDownloadURL();
      }

      // Update Firestore data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'profile_pic': imageUrl,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
      });

      Get.off(() => const MyProfileScreen());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              CustomProfileAvatar(
                image: image != null
                    ? FileImage(image!) as ImageProvider<Object>
                    : NetworkImage(widget.profilePic),
                show: true,
                isImageAsset: false,
                ontap: () => pickImage(ImageSource.gallery),
              ),
              const SizedBox(height: 15),
              const Divider(),
              UserInfoEditField(
                text: "Name",
                child: _buildTextField(
                  controller: nameController,
                  enabled: true,
                  hint: "Name",
                ),
              ),
              UserInfoEditField(
                text: "Email",
                child: _buildTextField(
                  controller: emailController,
                  enabled: false,
                  hint: "Enter your email",
                ),
              ),
              UserInfoEditField(
                text: "Phone",
                child: _buildTextField(
                  controller: phoneController,
                  enabled: true,
                  hint: "Enter your phone number",
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: CustomRoundButton(
                  onPressed: saveProfile,
                  textColor: Colors.white,
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Save Update",
                          style: MyTextStyle.smallText(context,
                              color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool enabled,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0 * 1.5, vertical: 16.0),
        hintText: hint,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      validator: (value) {
        // Name validation
        if (controller == nameController) {
          if (value == null || value.isEmpty) {
            return "Name cannot be empty";
          }
          if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
            return "Name must contain only letters and spaces";
          }
        }

        // Email validation
        if (controller == emailController) {
          if (value == null || value.isEmpty) {
            return "Email cannot be empty";
          }
          if (!RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
          ).hasMatch(value)) {
            return "Enter a valid email address";
          }
        }

        // Phone validation
        if (controller == phoneController) {
          if (value == null || value.isEmpty) {
            return "Phone number cannot be empty";
          }
          if (!RegExp(r"^\d{10}$").hasMatch(value)) {
            return "Enter a valid 10-digit phone number";
          }
        }

        return null; // No validation errors
      },
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}
