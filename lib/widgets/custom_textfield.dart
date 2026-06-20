import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final bool isHidden;
  final VoidCallback? togglePassword;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.isHidden = false,
    this.togglePassword,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,

      obscureText: isPassword ? isHidden : false,

      style: AppTextStyle.small.copyWith(color: AppColors.black),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyle.small,

        filled: true,
        fillColor: AppColors.white,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),

        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility),
                onPressed: togglePassword,
              )
            : null,
      ),
    );
  }
}
