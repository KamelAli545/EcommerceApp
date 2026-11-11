import 'package:flutter/material.dart';
import 'package:nexshop/model/product.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/price_tag.dart';
import 'package:nexshop/widgets/product_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.onTap});

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final inStock = product.stock > 0;
    final statusColor = inStock ? AppColors.inStock : AppColors.outOfStock;

    // التحقق مما إذا كان الثيم الحالي هو الوضع الداكن
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ألوان النصوص الديناميكية حسب الثيم
    final textColor = isDark ? AppColors.darkInk : AppColors.ink;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 4 / 5,
            child: ProductImage(url: product.imageUrl, title: product.title),
          ),
          const SizedBox(height: 10),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              height: 1.25,
              color: textColor, // لون ديناميكي يتغير تلقائياً
            ),
          ),
          Text(
            product.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              height: 1,
              color: isDark ? AppColors.darkMuted : AppColors.muted, // لون هادئ ومتناسق للوصف
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PriceTag(price: product.price),
              Row(
                children: [
                  Icon(
                    inStock ? Icons.check_circle : Icons.cancel,
                    size: 14,
                    color: statusColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    inStock ? 'In stock' : 'Sold out',
                    style: TextStyle(fontSize: 12, color: statusColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}