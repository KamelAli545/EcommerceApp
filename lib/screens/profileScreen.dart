import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/screens/editProfileScreen.dart';
import 'package:nexshop/widgets/appDialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (user != null)
            IconButton(
              tooltip: 'Edit profile',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              ),
            ),

          // زرار تسجيل الخروج، بيعرض التأكيد المشترك
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => AppDialogs.logout(context),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please log in first'))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        // قراءة لحظية: أي تعديل من شاشة التعديل يظهر هنا فوراً
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // بيانات المستخدم من Firestore، أو فاضية لو مش موجودة
          final data = snap.data!.data() ?? {};

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // صورة البروفايل الافتراضية
              const Center(
                child: CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                ),
              ),
              const SizedBox(height: 16),

              // الاسم
              Center(
                child: Text(
                  data['name'] as String? ?? 'No name',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // الإيميل من Firebase Auth
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Email'),
                subtitle: Text(user.email ?? ''),
              ),

              // رقم التليفون من Firestore
              ListTile(
                leading: const Icon(Icons.phone_outlined),
                title: const Text('Phone'),
                subtitle: Text(data['phone'] as String? ?? 'Not added'),
              ),

              // العنوان / منطقة التوصيل من Firestore
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Address'),
                subtitle: Text(
                  (data['address'] as String?)?.trim().isNotEmpty == true
                      ? data['address'] as String
                      : 'Not added',
                ),
              ),

              // الدور (user أو admin)
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: const Text('Role'),
                subtitle: Text(data['role'] as String? ?? 'user'),
              ),
            ],
          );
        },
      ),
    );
  }
}