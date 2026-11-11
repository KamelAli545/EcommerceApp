import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// كل العمليات الخاصة ببيانات المستخدمين في Firestore وFirebase Auth
class UserService {
  final _user = FirebaseFirestore.instance.collection('users');

  // تسجيل مستخدم جديد: بينشئ الحساب في Auth، وبيحفظ الـ profile في Firestore
  Future<String> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user!;

    await user.updateDisplayName(name.trim());
    await createUserProfile(
      uid: user.uid,
      email: email.trim(),
      name: name.trim(),
    );

    return user.uid;
  }

  // إنشاء الـ profile للمستخدم الجديد، الدور بيكون 'user' افتراضياً
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String name,
  }) async {
    await _user.doc(uid).set({
      'email': email,
      'name': name,
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // جلب دور المستخدم، ولو مش موجود بنرجع 'user'
  Future<String> getRole(String uid) async {
    final doc = await _user.doc(uid).get();
    return doc.data()?['role'] as String? ?? 'user';
  }

  // جلب بيانات المستخدم بالـ uid
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    final doc = await _user.doc(uid).get();
    return doc.data();
  }

  // تحديث الاسم والتليفون بالـ uid، والدور والإيميل مش بيتغيروا هنا
  Future<void> updateProfile({
    required String uid,
    required String name,
    required String phone,
  }) async {
    await _user.doc(uid).update({'name': name, 'phone': phone});
  }

  // جلب بيانات المستخدم الحالي
  Future<Map<String, dynamic>?> getCurrentProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final doc = await _user.doc(uid).get();
    return doc.data();
  }

  // تحديث بيانات المستخدم الحالي، ومعاها الاسم المعروض في Firebase Auth
  Future<void> updateCurrentProfile({
    required String name,
    required String phone,
    String address = '',
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('You must be logged in');

    await _user
        .doc(user.uid)
        .update({'name': name, 'phone': phone, 'address': address});
    await user.updateDisplayName(name);
  }
}