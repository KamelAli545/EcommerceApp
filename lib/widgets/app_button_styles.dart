import 'package:flutter/material.dart';
import 'package:nexshop/theme/app_theme.dart';

// ستايل الزراير الموحد في التطبيق كله، عشان الـ radius والأبعاد يبقوا متناسقين
class AppButtonStyles {
  AppButtonStyles._();

  static const double radius = 15;
  static const Size minSize = Size.fromHeight(50);

  static final RoundedRectangleBorder shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(radius),
  );

  // زرار ممتلي. لو مفيش background مخصص، بياخد لون ink في الفاتح وفاتح في الدارك
  static ButtonStyle filled(bool isDark, {Color? background}) {
    final isCustom = background != null;
    return ElevatedButton.styleFrom(
      backgroundColor:
      background ?? (isDark ? AppColors.darkInk : AppColors.ink),
      foregroundColor: isCustom
          ? AppColors.paper
          : (isDark ? AppColors.darkPaper : AppColors.paper),
      elevation: 0,
      minimumSize: minSize,
      shape: shape,
    );
  }

  // زرار بإطار
  static ButtonStyle outlined(bool isDark) {
    return OutlinedButton.styleFrom(
      foregroundColor: isDark ? AppColors.darkInk : AppColors.ink,
      side: BorderSide(
        color: isDark ? AppColors.darkHairline : AppColors.hairline,
      ),
      minimumSize: minSize,
      shape: shape,
    );
  }
}