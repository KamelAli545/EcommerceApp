import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersService {
  final _db = FirebaseFirestore.instance;

  // Caches customer lookups so each user is read only once
  final Map<String, Future<Map<String, dynamic>?>> _customerCache = {};

  // Live stream of all orders, newest first
  Stream<QuerySnapshot<Map<String, dynamic>>> ordersStream() {
    return _db
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Returns the customer's profile data, reading from Firestore only once per user
  Future<Map<String, dynamic>?> getCustomer(String uid) {
    return _customerCache.putIfAbsent(uid, () async {
      try {
        final doc = await _db.collection('users').doc(uid).get();
        return doc.data();
      } catch (e) {
        // Remove the failed lookup so the next build can retry
        _customerCache.remove(uid);
        rethrow;
      }
    });
  }

  static double parseTotal(Map<String, dynamic> data) {
    return (data['total'] as num?)?.toDouble() ?? 0;
  }

  static List<Map<String, dynamic>> parseItems(Map<String, dynamic> data) {
    return (data['items'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
  }

  static String formatDate(DateTime? date) {
    // createdAt is null for a moment after the write, until the server sets it
    if (date == null) return 'Pending...';
    final minute = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year}  ${date.hour}:$minute';
  }
  // Marks an order as completed. Only the status field is changed.
  Future<void> markDone(String orderId) {
    return _db.collection('orders').doc(orderId).update({'status': 'done'});
  }
  static Map<String, num> computeReport(List<Map<String, dynamic>> orders) {
    double totalSales = 0;
    int pending = 0;
    int done = 0;

    for (final data in orders) {
      final status = data['status'] as String? ?? 'pending';
      if (status == 'done') {
        done++;
        totalSales += parseTotal(data);
      } else {
        pending++;
      }
    }

    return {
      'totalSales': totalSales,
      'totalOrders': orders.length,
      'pending': pending,
      'done': done,
    };
  }
}
