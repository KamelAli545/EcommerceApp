import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/model/adminOrderService.dart';
import 'package:nexshop/widgets/order_tile.dart';
import 'package:nexshop/widgets/sales_report_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _service = AdminOrdersService();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = _service.ordersStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _ordersStream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data!.docs;
          final orders = docs.map((d) => d.data()).toList();

          return Column(
            children: [
              SalesReportCard(orders: orders),
              Expanded(
                child: docs.isEmpty
                    ? const Center(child: Text('No orders yet'))
                    : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) => OrderTile(
                    doc: docs[i],
                    service: _service,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}