import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/product_cubit.dart';
import 'package:nexshop/model/product.dart';
import 'package:nexshop/screens/addProductsScreen.dart';
import 'package:nexshop/screens/edit_product_screen.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/appDialog.dart';
import 'package:nexshop/widgets/catergoryRow.dart';
import 'package:nexshop/widgets/price_tag.dart';
import 'package:nexshop/widgets/productSkeleton.dart';
import 'package:nexshop/widgets/product_image.dart';
import 'package:nexshop/widgets/state_message.dart';
import 'package:nexshop/widgets/theme_toggle.dart';

// شاشة إدارة المنتجات للأدمن، بتتعرض جوه AdminShell فالشريط السفلي بيجي من الـ Shell
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductCubit>();

    cubit.selectCategory(null);
    cubit.searchProduct('');

    cubit.loadProducts();
  }
  Future<void> _delete(Product product) async {
    final ok = await AppDialogs.confirm(
      context,
      title: 'Delete this product?',
      message: '"${product.title}" will be removed from the shelf.',
      cancelText: 'Keep it',
      confirmText: 'Delete',
      destructive: true,
      icon: Icons.delete_outline,
    );
    if (!ok || !mounted) return;

    try {
      await context.read<ProductCubit>().deleteProduct(product.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shelf manager'),
        actions: [
          ThemeToggle()
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.ink,
        foregroundColor: AppColors.paper,
        elevation: 0,
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddProductScreen()),
        ),
      ),

      body: Column(
        children: [
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
                  return StateMessage(icon: Icons.cloud_off, text: state.message);
                }

                // حالة التحميل: skeleton
                if (state is ProductsLoading) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    itemCount: 6,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    return const StateMessage(
                      icon: Icons.add_box_outlined,
                      text: 'The shelf is empty. Add your first product.',
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, i) {
                      final p = products[i];
                      final inStock = p.stock > 0;

                      return ListTile(
                        isThreeLine: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: SizedBox(
                          width: 56,
                          height: 56,
                          child: ProductImage(url: p.imageUrl, title: p.title),
                        ),
                        title: Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: AppColors.muted,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  PriceTag(price: p.price),
                                  const SizedBox(width: 10),
                                  Text(
                                    inStock ? '${p.stock} left' : 'Sold out',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: inStock
                                          ? AppColors.inStock
                                          : AppColors.outOfStock,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Edit ${p.title}',
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditProductScreen(product: p),
                                ),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Delete ${p.title}',
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _delete(p),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}