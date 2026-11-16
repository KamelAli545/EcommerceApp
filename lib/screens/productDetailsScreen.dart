import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/model/product.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/cart_badge_button.dart';
import 'package:nexshop/widgets/expbandable_text.dart';
import 'package:nexshop/widgets/flying_cart.dart';
import 'package:nexshop/widgets/price_tag.dart';
import 'package:nexshop/widgets/product_image.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    super.key,
    required this.product,
    this.relatedProducts = const [],
  });

  final Product product;
  final List<Product> relatedProducts;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final _imageKey = GlobalKey();
  final _cartKey = GlobalKey();

  bool _pressed = false;
  Product get product => widget.product;

  // نفس الكاتيجوري الأول، وبعدها باقي المنتجات، وبحد أقصى 6
  List<Product> get _related {
    final others = widget.relatedProducts
        .where((p) => p.id != product.id)
        .toList();

    others.sort((a, b) {
      final aSame = a.category == product.category ? 0 : 1;
      final bSame = b.category == product.category ? 0 : 1;
      return aSame.compareTo(bSame);
    });

    return others.take(6).toList();
  }



  @override
  Widget build(BuildContext context) {
    final inStock = product.stock > 0;
    final statusColor = inStock ? AppColors.inStock : AppColors.outOfStock;
    final related = _related;

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Listener(
            onPointerDown: (_) {
              if (inStock) setState(() => _pressed = true);
            },
            onPointerUp: (_) => setState(() => _pressed = false),
            onPointerCancel: (_) => setState(() => _pressed = false),
            child: AnimatedScale(
              scale: _pressed ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: inStock
                      ? () {
                    context.read<CartCubit>().addToCart(product);
                    flyToCart(
                      context: context,
                      imageKey: _imageKey,
                      cartKey: _cartKey,
                      imageUrl: product.imageUrl,
                      title: product.title,
                    );
                  }
                      : null,
                  child: Text(inStock ? 'Add to bag' : 'Sold out'),
                ),
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
        ),
        slivers: [
          // 2) الهيدر
          SliverAppBar(
            pinned: true, // 3) يفضل ظاهر فوق
            stretch: true, // 4) يتمط لما تعمل pull
            expandedHeight: 360, // 1) الهيدر الطويل
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            foregroundColor: AppText.ink(context),
            title: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: FitText(
                product.title,
                alignment: Alignment.center,
                style: AppText.appBar(color: AppText.ink(context)),
              ),
            ),
            actions: [
              KeyedSubtree(
                key: _cartKey,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: const IconTheme(
                      data: IconThemeData(color: Colors.white),
                      child: CartBadgeButton(),
                    ),
                  ),
                ),
              ),
            ],
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
            ),            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: KeyedSubtree(
                key: _imageKey,
                child: ProductImage(
                  url: product.imageUrl,
                  title: product.title,
                  radius: 0,
                ),
              ),
            ),
          ),

          // تفاصيل المنتج
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (product.category.isNotEmpty)
                  Text(
                    product.category,
                    style: AppText.caption(color: AppText.muted(context)),
                  ),
                const SizedBox(height: 4),
                FitText(
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkImageWell
                        : AppColors.imageWell,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpandableText(text: product.description),
                ),
              ]),
            ),
          ),
          // You may also like: grid من عمودين
          if (related.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'You may also like',
                  style: AppText.title(color: AppText.ink(context)),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: related.length,
                itemBuilder: (context, i) {
                  final p = related[i];
                  return Material(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkImageWell
                        : AppColors.imageWell,
                    borderRadius: BorderRadius.circular(6),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsScreen(
                              product: p,
                              relatedProducts: widget.relatedProducts,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ProductImage(
                              url: p.imageUrl,
                              title: p.title,
                              radius: 0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.subtitle(
                                    color: AppText.ink(context),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                PriceTag(price: p.price),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}