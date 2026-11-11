import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/cart_summary.dart';
import 'package:nexshop/widgets/nav_item.dart';

// الصفحات اللي الشريط بيتحكم فيها
enum AppPage { home, cart, orders, profile }

// الشريط السفلي. بيبلغ الـ MainShell بالصفحة المختارة، ومش بيفتح شاشات بنفسه
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final AppPage current;
  final ValueChanged<AppPage> onSelected;

  void _go(AppPage page) {
    if (page == current) return;
    onSelected(page);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        // BlocBuilder واحد بيسمع الكارت، عشان الملخص والنقطة الحمرا
        child: BlocBuilder<CartCubit, CartState>(
          builder: (context, cart) {
            // الملخص بيظهر بس في الهوم ولما الكارت يكون فيه منتجات
            final showSummary =
                current == AppPage.home && cart.items.isNotEmpty;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ملخص الكارت فوق الشريط
                if (showSummary) ...[
                  CartSummary(
                    cart: cart,
                    onTap: () => _go(AppPage.cart),
                  ),
                  const SizedBox(height: 8),
                ],

                // شريط التنقل
                Container(
                  height: 66,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1C1C1E) : AppColors.ink,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      NavItem(
                        icon: Icons.home_rounded,
                        selected: current == AppPage.home,
                        onTap: () => _go(AppPage.home),
                      ),
                      NavItem(
                        icon: Icons.shopping_cart_outlined,
                        selected: current == AppPage.cart,
                        showDot: cart.items.isNotEmpty,
                        onTap: () => _go(AppPage.cart),
                      ),
                      NavItem(
                        icon: Icons.receipt_long_outlined,
                        selected: current == AppPage.orders,
                        onTap: () => _go(AppPage.orders),
                      ),
                      NavItem(
                        icon: Icons.person_outline,
                        selected: current == AppPage.profile,
                        onTap: () => _go(AppPage.profile),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}