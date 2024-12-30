
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/auth/sign_in.dart';
import 'package:conju_app/widgets/text_field/text_form_field.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showpassword = false;
  bool showconfirmpassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LogoWithTitle(
        title: "Change Password",
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomInputField(
                  fillColor: const Color(0xFFF5FCF9),
                  filled: true,
                  obscureText: showpassword,
                  onSuffixTap: () {
                    setState(() {
                      showpassword = !showpassword;
                    });
                  },
                  suffixIcon: "assets/svgs/eye.svg",
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0 * 1.5, vertical: 16.0),
                  hintText: "Confirm Password",
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: CustomInputField(
                    fillColor: const Color(0xFFF5FCF9),
                    filled: true,
                    obscureText: showconfirmpassword,
                    onSuffixTap: () {
                      setState(() {
                        showconfirmpassword = !showconfirmpassword;
                      });
                    },
                    suffixIcon: "assets/svgs/eye.svg",
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0 * 1.5, vertical: 16.0),
                    hintText: "Password",
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: const StadiumBorder(),
            ),
            child: const Text("Change Password"),
          ),
          TextButton(
            onPressed: () {
              Get.to(const SignInScreen());
            },
            child: Text.rich(
              TextSpan(
                text: "Already have an account? ",
                children: [
                  TextSpan(
                    text: "Sign in",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.64),
                  ),
            ),
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
