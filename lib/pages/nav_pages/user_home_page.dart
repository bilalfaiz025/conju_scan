import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/prediction_page/prediction_page.dart';
import 'package:conju_app/viewModel/prediction_vm.dart';
import 'package:conju_app/widgets/others/custom_preview.dart';
import 'package:conju_app/widgets/slider/auto_slider.dart';
import 'package:conju_app/widgets/others/small_check.dart';
import 'package:equal_space/equal_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? image;

  String userName = "Guest";

  @override
  void initState() {
    super.initState();
    image == null;
    _fetchUserNameFromFirestore();
  }

  Future<void> _fetchUserNameFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userName = userDoc.data()?['name'] ?? "Guest";
          });
        } else {
          setState(() {
            userName = "Guest";
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
      setState(() {
        userName = "Guest";
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  Future<String?> convertImageToBase64(File? image) async {
    if (image == null) return null;
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final List<SliderItem> sliderItems = [
      SliderItem(
        title: "Do You Know?",
        subtitle: "Conjunctivitis?",
        imageUrl:
            "https://drbishop.com/wp-content/uploads/2023/03/How-To-Tell-The-Difference-Between-Pink-Eye-Styes-Hero.jpg",
        buttonText: "Know More",
      ),
      SliderItem(
        title: "Did you know?",
        subtitle: "Eye Care Tips",
        imageUrl: "https://s3.envato.com/files/266906941/DSC_97274.jpg",
        buttonText: "Learn More",
      ),
      SliderItem(
        title: "Healthy Eyes",
        subtitle: "Prevention of Eye Diseases",
        imageUrl:
            "https://i.pinimg.com/736x/c5/16/ff/c516ff9163fefeaa5974fc7c8855cd02.jpg",
        buttonText: "Get Started",
      ),
    ];
    final PredictionViewModel predictionViewModel =
        Provider.of<PredictionViewModel>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SpacedColumn(
              space: MediaQuery.sizeOf(context).height * 0.02,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome message
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: "Welcome ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      TextSpan(
                        text: userName,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Color(0xFF00BF6D),
                        ),
                      ),
                    ],
                  ),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                ),
                // Auto slider
                AutoSlidingContainer(
                  sliderItems: sliderItems,
                  onTap: () {
                    launchUrl(Uri.parse(
                        "https://info.health.nz/conditions-treatments/eyes/conjunctivitis"));
                  },
                ),
                // Diagnosis prompt
                Text(
                  "Get Your Diagnosis Instantly!",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .color!
                            .withOpacity(0.64),
                      ),
                ),
                // Gallery and Camera buttons
                image != null
                    ? Column(
                        children: [
                          CustomPreviewWidget(
                            image: image!,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: SmallCheckWidget(
                                  icon: Icons.cancel_outlined,
                                  title: 'Cancel',
                                  color: Colors.amber,
                                  onTap: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: SmallCheckWidget(
                                  icon: Icons.done_all_rounded,
                                  title: 'Upload',
                                  onTap: () async {
                                    if (image != null) {
                                      Get.snackbar("Predicting",
                                          "Image is being Uploaded");
                                      await predictionViewModel
                                          .getPredictData(image!.path);
                                      print(
                                          "response here ${predictionViewModel.modelData.first.confidence}");
                                      Get.to(PredictionPage(
                                        modeldata:
                                            predictionViewModel.modelData,
                                        image: image,
                                      ));
                                    } else {
                                      // Show an error message if no image was selected
                                      Get.snackbar(
                                          "Error", "Select an Image first");
                                    }
                                  },
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    : Column(
                        children: [
                          _buildActionButton(
                            iconPath: "assets/svgs/gallery.svg",
                            label: "Gallery",
                            onTap: () => pickImage(ImageSource.gallery),
                          ),
                          const SizedBox(height: 10),
                          _buildActionButton(
                            iconPath: "assets/svgs/camera.svg",
                            label: "Camera",
                            onTap: () => pickImage(ImageSource.camera),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: AppColors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.mediumAquarine.withOpacity(0.9),
              const Color.fromARGB(255, 15, 21, 109).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mediumAquarine.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 30,
              width: 30,
              // ignore: deprecated_member_use
              color: AppColors.white,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
