import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/model/adminOrderService.dart';
import 'package:nexshop/model/orderUtils.dart';
import 'package:nexshop/widgets/product_image.dart';

// عنصر واحد في قائمة طلبات المستخدم: طلب واحد، وبيتفتح عشان يعرض منتجاته
class MyOrderTile extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;

  const MyOrderTile({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data();

    final total = AdminOrdersService.parseTotal(data);
    final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
    final items = AdminOrdersService.parseItems(data);
    final payment = data['paymentMethod'] as String? ?? 'cash';
    final paymentLabel =
    payment == 'card' ? 'Credit / debit card' : 'Cash on delivery';

    // الطلب مكتمل ولا لسه؟
    final isDone = OrderUtils.orderStatus(data) == OrderUtils.statusDone;

    return ExpansionTile(
      leading: Icon(
        isDone ? Icons.check_circle : Icons.hourglass_top,
        color: isDone ? Colors.green : Colors.orange,
      ),
      title: Text(
        '${OrderUtils.shortOrderId(doc.id)}  •  \$${total.toStringAsFixed(2)}',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${AdminOrdersService.formatDate(createdAt)}  •  '
            '${isDone ? 'Completed' : 'Pending'}  •  $paymentLabel',
      ),
      children: [
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