import 'package:conju_app/constants/color_constant.dart';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomRoundButton extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Color? textColor;
   bool? isNotBold = false;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Color? color;
  final Widget? child;
  final Color? borderColor;
  final double? elevation;

   CustomRoundButton({super.key, 
    
    this.text,
    required this.onPressed,
    this.style,
    this.textColor,
    this.borderColor,
    this.color,
    this.isNotBold,
    this.elevation,
    this.child,
    this.verticalPadding,
    this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            elevation: elevation??2,
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? 12,
                horizontal: horizontalPadding ?? 40),
            backgroundColor: color ?? AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: borderColor ?? Colors.transparent),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
      child: child ??
          Text(
            text ?? "",
            style: TextStyle(
                color: textColor ?? AppColors.white,
                fontWeight: isNotBold==true?  FontWeight.normal:FontWeight.w500),
          ),
    );
  }
}
