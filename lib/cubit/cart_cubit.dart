import 'package:bloc/bloc.dart';
import 'package:nexshop/model/cartItem.dart';
import 'package:nexshop/model/product.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Product product) {
    final items = [...state.items];
    final i = items.indexWhere((e) => e.product.id == product.id);

    if (i == -1) {
      if (product.stock <= 0) return;
      items.add(CartItem(product: product, quantity: 1));
    } else {
      if (items[i].quantity >= product.stock) return;
      items[i] = items[i].copyWith(quantity: items[i].quantity + 1);
    }
    emit(CartState(items: items));
  }

  void increase(String productId) {
    final items = [...state.items];
    final i = items.indexWhere((e) => e.product.id == productId);
    if (i == -1) return;
    if (items[i].quantity >= items[i].product.stock) return;

    items[i] = items[i].copyWith(quantity: items[i].quantity + 1);
    emit(CartState(items: items));
  }

  void decrease(String productId) {
    final items = [...state.items];
    final i = items.indexWhere((e) => e.product.id == productId);
    if (i == -1) return;

    final newQuantity = items[i].quantity - 1;
    if (newQuantity <= 0) {
      items.removeAt(i);
    } else {
      items[i] = items[i].copyWith(quantity: newQuantity);
    }
    emit(CartState(items: items));
  }

  void remove(String productId) {
    emit(CartState(
      items: state.items.where((e) => e.product.id != productId).toList(),
    ));
  }

  void clear() => emit(const CartState());
}