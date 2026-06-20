import 'package:flutter/material.dart';
import 'package:simba_app/theme/app_colors.dart';

class AppTextStyle {
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const subtitle = TextStyle(fontSize: 16, color: AppColors.black);

  static const tittlecard = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const bold = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  static const small = TextStyle(fontSize: 12, color: AppColors.black);

  static const hint = TextStyle(fontSize: 12, color: AppColors.hintColor);
}
