import 'package:flutter/material.dart';
import 'package:nexshop/screens/cartScreen.dart';
import 'package:nexshop/screens/myOrderScreen.dart'; // غيّر الاسم لو ملفك myOrdersScreen.dart
import 'package:nexshop/screens/productScreen.dart';
import 'package:nexshop/screens/profileScreen.dart';
import 'package:nexshop/widgets/appbottomnav.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  AppPage _page = AppPage.home;

  late final List<Widget> _pages = [
    const ProductsScreen(),
    CartScreen(onBrowse: () => _select(AppPage.home)),
    const MyOrdersScreen(),
    const ProfileScreen(),
  ];

  void _select(AppPage page) {
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _page.index,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        current: _page,
        onSelected: _select,
      ),
    );
  }
}