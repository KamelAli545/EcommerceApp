import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/model/cartItem.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/product_image.dart';

class CartItemTile extends StatelessWidget {
  const CartItemTile({super.key, required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final cart = context.read<CartCubit>();
    final canIncrease = item.quantity < p.stock;

    // التحقق من حالة الثيم الحالي لتحديد الألوان بدقة
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkInk : AppColors.ink;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.muted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            height: 92,
            child: ProductImage(url: p.imageUrl, title: p.title),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.25,
                          color: textColor, // لون نص متكيف مع الثيم
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove ${p.title}',
                      icon: Icon(Icons.close, color: mutedColor),
                      onPressed: () => cart.remove(p.id),
                    ),
                  ],
                ),
                Text(
                  '\$${p.price.toStringAsFixed(2)} each',
                  style: TextStyle(color: mutedColor, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton.outlined(
                      tooltip: 'Decrease quantity',
                      icon: Icon(Icons.remove, size: 18, color: textColor),
                      onPressed: () => cart.decrease(p.id),
                    ),
                    SizedBox(
                      width: 36,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      tooltip: canIncrease
                          ? 'Increase quantity'
                          : 'No more in stock',
                      icon: Icon(Icons.add, size: 18, color: textColor),
                      onPressed:
                      canIncrease ? () => cart.increase(p.id) : null,
                    ),
                    const Spacer(),
                    Text(
                      '\$${item.subtotal.toStringAsFixed(2)}',
                      style: AppText.price(size: 16).copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}