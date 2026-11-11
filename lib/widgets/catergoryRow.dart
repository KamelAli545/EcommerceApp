import 'package:flutter/material.dart';
import 'package:nexshop/theme/app_theme.dart';

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.categories,
    required this.selected,
    required this.onTap,
  });

  // Category names built from the products in Firestore
  final List<String> categories;

  // The selected category, or null for "All"
  final String? selected;

  final ValueChanged<String?> onTap;

  @override
  Widget build(BuildContext context) {
    // "All" is always the first item and uses null as its value
    final items = <String?>[null, ...categories];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, i) {
          final value = items[i];
          final isSelected = value == selected;

          return GestureDetector(
            onTap: () => onTap(value),
            child: Column(
              children: [
                CategoryAvatar(value: value, isSelected: isSelected),
                const SizedBox(height: 6),
                SizedBox(
                  width: 72,
                  child: Text(
                    value ?? 'All',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? (isDark ? AppColors.darkInk : AppColors.ink)
                          : (isDark ? AppColors.darkMuted : AppColors.muted),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    super.key,
    required this.value,
    required this.isSelected,
  });

  // null means the "All" tile
  final String? value;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final name = value?.trim() ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // تحديد الألوان بناءً على الثيم الحالي (Light / Dark)
    final borderColor = isSelected
        ? (isDark ? AppColors.darkInk : AppColors.ink)
        : Colors.transparent;

    final backgroundColor = isDark ? AppColors.darkImageWell : AppColors.imageWell;

    final contentColor = isDark ? AppColors.darkInk : AppColors.ink;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: backgroundColor,
        child: value == null
            ? Icon(Icons.apps, color: contentColor, size: 28)
            : Text(
          name.isEmpty ? '?' : name[0].toUpperCase(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: contentColor,
          ),
        ),
      ),
    );
  }
}