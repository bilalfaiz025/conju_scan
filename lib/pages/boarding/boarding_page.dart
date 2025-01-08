import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/auth/sign_in.dart';
import 'package:conju_app/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InteractiveIntroScreen extends StatefulWidget {
  const InteractiveIntroScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InteractiveIntroScreenState createState() => _InteractiveIntroScreenState();
}

class _InteractiveIntroScreenState extends State<InteractiveIntroScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Listen to page changes and update the state accordingly
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPage != page) {
        setState(() {
          _currentPage = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final demoData = [
      {
        "illustration": "assets/eye.png",
        "title": "What is Conjunctivitis",
        "text":
            "Conjunctivitis is an inflammation of the conjunctiva, causing redness, irritation, and discharge in the eyes.",
      },
      {
        "illustration": "assets/phone_eye.png",
        "title": "What We Offer",
        "text":
            "Instantly diagnose eye conditions, and access expert consultations and tailored treatment recommendations.",
      },
      {
        "illustration": "assets/health_smile.png",
        "title": "Why Choose Us",
        "text":
            "Experience accurate diagnoses, save time with immediate results, and receive trusted medical advice all in one place.",
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: demoData.length,
                    itemBuilder: (context, index) {
                      var data = demoData[index];
                      return OnboardContent(
                        illustration: data["illustration"]!,
                        title: data["title"]!,
                        text: data["text"]!,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Progress Tracker and Button
                Column(
                  children: [
                    // Dot indicators for page tracking
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        demoData.length,
                        (index) =>
                            DotIndicator(isActive: index == _currentPage),
                      ),
                    ),
                    const SizedBox(height: 16),
                    NextButton(
                      isLastPage: _currentPage == demoData.length - 1,
                      onNext: () {
                        if (_currentPage == demoData.length - 1) {
                          Get.to(const SignInScreen());
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: TextButton(
              onPressed: () => Get.to(
                  const SignInScreen()), // Skip and go to the next screen
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.text,
  });

  final String illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              illustration,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Text(
          title,
          style: MyTextStyle.largeText(context,
              isBold: true, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: MyTextStyle.smallText(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator(
      {super.key,
      this.isActive = false,
      this.activeColor = AppColors.primaryColor,
      this.inActiveColor = AppColors.highlightGrey});

  final bool isActive;
  final Color activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 10,
      width: isActive ? 12 : 10,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor.withOpacity(0.25),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}

class NextButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onNext;

  const NextButton({super.key, required this.isLastPage, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onNext,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        isLastPage ? "Get Started".toUpperCase() : "Next".toUpperCase(),
      ),
    );
  }
}
