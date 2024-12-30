import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/services/firebase_services/auth_services.dart';
import 'package:conju_app/widgets/text_field/text_form_field.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LogoWithTitle(
        title: 'Forgot Password',
        subText: "Reset password link will be shared to your email",
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Form(
              key: _formKey,
              child: CustomInputField(
                fillColor: const Color(0xFFF5FCF9),
                filled: true,
                textController: emailController,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0 * 1.5, vertical: 16.0),
                hintText: "Email Address",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isloading = true;
                // ignore: unrelated_type_equality_checks
                if (emailController.text != '' && emailController.text != '') {
                  FirebaseAuthServices().resetPassword(
                    emailController.text.trim(),
                  );
                  isloading = false;
                } else {
                  isloading = true;
                  Get.snackbar(
                      "Fields are Empty", 'Fill the email field to proceed');
                  isloading = false;
                }
              });
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
            child: isloading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text("Next"),
          ),
        ],
      ),
    );
  }
}

class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle(
      {super.key,
      required this.title,
      this.subText = '',
      required this.children});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.1),
              Image.asset(
                "assets/logo.png",
                height: 100,
              ),
              SizedBox(
                height: constraints.maxHeight * 0.1,
                width: double.infinity,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.64),
                  ),
                ),
              ),
              ...children,
            ],
          ),
        );
      }),
    );
  }
}
