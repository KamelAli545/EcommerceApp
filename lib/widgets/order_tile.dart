import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/model/adminOrderService.dart';
import 'package:nexshop/model/orderUtils.dart';
import 'package:nexshop/widgets/appDialog.dart';
import 'package:nexshop/widgets/customer_info.dart';
import 'package:nexshop/widgets/product_image.dart';

import '../theme/app_theme.dart';

class OrderTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final AdminOrdersService service;

  const OrderTile({super.key, required this.doc, required this.service});

  // Asks the admin to confirm before marking the order as completed
// Asks the admin to confirm before marking the order as completed
  Future<void> _confirmAndMarkDone(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await AppDialogs.completeOrder(
      context,
      orderLabel: OrderUtils.shortOrderId(doc.id),
    );

    if (!confirmed) return;

    try {
      await service.markDone(doc.id);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not update order: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final data = doc.data();
    final total = AdminOrdersService.parseTotal(data);
    final userId = data['userId'] as String? ?? '';
    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    final items = AdminOrdersService.parseItems(data);
    final isDone = OrderUtils.orderStatus(data) == OrderUtils.statusDone;
    final payment = data['paymentMethod'] as String? ?? 'cash';
    final paymentLabel =
    payment == 'card' ? 'Credit / debit card' : 'Cash on delivery';

    return ExpansionTile(
      title: Text(
        '${OrderUtils.shortOrderId(doc.id)}  •  \$${total.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${AdminOrdersService.formatDate(createdAt)}  •  '
            '${isDone ? 'Completed' : 'Pending'}  •  $paymentLabel',
      ),
      trailing: isDone
          ? const Icon(Icons.check_circle, color: Colors.green)
          : IconButton(
        tooltip: 'Mark as completed',
        icon: const Icon(Icons.radio_button_unchecked),
        onPressed: () => _confirmAndMarkDone(context),
      ),
      children: [
        CustomerInfo(userId: userId, service: service),

        ListTile(
          dense: true,
          leading: const Icon(Icons.receipt_long_outlined),
          title: const Text('Order ID'),
          subtitle: Text(doc.id),
        ),

        ListTile(
          dense: true,
          leading: const Icon(Icons.location_on_outlined),
          title: const Text('Delivery area'),
          subtitle: Text(
            (data['deliveryArea'] as String?)?.trim().isNotEmpty == true
                ? data['deliveryArea'] as String
                : 'Not provided',
          ),
        ),

        for (final item in items)
          ListTile(
            dense: true,
            leading: SizedBox(
              width: 48,
              height: 48,
              child: ProductImage(
                url: item['imageUrl'] as String? ?? '',
                title: item['title'] as String? ?? '',
              ),
            ),
            title: Text(item['title'] as String? ?? ''),
            subtitle: Text(
              'Quantity: ${item['quantity']}  |  '
                  'Price: \$${((item['price'] as num?) ?? 0).toStringAsFixed(2)}',
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}