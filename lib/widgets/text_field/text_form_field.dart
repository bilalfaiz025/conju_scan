import 'package:conju_app/constants/color_constant.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController? textController;
  final TextInputType? keyboardType;
  final int? maxlines;
  final bool? isDisable;
  final String? hintText;
  final bool? obscureText;
  final double? sizeSuffixIcon;
  final VoidCallback? onSuffixTap;
  final Widget? suffix;
  final String? suffixIcon;
  final bool filled;
  final Color? fillColor;
  final FormFieldValidator<String>? validator;
  final bool? showBorder;
  final IconData? iconForSuffix;
  final void Function()? onEditingComplete;
  final String? suffixText;
  final TextStyle? suffixStyle;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onChanged;
  final int? maxLength;
  final String? counterText;
  final List<TextInputFormatter>? inputFormatters;

  const CustomInputField({
    this.textController,
    this.keyboardType,
    this.onChanged,
    this.suffix,
    this.showBorder = true,
    this.onSuffixTap,
    this.maxLength,
    this.isDisable,
    this.counterText,
    this.filled = true,
    this.inputFormatters,
    this.onEditingComplete,
    this.sizeSuffixIcon,
    this.contentPadding,
    this.validator,
    this.suffixStyle,
    this.fillColor,
    this.suffixText,
    this.suffixIcon,
    this.obscureText,
    this.hintText,
    this.maxlines,
    this.iconForSuffix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.sizeOf(context).height;
    return TextFormField(
      cursorColor: AppColors.secondaryColor,
      controller: textController,
      maxLines: maxlines ?? 1,
      keyboardType: keyboardType,
      obscureText: obscureText ?? false,
      obscuringCharacter: '*',
      validator: validator,
      onChanged: onChanged,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      readOnly: isDisable ?? false,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        counterText: counterText,
        fillColor: fillColor ?? Colors.white,
        filled: filled,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .color!
                  .withOpacity(0.64),
            ),
        suffixText: suffixText,
        suffixStyle: suffixStyle,
        suffixIcon: iconForSuffix != null
            ? InkWell(
                onTap: onSuffixTap,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(iconForSuffix),
                ),
              )
            : suffixIcon != null
                ? InkWell(
                    onTap: onSuffixTap,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: obscureText == false
                          ? SvgPicture.asset(suffixIcon!)
                          : const Icon(Icons.remove_red_eye_outlined),
                    ),
                  )
                : const SizedBox(),
        suffix: suffix,
        suffixIconConstraints: BoxConstraints(
          maxHeight: sizeSuffixIcon ?? h * 0.09,
        ),
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      ),
    );
  }
}
