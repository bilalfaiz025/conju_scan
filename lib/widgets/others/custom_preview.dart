import 'dart:io';

import 'package:conju_app/constants/color_constant.dart';
import 'package:flutter/material.dart';

class CustomPreviewWidget extends StatelessWidget {
  final File image;
  const CustomPreviewWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: FileImage(
                image,
              ),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLite)),
    );
  }
}
