import 'package:nexshop/model/product.dart';

class CartItem {
  final Product product;
  final int quantity;

   CartItem({required this.product, required this.quantity});

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  double get subtotal => product.price * quantity;

}