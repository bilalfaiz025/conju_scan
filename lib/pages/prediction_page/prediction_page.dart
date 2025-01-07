import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:confetti/confetti.dart';
import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/model/prediction_model.dart';
import 'package:conju_app/pages/nav_pages/doctors_page.dart';
import 'package:conju_app/pages/nav_pages/products_page.dart';
import 'package:conju_app/pages/nav_pages/user_home_page.dart';
import 'package:conju_app/widgets/botton/rounded_button.dart';
import 'package:conju_app/widgets/text_styles.dart';
import 'package:equal_space/equal_space.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PredictionPage extends StatefulWidget {
  final List<PredictionModel> modeldata;
  final File? image;

  const PredictionPage({
    required this.modeldata,
    required this.image,
    super.key,
  });

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  late final ConfettiController _confettiController;
  late final String prediction;
  late final double confidence;
  final ScreenshotController _screenshotController = ScreenshotController();
  bool showText = true;

  @override
  void initState() {
    super.initState();
    final lastPrediction =
        widget.modeldata.isNotEmpty ? widget.modeldata.last : null;
    prediction = lastPrediction?.predictedClass ?? "";
    confidence = lastPrediction?.confidence ?? 0.6;
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 4));

    if (prediction == "Normal") {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> imagesave() async {
    User? userCredential = FirebaseAuth.instance.currentUser;
    try {
      final Uint8List? uint8list = await _screenshotController.capture();
      final imageEncoded = base64Encode(uint8list!);
      await Permission.storage.request();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential!.uid)
          .collection('images')
          .add({'image': imageEncoded, 'date': DateTime.now()});

      if (uint8list.toString().isNotEmpty) {
        final PermissionStatus status =
            await Permission.manageExternalStorage.request();
        if (status.isGranted) {
          final result =
              await ImageGallerySaverPlus.saveImage(uint8list, quality: 90);
          if (result['isSuccess']) {
            Get.snackbar('Successfull', 'Image Saved Successfully"');
          } else {
            Get.snackbar('Error during saving',
                'Error in Saving Image: ${result['error']}');
          }
        } else {
          Get.snackbar('Error', 'Permission Denied for Saving Image');
        }
      } else {
        Get.snackbar('Error', 'Error in Capturing Screenshot');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Prediction Result',
          style: MyTextStyle.largeText(context,
              color: AppColors.mediumAquarine, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF41BEA6)),
        actions: [
          IconButton(
            onPressed: imagesave,
            icon: const Icon(
              Icons.save,
              color: AppColors.highlightGrey,
            ),
          )
        ],
      ),
      body: Screenshot(
        controller: _screenshotController,
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPredictionHeader(),
                      const SizedBox(height: 20),
                      _buildConfidenceIndicator(),
                      const SizedBox(height: 20),
                      _buildPredictionMessage(),
                    ],
                  ),
                ),
              ),
              if (prediction == "Normal")
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    emissionFrequency: 0.5,
                    numberOfParticles: 20,
                    gravity: 0.1,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPredictionHeader() {
    return Row(
      children: [
        Text(
          "Predicted Class:  ",
          style: MyTextStyle.mediumText(context, fontWeight: FontWeight.w600),
        ),
        Text(
          prediction,
          style: MyTextStyle.mediumText(
            context,
            color: prediction == "Normal" ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConfidenceIndicator() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          CircularPercentIndicator(
            radius: 60.0,
            lineWidth: 10.0,
            animation: true,
            percent: confidence,
            center: Text(
              "${(confidence * 100).toInt()}%",
              style: MyTextStyle.mediumText(
                context,
                fontWeight: FontWeight.bold,
              ),
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor:
                prediction == "Normal" ? AppColors.mediumAquarine : Colors.red,
          ),
          const SizedBox(height: 10),
          Text(
            "Confidence",
            style: MyTextStyle.customStyle(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionMessage() {
    if (prediction == "Normal") {
      return Center(
        child: SpacedColumn(
          space: 10,
          children: [
            Text(
              "Everything looks good! 🎉",
              style: MyTextStyle.mediumText(
                context,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomRoundButton(
                onPressed: () {},
                text: 'Learn More',
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomRoundButton(
                color: AppColors.green,
                onPressed: () {
                  Get.offAll(const UserHomePage());
                },
                text: 'Try Again',
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: SpacedColumn(
          space: 10,
          children: [
            Text(
              "Abnormal result detected\nPlease consult a doctor.",
              style: MyTextStyle.smallText(
                context,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: double.infinity,
              child: CustomRoundButton(
                color: AppColors.mediumAquarine,
                onPressed: () {
                  Get.to(const DoctorContactListScreen());
                },
                text: 'Find Doctor Nearby',
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomRoundButton(
                color: AppColors.mediumAquarine,
                onPressed: () {
                  Get.to(const ProductsScreen());
                },
                text: 'Related Medicine',
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomRoundButton(
                color: AppColors.mediumAquarine,
                onPressed: () {
                  launchUrl(Uri.parse(
                      "https://www.healthline.com/health/conjunctivitis#types-and-causes"));
                },
                text: 'Learn about disease',
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  showText = !showText;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.warning,
                    color: Colors.amber,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "Disclaimer",
                    style: MyTextStyle.normalText(context,
                        color: AppColors.black, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            if (showText)
              const Text(
                textAlign: TextAlign.justify,
                "These results are preliminary insights and should not be relied upon as a sole diagnostic tool. Always consult a healthcare professional for confirmation and treatment.",
              ),
          ],
        ),
      );
    }
  }
}
