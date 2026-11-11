import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/product_cubit.dart';
import 'package:nexshop/screens/productDetailsScreen.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/catergoryRow.dart';
import 'package:nexshop/widgets/inputWidget.dart';
import 'package:nexshop/widgets/productCard.dart';
import 'package:nexshop/widgets/productSkeleton.dart';
import 'package:nexshop/widgets/state_message.dart';
import 'package:nexshop/widgets/theme_toggle.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final searchController = TextEditingController();

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductCubit>();
    cubit.selectCategory(null);
    cubit.searchProduct('');
    cubit.loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('nexshop'),
          actions:  [
            ThemeToggle()
          ],
        ),        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InputWidgets(
                label: 'Search Product',
                controller: searchController,
                isSearch: true,
                prefixIcon: Icons.search,
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  setState(() => searchQuery = value);
                  context.read<ProductCubit>().searchProduct(value);
                },
              ),
            ),          const SizedBox(height: 12),
      
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                final success = state is ProductsSuccess ? state : null;
      
                return CategoryRow(
                  categories: success?.categories ?? const [],
                  selected: success?.selectedCategory,
                  onTap: (category) =>
                      context.read<ProductCubit>().selectCategory(category),
                );
              },
            ),
            const SizedBox(height: 8),
      
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductsError) {
                    return StateMessage(
                      icon: Icons.cloud_off,
                      text: state.message,
                    );
                  }
      
                  if (state is ProductsLoading || state is ProductsInitial) {
                    return GridView.builder(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      itemCount: 6,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.5,
                      ),
                      itemBuilder: (_, __) => const ProductSkeleton(),
                    );
                  }
      
                  if (state is ProductsSuccess) {
                    final products = state.product;
      
                    if (products.isEmpty) {
                      return StateMessage(
                        icon: Icons.inventory_2_outlined,
                        text: state.selectedCategory == null
                            ? 'Nothing on the shelf yet.'
                            : 'No products in this category.',
                      );
                    }
                    final inStockCount =
                        products.where((p) => p.stock > 0).length;
                    return CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Shop the shelf',
                                  style:
                                  Theme.of(context).textTheme.headlineLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$inStockCount of ${products.length} in stock today',
                                  style: const TextStyle(color: AppColors.muted),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.56,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 24,
                            ),
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                final product = products[index];
                                return OpenContainer(
                                  tappable: false,
                                  closedElevation: 0,
                                  openElevation: 0,
                                  closedColor: Colors.transparent,
                                  openColor: Colors.transparent,
                                  transitionDuration: const Duration(milliseconds: 300),
                                  closedShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  closedBuilder: (context, openContainer) => ProductCard(
                                    product: product,
                                    onTap: openContainer,
                                  ),
                                  openBuilder: (context, closeContainer) =>
                                      ProductDetailsScreen(product: product),
                                )
                                    .animate(delay: (index < 8 ? index * 80 : 0).ms)
                                    .fadeIn()
                                    .slideY(begin: 0.15,end: 0,duration: 300.ms,curve: Curves.easeOutQuad);
                              },
                              childCount: products.length,
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                      ],
                    );
                  }
      
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}