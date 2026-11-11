import 'package:flutter/material.dart';
import 'package:nexshop/model/adminOrderService.dart';

class CustomerInfo extends StatelessWidget {
  final String userId;
  final AdminOrdersService service;

  const CustomerInfo({super.key, required this.userId, required this.service});

  @override
  Widget build(BuildContext context) {
    // Guard against an empty userId, which would make Firestore throw
    if (userId.isEmpty) {
      return const ListTile(
        dense: true,
        leading: Icon(Icons.person_outline),
        title: Text('Unknown customer'),
      );
    }

    return FutureBuilder<Map<String, dynamic>?>(
      future: service.getCustomer(userId),
      builder: (context, snap) {
        if (snap.hasError) {
          return ListTile(
            dense: true,
            leading: const Icon(Icons.person_outline),
            title: const Text('Unknown customer'),
            subtitle: Text(userId),
          );
        }

        final customer = snap.data;
        return ListTile(
          dense: true,
          leading: const Icon(Icons.person_outline),
          title: Text(customer?['name'] as String? ?? 'Customer'),
          subtitle: Text(customer?['email'] as String? ?? userId),
        );
      },
    );
  }
}