
import 'package:flutter/material.dart';
import 'package:conju_app/constants/color_constant.dart';


class InteractiveIntroPopup extends StatelessWidget {
  final List<Map<String, dynamic>> demoData;
  final VoidCallback onGetStarted;

  const InteractiveIntroPopup({
    super.key,
    required this.demoData,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);
    final PageController pageController = PageController();

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: demoData.length,
                onPageChanged: (value) {
                  currentPageNotifier.value = value;
                },
                itemBuilder: (context, index) {
                  var data = demoData[index];
                  return OnboardContent(
                    illustration: data["illustration"] ?? '',
                    title: data["title"] ?? '',
                    text: data["text"] ?? '',
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Progress Tracker and Button
            ValueListenableBuilder<int>(
              valueListenable: currentPageNotifier,
              builder: (context, currentPage, child) {
                return Column(
                  children: [
                    // Dot indicators for page tracking
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        demoData.length,
                        (index) => DotIndicator(
                          isActive: index == currentPage,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: currentPage == demoData.length - 1
                          ? onGetStarted
                          : () {
                              // Navigate to the next page
                              pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                              currentPageNotifier.value++;
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        currentPage == demoData.length - 1
                            ? "Get Started".toUpperCase()
                            : "Next".toUpperCase(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
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
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.activeColor = AppColors.primaryColor,
    this.inActiveColor = AppColors.highlightGrey,
  });

  final bool isActive;
  final Color activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 5,
      width: isActive ? 10 : 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor.withOpacity(0.25),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}
