import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nexshop/model/product.dart';

class ProductService {
  final _products = FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> watchProducts() {
    return _products
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Product.fromDoc).toList());
  }

  Future<void> addProduct(Product product) async {
    await _products.add(product.toMap());
  }
  Future<void> updateProduct(Product product) async {
    final data = product.toMap()..remove('createdAt');
    await _products.doc(product.id).update(data);
  }
  Future<void> deleteProduct(String id) async {
    await _products.doc(id).delete();
  }
}