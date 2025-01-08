import 'package:conju_app/constants/color_constant.dart';
import 'package:flutter/material.dart';

class SmallCheckWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Function()? onTap;
  final double? height;
  final Color? iconColor;
  final TextStyle? txtstyle;
  const SmallCheckWidget(
      {super.key,
      required this.color,
      required this.icon,
      required this.onTap,
      this.height,
      this.iconColor,
      this.txtstyle,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          height: height ?? 30,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLite)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                title,
                style: txtstyle,
              )
            ],
          )),
    );
  }
}
