import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/theme/app_theme.dart';

// زرار تبديل الوضع الفاتح والداكن، بيغيّر الثيم بأنيميشن دائري
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeSwitcher(
      clipper: const ThemeSwitcherCircleClipper(),
      builder: (switcherContext) {
        return IconButton(
          tooltip: isDark ? 'Light mode' : 'Dark mode',
          icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
          onPressed: () {
            ThemeSwitcher.of(switcherContext).changeTheme(
              theme: isDark ? AppTheme.light() : AppTheme.dark(),
            );
          },
        );
      },
    );
  }
}