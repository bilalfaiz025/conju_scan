import 'package:conju_app/constants/color_constant.dart';
import 'package:flutter/material.dart';

class BorderedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle? style;
  final Color? textColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final Color? color;
  final Color? borderColor;
  final double? elevation;
  final FontWeight? fontWeight;

  const BorderedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.style,
    this.textColor,
    this.color,
    this.borderColor,
    this.verticalPadding,
    this.fontWeight,
    this.horizontalPadding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size;
    return ElevatedButton(
      onPressed: onPressed,
      style: style ??
          ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 16),
            backgroundColor: AppColors.white,
            elevation: elevation,
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding ?? 12,
                horizontal: horizontalPadding ?? 60),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(h.height * 0.2),
                side: BorderSide(
                    color: borderColor ?? AppColors.black, width: 1)),
          ),
      child: Text(
        text,
        style: TextStyle(
            color: textColor ?? AppColors.black, fontWeight:fontWeight?? FontWeight.bold),
      ),
    );
  }
}
