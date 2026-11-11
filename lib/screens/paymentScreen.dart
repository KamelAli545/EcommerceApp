import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/model/orderService.dart';
import 'package:nexshop/model/userService.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/appDialog.dart';
import 'package:nexshop/widgets/inputWidget.dart';
import 'package:nexshop/widgets/product_image.dart';

// شاشة الدفع: بتتفتح فوق الـ MainShell من زرار Checkout في الكارت
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _method = 'cash';
  bool pressed = false;

  bool _processing = false;

  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _prefillAddress();
  }

  // بنملا منطقة التوصيل من عنوان البروفايل لو موجود
  Future<void> _prefillAddress() async {
    try {
      final data = await UserService().getCurrentProfile();
      final address = (data?['address'] as String? ?? '').trim();
      if (mounted && address.isNotEmpty && _areaController.text.isEmpty) {
        _areaController.text = address;
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _confirm(CartState cart) async {
    // لازم منطقة التوصيل تتكتب الأول
    if (!_formKey.currentState!.validate()) return;
    final area = _areaController.text.trim();

    // تأكيد قبل ما الطلب يتسجل، بنفس ديالوج التطبيق
    final ok = await AppDialogs.confirm(
      context,
      title: 'Place this order?',
      message: '${cart.totalItems} items  •  '
          '\$${cart.totalPrice.toStringAsFixed(2)}\n'
          'Delivery to: $area',
      cancelText: 'Review',
      confirmText: 'Place order',
      icon: Icons.shopping_bag_outlined,
    );
    if (!ok || !mounted) return;

    setState(() => _processing = true);

    try {
      await OrderService().placeOrder(cart.items,
        paymentMethod: _method,
        deliveryArea: area,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      return;
    }

    if (!mounted) return;

    context.read<CartCubit>().clear();

    await AppDialogs.success(context);

    if (!mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الثيم الحالي (فاتح أو داكن)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkInk : AppColors.ink;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.muted;

    return Scaffold(
      bottomNavigationBar:
      BlocBuilder<CartCubit, CartState>(
        builder: (context, cart) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: SizedBox(
                height: 50,
                child: Listener(
                  onPointerDown: (_) {
                    if (!_processing) setState(() => pressed = true);
                  },
                  onPointerUp: (_) => setState(() => pressed = false),
                  onPointerCancel: (_) => setState(() => pressed = false),
                  child: AnimatedScale(
                    scale: pressed ? 0.96 : 1.0,
                    duration: const Duration(milliseconds: 120),
                    child: ElevatedButton(
                      onPressed: _processing ? null : () => _confirm(cart),
                      child: _processing
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text('Confirm payment'),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      appBar: AppBar(title: const Text('Payment')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cart) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Order summary',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${cart.totalItems} items',
                style: TextStyle(color: mutedColor),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${cart.totalPrice.toStringAsFixed(2)}',
                style: AppText.price(size: 24).copyWith(
                  color: textColor,
                ),
              ),
              const Divider(height: 32),

              // المنتجات اللي في الكارت
              Text(
                'Items',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              for (final item in cart.items)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 52,
                    height: 52,
                    child: ProductImage(
                      url: item.product.imageUrl,
                      title: item.product.title,
                    ),
                  ),
                  title: Text(
                    item.product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: textColor),
                  ),
                  subtitle: Text(
                    'Qty ${item.quantity}  ×  '
                        '\$${item.product.price.toStringAsFixed(2)}',
                    style: TextStyle(color: mutedColor),
                  ),
                  trailing: Text(
                    '\$${item.subtotal.toStringAsFixed(2)}',
                    style: AppText.price(size: 16).copyWith(color: textColor),
                  ),
                ),
              const Divider(height: 32),

              // منطقة التوصيل
              Text(
                'Delivery area',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Form(
                key: _formKey,
                child: InputWidgets(
                  label: 'Area / neighborhood',
                  controller: _areaController,
                  prefixIcon: Icons.location_on_outlined,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your delivery area'
                      : null,
                ),
              ),
              const Divider(height: 32),

              // طريقة الدفع
              Text(
                'Payment method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: 'cash',
                groupValue: _method,
                title: Text(
                  'Cash on delivery',
                  style: TextStyle(color: textColor),
                ),
                onChanged: _processing
                    ? null
                    : (v) => setState(() => _method = v!),
              ),
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: 'card',
                groupValue: _method,
                title: Text(
                  'Credit / debit card',
                  style: TextStyle(color: textColor),
                ),
                onChanged: _processing
                    ? null
                    : (v) => setState(() => _method = v!),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}