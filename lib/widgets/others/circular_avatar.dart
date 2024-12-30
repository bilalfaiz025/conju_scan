import 'package:conju_app/constants/color_constant.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class CustomProfileAvatar extends StatelessWidget {
  final VoidCallback? ontap;
  final ImageProvider<Object> image;
  final double? radius;
  final bool? show;
  final bool? isImageAsset;
  final Widget? icon;
  final Color? backgroundColorIcon;
  final Color? borderColorIcon;
  final double? borderIconWidth;

  final double? height;
  final double? width;
  final double? imageHeight;
  final double? imageWidth;
  final double? topPaddingIcon;
  final double? rightPaddingIcon;

  const CustomProfileAvatar(
      {this.ontap,
      this.show,
      this.radius,
      this.borderColorIcon,
      this.borderIconWidth,
      required this.image,
      this.backgroundColorIcon,
      this.height,
      this.width,
      this.imageHeight,
      this.rightPaddingIcon,
      this.topPaddingIcon,
      this.imageWidth,
      this.isImageAsset = true,
      this.icon,
      super.key});
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    return SizedBox(
      child: Stack(
        children: [
          Container(
            height: imageHeight ?? h * 0.15,
            width: imageWidth ?? h * 0.15,
            decoration: BoxDecoration(
                color: AppColors.darkBlue,
                border: Border.all(color: AppColors.greylite),
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                )),
          ),
          show == true
              ? Positioned(
                  bottom: -h * 0.018,
                  right: -h * 0.018,
                  child: SizedBox(
                      child: IconButton(
                          onPressed: ontap,
                          icon: icon ??
                              const Icon(
                                CupertinoIcons.add_circled_solid,
                                color: AppColors.secondaryColor,
                              ))))
              : const SizedBox(),
        ],
      ),
    );
  }
}
