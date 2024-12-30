import 'package:flutter/material.dart';

class MyTextStyle {
  static TextStyle miniText(BuildContext context,
      {Color? color,
      bool? isBold,
      bool? isUnderlin,
      fontWeight,
      double? letterSpacing}) {
    var h = MediaQuery.of(context).size.height;
    return TextStyle(
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: h * 0.014,
      color: color,
      letterSpacing: letterSpacing,
      decoration:
          isUnderlin == true ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle customStyle(BuildContext context, {Color? color}) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        );
  }

  static TextStyle smallText(BuildContext context,
      {Color? color,
      bool? isBold,
      bool? isUnderlin,
      fontWeight,
      double? letterSpacing}) {
    var h = MediaQuery.of(context).size.height;
    return TextStyle(
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: h * 0.018,
      color: color,
      letterSpacing: letterSpacing,
      decoration:
          isUnderlin == true ? TextDecoration.underline : TextDecoration.none,
    );
  }

  static TextStyle largeText(BuildContext context,
      {Color? color, bool? isBold, fontWeight}) {
    var h = MediaQuery.of(context).size.height;
    return TextStyle(
      fontSize: h * 0.025,
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  static TextStyle mediumText(BuildContext context,
      {Color? color, bool? isBold, fontWeight}) {
    var h = MediaQuery.of(context).size.height;
    return TextStyle(
      fontSize: h * 0.023,
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }

  static TextStyle normalText(BuildContext context,
      {Color? color, bool? isBold, fontWeight}) {
    var h = MediaQuery.of(context).size.height;
    return TextStyle(
      fontSize: h * 0.021,
      color: color,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
}
