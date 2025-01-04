import 'package:flutter/material.dart';
import 'package:conju_app/constants/color_constant.dart';

class CustomExpansionTileWidget extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final Widget? trailing;
  final Widget? subtitle;
  final List<Widget> children;
  final Color? backgroundColor;
  final Alignment? expandedAlignment;
  final EdgeInsetsGeometry? childrenPadding;
  const CustomExpansionTileWidget({
    super.key,
    required this.title,
    this.leading,
    this.expandedAlignment,
    this.childrenPadding,
    this.subtitle,
    this.backgroundColor,
    this.trailing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.skyColor,
            borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          title: title,
          shape: Border.all(color: Colors.transparent),
          leading: leading,
          expandedAlignment: expandedAlignment,
          trailing: trailing,
          subtitle: subtitle,
          childrenPadding: childrenPadding,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: AppColors.borderLite,
              ),
            ),
            Column(
              children: children,
            )
          ],
        ));
  }
}
