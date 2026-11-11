import 'package:flutter/material.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/theme/app_theme.dart';

// ملخص الكارت: عدد القطع والإجمالي، وبيوصّل للكارت لما نضغط عليه
class CartSummary extends StatelessWidget {
  const CartSummary({super.key, required this.cart, required this.onTap});

  final CartState cart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          // في الـ Dark Mode نخلي الخلفية متناسقة مع الشريط، وفي الفاتح AppColors.ink
          color: isDark ? AppColors.navSelected : AppColors.ink,
          borderRadius: BorderRadius.circular(30),
          // إطار خفيف في الوضع الليلي
          border: isDark
              ? Border.all(color: AppColors.darkHairline, width: 1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: isDark ? AppColors.darkInk : AppColors.paper,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${cart.totalItems} items',
                style: TextStyle(
                  color: isDark ? AppColors.darkInk : AppColors.paper,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              '\$${cart.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(
                color: isDark ? AppColors.darkInk : AppColors.paper,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}