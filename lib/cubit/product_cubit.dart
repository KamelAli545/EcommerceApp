import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:nexshop/model/product.dart';
import 'package:nexshop/model/productServices.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductsInitial());

  final _service = ProductService();
  StreamSubscription<List<Product>>? _sub;

  List<Product> _all = [];
  String _query = '';
  String? _category;
  bool _loaded = false;

  void loadProducts() {
    _sub?.cancel();
    _loaded = false;
    emit(ProductsLoading());
    _sub = _service.watchProducts().listen(
          (products) {
        _all = products;
        _loaded = true;
        _emitFiltered();
      },
      onError: (e) {
        if (!isClosed) emit(ProductsError('$e'));
      },
    );
  }

  void searchProduct(String query) {
    _query = query.trim().toLowerCase();
    if (_loaded) _emitFiltered();
  }

  void selectCategory(String? category) {
    _category = category;
    if (_loaded) _emitFiltered();
  }

  // Unique, non-empty category names, sorted.
  // "shoes" and "Shoes" are merged into one entry.
  List<String> _categories() {
    final byKey = <String, String>{};
    for (final p in _all) {
      final name = p.category.trim();
      if (name.isEmpty) continue;
      byKey.putIfAbsent(name.toLowerCase(), () => name);
    }
    return byKey.values.toList()..sort();
  }

  void _emitFiltered() {
    if (isClosed) return;

    final categories = _categories();

    // If the selected category no longer exists (its last product was
    // deleted or renamed), fall back to "All"
    if (_category != null &&
        !categories.any((c) => c.toLowerCase() == _category!.toLowerCase())) {
      _category = null;
    }

    var list = _all;

    if (_category != null) {
      final wanted = _category!.toLowerCase();
      list = list
          .where((p) => p.category.trim().toLowerCase() == wanted)
          .toList();
    }

    if (_query.isNotEmpty) {
      list = list.where((p) {
        return p.title.toLowerCase().contains(_query) ||
            p.description.toLowerCase().contains(_query) ||
            p.category.toLowerCase().contains(_query);
      }).toList();
    }

    emit(ProductsSuccess(
      list,
      categories: categories,
      selectedCategory: _category,
    ));
  }

  Future<void> addProduct(Product product) => _service.addProduct(product);

  Future<void> deleteProduct(String id) => _service.deleteProduct(id);

  Future<void> updateProduct(Product product) =>
      _service.updateProduct(product);

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}