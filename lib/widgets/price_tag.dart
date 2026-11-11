import 'package:flutter/material.dart';
import 'package:nexshop/theme/app_theme.dart';

class PriceTag extends StatelessWidget {
  const PriceTag({super.key, required this.price, this.large = false});

  final double price;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.tag,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: large ? 12 : 8,
          vertical: large ? 6 : 3,
        ),
        child: Text(
          '\$${price.toStringAsFixed(2)}',
          style: AppText.price(size: large ? 22 : 15),
        ),
      ),
    );
  }
}