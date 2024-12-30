import 'dart:async';
import 'package:conju_app/constants/color_constant.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoSlidingContainer extends StatelessWidget {
  final List<SliderItem> sliderItems;
  final Duration autoSlideInterval;
  final Function()? onTap;

  const AutoSlidingContainer({
    super.key,
    required this.sliderItems,
    required this.onTap,
    this.autoSlideInterval = const Duration(seconds: 5),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: _AutoSlidingContainer(
        sliderItems: sliderItems,
        autoSlideInterval: autoSlideInterval,
      ),
    );
  }
}

class SliderItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String buttonText;

  SliderItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.buttonText,
  });
}

class _AutoSlidingContainer extends StatefulWidget {
  final List<SliderItem> sliderItems;
  final Duration autoSlideInterval;

  const _AutoSlidingContainer({
    required this.sliderItems,
    required this.autoSlideInterval,
  });

  @override
  State<_AutoSlidingContainer> createState() => _AutoSlidingContainerState();
}

class _AutoSlidingContainerState extends State<_AutoSlidingContainer> {
  final PageController _pageController = PageController();
  late Timer _autoSlideTimer;
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    // Timer for auto-slide
    _autoSlideTimer = Timer.periodic(widget.autoSlideInterval, (timer) {
      if (_pageController.hasClients) {
        final nextPage =
            (currentPageNotifier.value + 1) % widget.sliderItems.length;
        currentPageNotifier.value = nextPage;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer.cancel();
    currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250, // Adjust height based on your design
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.sliderItems.length,
            itemBuilder: (context, index) {
              return ReusableSliderContainer(
                  sliderItem: widget.sliderItems[index]);
            },
            onPageChanged: (index) {
              currentPageNotifier.value = index;
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots indicator
        ValueListenableBuilder<int>(
          valueListenable: currentPageNotifier,
          builder: (context, currentPage, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.sliderItems.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentPage == index ? 16 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? AppColors.primaryColor
                        : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }
}

class ReusableSliderContainer extends StatelessWidget {
  final SliderItem sliderItem;

  const ReusableSliderContainer({super.key, required this.sliderItem});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image with Border Radius
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage(sliderItem.imageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4),
                BlendMode.darken,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title and Subtitle with Gradient Overlay
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sliderItem.title,
                    style: GoogleFonts.overpass(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sliderItem.subtitle,
                    style: GoogleFonts.libreBaskerville(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              // Button
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    // Add your button functionality here
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      sliderItem.buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DoYouKnowText extends StatelessWidget {
  final String title;
  final String subtitle;

  const DoYouKnowText({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "$title\n",
              style: GoogleFonts.overpass(
                decorationStyle: TextDecorationStyle.solid,
              ),
            ),
            TextSpan(
              text: subtitle,
              style: GoogleFonts.libreBaskerville(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
