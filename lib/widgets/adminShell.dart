import 'package:flutter/material.dart';
import 'package:nexshop/screens/adminDashBoardScreen.dart';
import 'package:nexshop/screens/orderScreen.dart';
import 'package:nexshop/screens/profileScreen.dart';
import 'package:nexshop/theme/app_theme.dart';

// الشاشة الرئيسية للأدمن: الشريط ثابت تحت، والصفحات بتتبدل جواه
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  // رقم التاب الحالي (0 = المنتجات، 1 = الطلبات، 2 = البروفايل)
  int _index = 0;

  // الصفحات محفوظة في الذاكرة، فكل تاب يحتفظ بحالته
  static const _pages = [
    AdminDashboardScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBarTheme(
        // ألوان الشريط من ألوان التطبيق
        data: NavigationBarThemeData(
          backgroundColor: AppColors.navBackground,
          indicatorColor: AppColors.navSelected,
          iconTheme: WidgetStateProperty.resolveWith(
                (states) => IconThemeData(
              color: states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.white70,
            ),
          ),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: 'Products',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_outlined),
              selectedIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}