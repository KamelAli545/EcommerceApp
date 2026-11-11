import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/screens/paymentScreen.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/cartItemTile.dart';
import 'package:nexshop/widgets/state_message.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.onBrowse});

  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your bag')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return StateMessage(
              icon: Icons.shopping_bag_outlined,
              text: 'Your bag is empty.',
              actionLabel: 'Browse the shelf',
              onAction: onBrowse,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) => CartItemTile(item: state.items[i]),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.items.isEmpty) return const SizedBox.shrink();

          final isDark = Theme.of(context).brightness == Brightness.dark;

          return SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkPaper : AppColors.paper,
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkHairline : AppColors.hairline,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${state.totalItems} items',
                        style: TextStyle(
                          color: isDark ? AppColors.darkMuted : AppColors.muted,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '\$${state.totalPrice.toStringAsFixed(2)}',
                        style: AppText.price(size: 24).copyWith(
                          color: isDark ? AppColors.darkInk : AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaymentScreen(),
                        ),
                      ),
                      child: const Text('Checkout'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}