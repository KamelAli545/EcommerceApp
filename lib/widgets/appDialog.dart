import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:nexshop/cubit/auth_cubit.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/app_button_styles.dart';

// كل ديالوجات التطبيق في مكان واحد. أي شاشة بتستدعي دالة من هنا بس
class AppDialogs {
  AppDialogs._();

  // كارت نجاح الدفع، بيقفل لوحده بعد ثانية ونص
  static Future<void> success(
      BuildContext context, {
        String message = 'Payment done successfully.',
      }) async {
    await _show<void>(context, _SuccessCard(message: message));
  }

  // تأكيد عام. بيرجع true لو اتضغط الزرار الأساسي، وfalse غير كده
  static Future<bool> confirm(
      BuildContext context, {
        required String title,
        String? message,
        String cancelText = 'Cancel',
        String confirmText = 'Confirm',
        bool destructive = false,
        IconData? icon,
      }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final result = await _show<bool>(
      context,
      _PremiumCard(
        title: title,
        message: message,
        icon: icon,
        iconColor: destructive
            ? AppColors.outOfStock
            : (isDark ? AppColors.darkInk : AppColors.ink),
        actions: [
          _DialogAction(label: cancelText, value: false, outlined: true),
          _DialogAction(
            label: confirmText,
            value: true,
            color: destructive ? AppColors.outOfStock : null,
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // تأكيد تسجيل الخروج. بيسجل الخروج لو المستخدم وافق
  static Future<void> logout(BuildContext context) async {
    final auth = context.read<AuthCubit>();

    final ok = await confirm(
      context,
      title: 'Log out?',
      message: 'You can sign back in any time.',
      cancelText: 'Stay',
      confirmText: 'Log out',
      destructive: true,
      icon: Icons.logout,
    );

    if (ok) await auth.logout();
  }

  // تأكيد إتمام الطلب من لوحة الأدمن. بيرجع true لو وافق الأدمن
  static Future<bool> completeOrder(
      BuildContext context, {
        required String orderLabel,
      }) {
    return confirm(
      context,
      title: 'Complete order?',
      message: 'Mark $orderLabel as completed?',
      icon: Icons.check_circle_outline,
    );
  }

  // حوار معلومات بزرار واحد
  static Future<void> info(
      BuildContext context, {
        required String title,
        String? message,
        String buttonText = 'OK',
        IconData icon = Icons.check_circle_outline,
      }) async {
    await _show<bool>(
      context,
      _PremiumCard(
        title: title,
        message: message,
        icon: icon,
        iconColor: AppColors.inStock,
        actions: [_DialogAction(label: buttonText, value: true)],
      ),
    );
  }

  // الدالة المشتركة اللي بتعرض أي كارت بنفس الخلفية والأنيميشن
  static Future<T?> _show<T>(BuildContext context, Widget card) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.15),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => Center(child: card),
      transitionBuilder: (context, animation, _, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 10 * animation.value,
            sigmaY: 10 * animation.value,
          ),
          child: FadeTransition(
            opacity: curve,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1).animate(curve),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

// وصف زرار واحد في الحوار
class _DialogAction {
  const _DialogAction({
    required this.label,
    required this.value,
    this.outlined = false,
    this.color,
  });

  final String label;

  // القيمة اللي بترجع للي فتح الحوار لما نضغط الزرار
  final bool value;

  // true يعني زرار بإطار، false يعني زرار ممتلي
  final bool outlined;

  // لون الزرار الممتلي (لو null يبقى اللون الأساسي حسب الثيم)
  final Color? color;
}

// الكارت الشفاف نفسه
class _PremiumCard extends StatelessWidget {
  const _PremiumCard({
    required this.title,
    required this.actions,
    this.message,
    this.icon,
    this.iconColor = AppColors.ink,
  });

  final String title;
  final String? message;
  final IconData? icon;
  final Color iconColor;
  final List<_DialogAction> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          decoration: _cardDecoration(isDark),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الأيقونة في دايرة ناعمة بلون الحالة
              if (icon != null) ...[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: iconColor.withOpacity(0.1),
                  ),
                  child: Icon(icon, size: 26, color: iconColor),
                ),
                const SizedBox(height: 16),
              ],

              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),

              if (message != null) ...[
                const SizedBox(height: 8),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark ? AppColors.darkMuted : AppColors.muted,
                    height: 1.4,
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // الزراير جنب بعض، وكل واحد ياخد نص العرض المتاح
              Row(
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Expanded(child: _button(context, actions[i], isDark)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(BuildContext context, _DialogAction action, bool isDark) {
    if (action.outlined) {
      return OutlinedButton(
        onPressed: () => Navigator.pop(context, action.value),
        style: AppButtonStyles.outlined(isDark),
        child: Text(action.label),
      );
    }

    return ElevatedButton(
      onPressed: () => Navigator.pop(context, action.value),
      style: AppButtonStyles.filled(isDark, background: action.color),
      child: Text(action.label),
    );
  }}

// كارت النجاح اللي فيه الأنيميشن
class _SuccessCard extends StatefulWidget {
  const _SuccessCard({required this.message});

  final String message;

  @override
  State<_SuccessCard> createState() => _SuccessCardState();
}

class _SuccessCardState extends State<_SuccessCard> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      // نقفل بس لو الكارت لسه أول حاجة مفتوحة، عشان ما نقفلش شاشة تانية بالغلط
      if (!mounted) return;
      final route = ModalRoute.of(context);
      if (route != null && route.isCurrent) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          decoration: _cardDecoration(isDark),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animations/success.json',
                width: 180,
                height: 180,
                repeat: false,
              ),
              const SizedBox(height: 8),
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// شكل الكارت المشترك بين كل الديالوجات، بيتغير حسب الوضع الفاتح أو الداكن
BoxDecoration _cardDecoration(bool isDark) {
  return BoxDecoration(
    color: isDark
        ? const Color(0xFF1C1C1E).withOpacity(0.92)
        : AppColors.paper.withOpacity(0.88),
    borderRadius: BorderRadius.circular(28),
    border: Border.all(
      color: isDark
          ? Colors.white.withOpacity(0.12)
          : Colors.white.withOpacity(0.7),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
        blurRadius: 40,
        offset: const Offset(0, 16),
      ),
    ],
  );
}