import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/screens/cartScreen.dart';

class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cart) => IconButton(
        tooltip: 'Cart, ${cart.totalItems} items',
        icon: Badge(
          isLabelVisible: cart.totalItems > 0,
          label: Text('${cart.totalItems}'),
          child: const Icon(Icons.shopping_bag_outlined),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartScreen()),
        ),
      ),
    );
  }
}