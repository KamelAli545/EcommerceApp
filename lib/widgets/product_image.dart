import 'package:flutter/material.dart';
import 'package:nexshop/theme/app_theme.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.url,
    required this.title,
    this.radius = 6,
  });

  final String url;
  final String title;
  final double radius;

  Widget _placeholder() => const Center(
    child: Icon(Icons.image_outlined, size: 40, color: AppColors.muted),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: ColoredBox(
        color: AppColors.imageWell,
        child: url.isEmpty
            ? _placeholder()
            : Image.network(
          url,
          fit: BoxFit.cover,
          semanticLabel: title,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      ),
    );
  }
}