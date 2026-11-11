part of 'cart_cubit.dart';

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  int get totalItems => items.fold(0, (sum, i) => sum + i.quantity);

  double get totalPrice => items.fold(0, (sum, i) => sum + i.subtotal);
}