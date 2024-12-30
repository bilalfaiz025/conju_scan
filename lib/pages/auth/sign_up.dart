import 'dart:io';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/services/firebase_services/auth_services.dart';
import 'package:conju_app/pages/auth/sign_in.dart';
import 'package:conju_app/widgets/others/circular_avatar.dart';
import 'package:conju_app/widgets/text_field/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  bool showPassword = true;
  bool isLoading = false;
  File? image;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      } else {
        Get.snackbar("No Image Selected", "Please choose an image.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick an image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              CustomProfileAvatar(
                image: image != null
                    ? FileImage(image!) as ImageProvider<Object>
                    : const AssetImage("assets/logo.png"),
                show: true,
                isImageAsset: false,
                ontap: () => pickImage(ImageSource.gallery),
              ),
              const SizedBox(height: 24),
              Text(
                "Create Account",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomInputField(
                      fillColor: const Color(0xFFF5FCF9),
                      filled: true,
                      textController: nameController,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      hintText: "Full name",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      fillColor: const Color(0xFFF5FCF9),
                      filled: true,
                      textController: emailController,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      hintText: "Email address",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        } else if (!RegExp(r'\S+@\S+\.\S+')
                            .hasMatch(value.trim())) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      fillColor: const Color(0xFFF5FCF9),
                      filled: true,
                      keyboardType: TextInputType.phone,
                      textController: phoneController,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      hintText: "Phone number",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your phone number";
                        } else if (!RegExp(r'^\d{10,}$')
                            .hasMatch(value.trim())) {
                          return "Enter a valid phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomInputField(
                      fillColor: const Color(0xFFF5FCF9),
                      filled: true,
                      textController: passwordController,
                      obscureText: showPassword,
                      onSuffixTap: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      suffixIcon: "assets/svgs/eye.svg",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0),
                      hintText: "Password",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a password";
                        } else if (value.length < 6) {
                          return "Password must be at least 6 characters long";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (image == null) {
                          Get.snackbar("Image Missing",
                              "Please select an image to proceed.");
                          return; // Exit the function if no image is selected
                        }
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true; // Set loading state to true
                          });

                          // Simulate an async operation (e.g., Firebase sign-up)
                          FirebaseAuthServices()
                              .signup(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            image,
                            nameController.text.trim(),
                            phoneController.text.trim(),
                          )
                              .then((_) {
                            setState(() {
                              isLoading =
                                  false; // Set loading state to false after operation
                            });
                          }).catchError((e) {
                            setState(() {
                              isLoading = false;
                            });
                            Get.snackbar("Error", e.toString());
                          });
                        } else {
                          Get.snackbar("Validation Failed",
                              'Please fill all fields correctly.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Sign up"),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const SignInScreen());
                      },
                      child: Text.rich(
                        const TextSpan(
                          text: "Already have an account? ",
                          children: [
                            TextSpan(
                              text: "Sign in",
                              style: TextStyle(color: Color(0xFF00BF6D)),
                            ),
                          ],
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
