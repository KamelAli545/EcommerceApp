import 'package:flutter/material.dart';
import 'package:nexshop/theme/app_theme.dart';

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? (isDark ? Colors.white24 : Colors.white.withOpacity(0.15))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : Colors.white70,
              size: 26,
            ),
            if (showDot)
              const Positioned(
                right: -2,
                top: -2,
                child: CircleAvatar(
                  radius: 4,
                  backgroundColor: AppColors.alert,
                ),
              ),
          ],
        ),
      ),
    );
  }
}