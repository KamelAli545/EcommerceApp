import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/model/product.dart';

class Prroducttab extends StatelessWidget {
  const Prroducttab({super.key});

  static const categories = ['Shoes', 'Clothes', 'Accessories'];
  static const brand = 'Adidas';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(brand),
          bottom: TabBar(
            isScrollable: true,
            tabs: categories.map((c) => Tab(text: c)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories
              .map((c) => _ProductsByCategory(category: c, brand: brand))
              .toList(),
        ),
      ),
    );
  }
}

class _ProductsByCategory extends StatelessWidget {
  const _ProductsByCategory({required this.category, required this.brand});

  final String category;
  final String brand;

  Stream<List<Product>> _stream() {
    return FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: category)
        .where('brand', isEqualTo: brand)
        .snapshots()
        .map((s) => s.docs.map(Product.fromDoc).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: _stream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('حصل خطأ: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final items = snapshot.data!;
        if (items.isEmpty) {
          return Center(child: Text('مفيش منتجات $brand في $category'));
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) {
            final p = items[i];
            return ListTile(
              leading: Image.network(p.imageUrl, width: 56, fit: BoxFit.cover),
              title: Text(p.title),
              subtitle: Text('Stock: ${p.stock}'),
              trailing: Text('\$${p.price.toStringAsFixed(0)}'),
            );
          },
        );
      },
    );
  }
}