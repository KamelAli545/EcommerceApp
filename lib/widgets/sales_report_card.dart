import 'package:flutter/material.dart';
import 'package:nexshop/model/adminOrderService.dart';

class SalesReportCard extends StatelessWidget {
  final List<Map<String, dynamic>> orders;

  const SalesReportCard({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final report = AdminOrdersService.computeReport(orders);
    final theme = Theme.of(context);
    final totalSales = (report['totalSales'] as num).toStringAsFixed(2);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales report',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _Stat(label: 'Total sales', value: '\$$totalSales'),
                _Stat(label: 'Orders', value: '${report['totalOrders']}'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Pending: ${report['pending']}  •  Completed: ${report['done']}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}