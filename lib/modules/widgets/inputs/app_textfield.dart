import 'package:flutter/material.dart';

import '../../../common/colors.dart';
import '../../../common/sizes.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? labelText;
  final Widget? suffix;
  final Widget? prefix;
  final bool isPassword;
  final Key? textFieldKey;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String Function(String?)? validator;
  final Function(String?)? onChanged;
  final String? initialValue;
  final bool isDisabled;
  final Widget? suffixIcon;
  final bool readOnly;
  final TextEditingController? controller;

  const CustomTextField({
    Key? key,
    this.textFieldKey,
    required this.hintText,
    this.labelText,
    this.suffixIcon,
    this.suffix,
    this.prefix,
    this.keyboardType,
    this.controller,
    this.isPassword = false,
    this.maxLines,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.isDisabled = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
              key: textFieldKey,
              autovalidateMode: AutovalidateMode.always,
              controller: controller,
              enabled: !isDisabled,
              obscureText: isPassword,
              validator: validator,
              onChanged: onChanged,
              cursorColor: AppColors.hintTextColor,
              maxLines: isPassword ? 1 : maxLines,
              maxLength: maxLength,
              keyboardType: keyboardType,
              readOnly: readOnly,
              style: const TextStyle(
                fontSize: EmSizes.fontSizeSm,
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor,
              ),
              decoration: InputDecoration(
                prefixIcon: prefix,
                suffixIcon: suffix,
                hintText: hintText,
                labelText: labelText,
                hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.hintTextColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(EmSizes.borderRadiusLg),
                    borderSide: BorderSide(
                        color: AppColors.blackColor.withValues(alpha: 0.3))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(EmSizes.borderRadiusLg),
                    borderSide: BorderSide(
                        color: AppColors.blackColor.withValues(alpha: 0.3))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(EmSizes.borderRadiusLg),
                    borderSide: BorderSide(
                        color: AppColors.blackColor.withValues(alpha: 0.3))),
                // fillColor: fillColor,
                // filled: true,
              ),
              textInputAction: TextInputAction.search,
            )
    );
  }
}
