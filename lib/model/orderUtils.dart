class OrderUtils {
  OrderUtils._(); // prevents creating instances

  static const String statusPending = 'pending';
  static const String statusDone = 'done';

  // Short, readable version of the Firestore document ID, e.g. "#A1B2C3"
  static String shortOrderId(String docId) {
    final end = docId.length < 6 ? docId.length : 6;
    return '#${docId.substring(0, end).toUpperCase()}';
  }

  // Older orders have no status field, so treat them as pending
  static String orderStatus(Map<String, dynamic> data) =>
      data['status'] as String? ?? statusPending;
}