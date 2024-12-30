import 'package:conju_app/constants/color_constant.dart';
import 'package:conju_app/widgets/text_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomeTileWidget extends StatelessWidget {
  final Widget? leading;
  final Widget? trailing;
  final Widget? subTitle;
  final Widget? titleWidget;
  final String? title;
  final String? time;
  final TextStyle? style;
  final VoidCallback? onTap;
  final bool showTime;
  final bool showDivider;
  final Color? boxColor;
  final BorderRadiusGeometry? borderRadius;
  const CustomeTileWidget(
      {this.leading,
      this.style,
      this.subTitle,
      this.showTime = false,
      this.onTap,
      this.time,
      this.title,
      this.boxColor,
      this.titleWidget,
      this.borderRadius,
      this.showDivider = true,
      this.trailing,
      super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: boxColor, borderRadius: borderRadius),
        child: Column(
          children: [
            Stack(
              children: [
                showTime
                    ? Positioned(
                        right: h * 0.02,
                        top: h * 0.012,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(time ?? '',
                                style: MyTextStyle.miniText(
                                  context,
                                  color: AppColors.borderSide,
                                ))))
                    : const SizedBox(),
                ListTile(
                  leading: leading,
                  title: titleWidget ??
                      Text(
                        title ?? '',
                        style: style,
                      ),
                  subtitle: subTitle,
                  trailing: trailing ??
                      SvgPicture.asset('assets/user_profile/forward_icon.svg'),
                ),
              ],
            ),
            showDivider == true
                ? Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: AppColors.borderLite, width: 1.0),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
