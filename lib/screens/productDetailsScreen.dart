import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/model/product.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/cart_badge_button.dart';
import 'package:nexshop/widgets/flyingImage.dart';
import 'package:nexshop/widgets/price_tag.dart';
import 'package:nexshop/widgets/product_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _imageKey = GlobalKey();
  final _cartKey = GlobalKey();
  bool pressed = false;

  Product get product => widget.product;

  void _flyToCart() {
    final startBox = _imageKey.currentContext?.findRenderObject() as RenderBox?;
    final endBox = _cartKey.currentContext?.findRenderObject() as RenderBox?;
    if (startBox == null || endBox == null) return;

    final start = startBox.localToGlobal(Offset.zero) & startBox.size;
    final end = endBox.localToGlobal(Offset.zero) & endBox.size;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => FlyingImage(
        imageUrl: product.imageUrl,
        title: product.title,
        start: start,
        end: end,
        onDone: () => entry.remove(),
      ),
    );
    Overlay.of(context).insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final inStock = product.stock > 0;
    final statusColor = inStock ? AppColors.inStock : AppColors.outOfStock;

    // التحقق من حالة الثيم الحالي (فاتح أو داكن)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        actions: [
          KeyedSubtree(key: _cartKey, child: const CartBadgeButton()),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Listener(
            onPointerDown: (_) {
              if (inStock) setState(() => pressed = true);
            },
            onPointerUp: (_) => setState(() => pressed = false),
            onPointerCancel: (_) => setState(() => pressed = false),
            child: AnimatedScale(
              scale: pressed ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: inStock
                      ? () {
                    context.read<CartCubit>().addToCart(product);
                    _flyToCart();
                  }
                      : null,
                  child: Text(inStock ? 'Add to bag' : 'Sold out'),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          AspectRatio(
            key: _imageKey,
            aspectRatio: 1,
            child: ProductImage(
              url: product.imageUrl,
              title: product.title,
              radius: 8,
            ),
          ),
          const SizedBox(height: 20),
          if (product.category.isNotEmpty)
            Text(
              product.category,
              style: TextStyle(
                color: isDark ? AppColors.darkMuted : AppColors.muted,
                fontSize: 14,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            product.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PriceTag(price: product.price, large: true),
              const SizedBox(width: 16),
              Icon(
                inStock ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: statusColor,
              ),
              const SizedBox(width: 6),
              Text(
                inStock ? '${product.stock} in stock' : 'Sold out',
                style: TextStyle(color: statusColor),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: isDark ? AppColors.darkInk : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}