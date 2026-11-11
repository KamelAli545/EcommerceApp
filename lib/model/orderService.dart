import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexshop/model/cartItem.dart';

// خطأ يقدر يتعرض للمستخدم مباشرة، من غير بادئة "Exception:"
class OrderException implements Exception {
  final String message;
  OrderException(this.message);

  @override
  String toString() => message;
}

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // بتنشئ الطلب وبترجع الـ ID بتاعه. الإجمالي بيتحسب من السيرفر، مش من التطبيق
  Future<String> placeOrder(List<CartItem> items,{
    required String paymentMethod,
    required String deliveryArea,
  }) async {

    // لازم يكون المستخدم مسجل دخول
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw OrderException('You must be logged in.');

    // لازم منطقة التوصيل تكون مكتوبة
    if (deliveryArea.trim().isEmpty) {
      throw OrderException('Please enter your delivery area.');
    }

    // السلة فاضية، مفيش طلب
    if (items.isEmpty) throw OrderException('Your bag is empty.');

    // الكمية لازم تكون موجبة
    for (final item in items) {
      if (item.quantity <= 0) {
        throw OrderException('Invalid quantity for ${item.product.title}.');
      }
    }

    // نجهز مرجع الطلب الجديد عشان نعرف الـ ID قبل الـ transaction
    final orderRef = _db.collection('orders').doc();

    await _db.runTransaction((tx) async {
      // ---- القراءة: لازم تكون قبل أي كتابة ----
      final refs = <DocumentReference<Map<String, dynamic>>>[];
      final snaps = <DocumentSnapshot<Map<String, dynamic>>>[];

      for (final item in items) {
        final ref = _db.collection('products').doc(item.product.id);
        refs.add(ref);
        snaps.add(await tx.get(ref));
      }

      // ---- التحقق: نحسب الإجمالي من أسعار Firestore ونتأكد من المخزون ----
      final orderItems = <Map<String, dynamic>>[];
      double total = 0;

      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final snap = snaps[i];

        // المنتج اتشال من قاعدة البيانات
        if (!snap.exists) {
          throw OrderException('${item.product.title} is no longer available.');
        }

        final data = snap.data()!;
        final stock = (data['stock'] as num?)?.toInt() ?? 0;
        final title = (data['title'] as String?) ?? item.product.title;
        final price = (data['price'] as num?)?.toDouble() ?? 0.0;

        // المخزون مش كفاية
        if (stock < item.quantity) {
          throw OrderException(
            stock == 0
                ? '$title is sold out.'
                : '$title has only $stock left.',
          );
        }

        total += price * item.quantity;

        orderItems.add({
          'productId': item.product.id,
          'title': title,
          'price': price,
          'quantity': item.quantity,
          'imageUrl': (data['imageUrl'] as String?) ?? '',
        });
      }

      // ---- الكتابة: بعد ما كل الفحوصات تنجح ----
      for (var i = 0; i < items.length; i++) {
        tx.update(refs[i], {
          'stock': FieldValue.increment(-items[i].quantity),
        });
      }

      tx.set(orderRef, {
        'userId': user.uid,
        'status': 'pending',
        'total': total,
        'createdAt': FieldValue.serverTimestamp(),
        'items': orderItems,
        'paymentMethod': paymentMethod,
        'deliveryArea': deliveryArea.trim(),


      });
    });

    return orderRef.id;
  }
}