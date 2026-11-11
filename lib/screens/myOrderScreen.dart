import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/model/adminOrderService.dart';
import 'package:nexshop/widgets/my_order_tile.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: uid == null
          ? const Center(child: Text('Please log in first'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        // قراءة لحظية: لما الأدمن يغيّر الحالة، تتحدث هنا من غير refresh
        // الترتيب بيتعمل في الكود عشان نتجنب composite index
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // ننسخ القائمة ونرتبها من الأحدث للأقدم
          final docs = [...snap.data!.docs]..sort((a, b) {
            final ta = (a.data()['createdAt'] as Timestamp?)?.toDate();
            final tb = (b.data()['createdAt'] as Timestamp?)?.toDate();
            // الطلب اللي لسه بيتسجل (من غير وقت) بيطلع فوق
            if (ta == null) return -1;
            if (tb == null) return 1;
            return tb.compareTo(ta);
          });

          if (docs.isEmpty) {
            return const Center(
              child: Text("You haven't placed any orders yet"),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (_, i) => MyOrderTile(doc: docs[i]),
          );
        },
      ),
    );
  }
}