import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;

  Product({required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl});
factory Product.fromDoc(DocumentSnapshot<Map<String,dynamic>>doc){
  final d=doc.data()??{};
  return Product(
      id: doc.id,
      title: d['title'] as String? ?? '',
      description: d['description'] as String? ?? '',
      price: (d['price'] as num?)?.toDouble() ?? 0,
      stock: (d['stock'] as num?)?.toInt() ?? 0,
      category: d['category'] as String? ?? '',
      imageUrl: d['imageUrl'] as String? ?? '',);
}
  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'price': price,
    'stock': stock,
    'category': category,
    'imageUrl': imageUrl,
    'createdAt': FieldValue.serverTimestamp(),
  };

}

