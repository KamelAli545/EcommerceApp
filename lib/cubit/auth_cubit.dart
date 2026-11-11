import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nexshop/model/userService.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthChecking()) {
    _sub = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final _auth = FirebaseAuth.instance;
  final _userService = UserService();
  StreamSubscription<User?>? _sub;

  // بتتنادى لما Firebase يقول إن حالة الدخول اتغيرت
  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      emit(AuthInitial());
      return;
    }
    await _emitAuthenticated();
  }

  // بتجيب دور المستخدم من Firestore وتبعته مع حالة الدخول
  Future<void> _emitAuthenticated() async {
    final uid = _auth.currentUser!.uid;
    final role = await _userService.getRole(uid);
    emit(AuthAuthenticated(role));
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // الـ stream هيبعت الحالة تلقائياً، فمش محتاجين نبعتها هنا
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_message(e)));
    }
  }

  Future<void> register({
    required String namee,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await _userService.registerUser(
        name: namee,
        email: email,
        password: password,
      );
      // الـ stream هيبعت الحالة تلقائياً بعد التسجيل
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_message(e)));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    // الـ stream هيبعت AuthInitial تلقائياً
  }

  String _message(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is wrong';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'invalid-email':
        return 'Invalid email address';
      case 'network-request-failed':
        return 'No internet connection';
      default:
        return e.message ?? 'Something went wrong';
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}