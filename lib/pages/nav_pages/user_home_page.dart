import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/pages/nav_pages/setting/help_center.dart';
import 'package:conju_app/pages/nav_pages/setting/my_profile.dart';
import 'package:conju_app/pages/prediction_page/prediction_page.dart';
import 'package:conju_app/pages/splash_screen.dart';
import 'package:conju_app/viewModel/prediction_vm.dart';
import 'package:conju_app/widgets/botton/rounded_button.dart';
import 'package:conju_app/widgets/others/custom_preview.dart';
import 'package:conju_app/widgets/slider/auto_slider.dart';
import 'package:conju_app/widgets/text_styles.dart';
import 'package:equal_space/equal_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/firebase_services/user/user_services.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? image;
  String userName = "Guest";
  String userProfile = "";
  String userEmail = "email@example.com";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<SliderItem> sliderItems = [];
  User? userCredential = FirebaseAuth.instance.currentUser;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserNameFromFirestore();
    fetchSliderData();
  }

  Future<void> fetchSliderData() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('Slider').get();
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        return SliderItem(
          title: data['name'] ?? 'No Title',
          subtitle: data['description'] ?? 'No Description',
          imageUrl: data['image'] ?? '',
          buttonText: 'Learn More',
          buttonLink: data['link'] ?? '',
        );
      }).toList();

      setState(() {
        sliderItems = items;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching slider data: $e');
      setState(() {
        isLoading = false;
      });
    }
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
            userProfile = userDoc.data()?['profile_pic'] ?? "";
            userEmail = userDoc.data()?['email'] ?? "";
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching user name: $e");
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

  @override
  Widget build(BuildContext context) {
    final PredictionViewModel predictionViewModel =
        Provider.of<PredictionViewModel>(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.white,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SpacedColumn(
            space: MediaQuery.sizeOf(context).height * 0.02,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeText(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).height * 0.02),
                child: SpacedColumn(
                  space: MediaQuery.sizeOf(context).height * 0.02,
                  children: [
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : sliderItems.isEmpty
                            ? const Center(
                                child: Text('No slider items available'))
                            : AutoSlidingContainer(
                                sliderItems: sliderItems,
                                onTap: () async {},
                              ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Get Your Diagnosis Instantly!",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                      ),
                    ),
                    _buildImagePicker(predictionViewModel),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Recents Predictions')),
                    SizedBox(
                      height: 150,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential!.uid)
                            .collection('images')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center();
                          }
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var imageData =
                                  snapshot.data!.docs[index].get('image');
                              Timestamp firebaseTimestamp =
                                  snapshot.data!.docs[index].get('date');
                              DateTime imageName = firebaseTimestamp.toDate();
                              List<String> months = [
                                'JAN',
                                'FEB',
                                'MAR',
                                'APR',
                                'MAY',
                                'JUN',
                                'JUL',
                                'AUG',
                                'SEP',
                                'OCT',
                                'MOV',
                                'DEC'
                              ];
                              String formattedDate =
                                  "${imageName.day} ${months[imageName.month - 1]} ${imageName.year}";
                              Uint8List image =
                                  base64Decode(imageData.toString());
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.mediumAquarine),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                      leading: CircleAvatar(
                                        backgroundImage: MemoryImage(
                                            image), // Assuming the image is in base64 format
                                        radius: 30,
                                      ),
                                      title: Text(formattedDate,
                                          style:
                                              MyTextStyle.smallText(context)),
                                      subtitle: Text('Click on to review',
                                          style: MyTextStyle.miniText(context)),
                                      onTap: () {
                                        _showImageDialog(context, image);
                                      },
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.download),
                                            onPressed: () {
                                              FirebaseUserServices()
                                                  .downloadAndOpenImage(
                                                      image); // Download the image when tapped
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            onPressed: () async {
                                              final documentId =
                                                  snapshot.data!.docs[index].id;
                                              // Update key if needed
                                              await FirebaseUserServices()
                                                  .deleteImageFromFirebase(
                                                userId: userCredential!.uid,
                                                documentId: documentId,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              );
                            },
                          );
                        },
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

  void _showImageDialog(BuildContext context, Uint8List image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(image, fit: BoxFit.cover),
          ),
        );
      },
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
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
            accountName: Text(
              userName,
              style: MyTextStyle.normalText(context, isBold: true),
            ),
            accountEmail: Text(
              userEmail,
              style: MyTextStyle.normalText(context, isBold: true),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userProfile.isNotEmpty
                  ? userProfile
                  : 'https://www.w3schools.com/w3images/avatar2.png'),
            ),
          ),
          _buildDrawerItem(Icons.manage_accounts, "Manage Account", () {
            Get.to(const MyProfileScreen());
          }),
          _buildDrawerItem(Icons.question_mark_rounded, "Help Center", () {
            Get.to(const HelpCenterScreen());
          }),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            onTap: () {
              launchUrl(Uri(
                scheme: 'mailto',
                path: 'bilalfaiz396@gmail.com',
                query: 'subject=Help in App Inquiry&body=Hello!',
              ));
            },
            title: Text(
              "Contact us",
              style: MyTextStyle.smallText(context),
            ),
          ),
          _buildDrawerItem(Icons.exit_to_app, "Logout", () {
            showModalBottomSheet(
                context: context,
                showDragHandle: true,
                backgroundColor: AppColors.white,
                builder: (context) {
                  var h = MediaQuery.sizeOf(context).height;
                  return Container(
                    height: h * 0.26,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        color: AppColors.white),
                    child: Column(
                      children: [
                        Text(
                          'Logout',
                          style: MyTextStyle.largeText(context,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Text("Are you sure you want to log out?",
                            style: MyTextStyle.normalText(
                              context,
                              color: AppColors.borderSide,
                            )),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: CustomRoundButton(
                            color: AppColors.greenish,
                            onPressed: () async {
                              FirebaseAuth.instance.signOut();
                              Get.snackbar(
                                  "Good Bye", "User signed off successfully");
                              Get.offAll(const SplashScreen());
                            },
                            horizontalPadding: h * 0.05,
                            text: 'Yes, Logout',
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: MyTextStyle.smallText(context,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500),
                            ))
                      ],
                    ),
                  );
                });
          }),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: MyTextStyle.smallText(context, isBold: true),
      ),
      onTap: onTap,
    );
  }

  Widget _buildWelcomeText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer(); // Open drawer using the key
          },
          icon: const Icon(Icons.menu),
        ),
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
      ],
    );
  }

  Widget _buildImagePicker(PredictionViewModel predictionViewModel) {
    if (image != null) {
      return Column(
        children: [
          CustomPreviewWidget(image: image!),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(Icons.replay, 'Cancel', Colors.amber, () {
                setState(() {
                  image = null;
                });
              }),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                    Icons.done_all_rounded, 'Upload', Colors.greenAccent,
                    () async {
                  if (image != null) {
                    Get.snackbar("Predicting", "Image is being uploaded");
                    await predictionViewModel.getPredictData(image!.path);
                    Get.to(PredictionPage(
                      modeldata: predictionViewModel.modelData,
                      image: image,
                    ));
                  } else {
                    Get.snackbar("Error", "Select an image first");
                  }
                }),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildActionButtonWithIcon("assets/svgs/gallery.svg", "Gallery",
              () => pickImage(ImageSource.gallery)),
          const SizedBox(height: 10),
          _buildActionButtonWithIcon("assets/svgs/camera.svg", "Camera",
              () => pickImage(ImageSource.camera)),
        ],
      );
    }
  }

  Widget _buildActionButtonWithIcon(
      String iconPath, String label, VoidCallback onTap) {
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
            SvgPicture.asset(iconPath,
                height: 30, width: 30, color: AppColors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: MyTextStyle.normalText(context,
                  fontWeight: FontWeight.w500, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: 30,
          color: AppColors.white,
        ),
      ),
    );
  }
}
