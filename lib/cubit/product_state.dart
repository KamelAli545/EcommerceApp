part of 'product_cubit.dart';

sealed class ProductState {}

final class ProductsInitial extends ProductState {}

final class ProductsLoading extends ProductState {}

final class ProductsSuccess extends ProductState {
  final List<Product> product;
  final List<String> categories;
  final String? selectedCategory; // null means "All"

  ProductsSuccess(
      this.product, {
        this.categories = const [],
        this.selectedCategory,
      });
}

final class ProductsError extends ProductState {
  final String message;
  ProductsError(this.message);
}