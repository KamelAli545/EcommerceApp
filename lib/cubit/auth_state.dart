part of 'auth_cubit.dart';

sealed class AuthState {}

// لسه بنتحقق من حالة الدخول عند فتح التطبيق
final class AuthChecking extends AuthState {}

// مفيش مستخدم مسجل دخول
final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final String role;
  AuthAuthenticated(this.role);
}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}