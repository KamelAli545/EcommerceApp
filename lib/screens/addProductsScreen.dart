import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/product_cubit.dart';
import 'package:nexshop/model/product.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/app_button_styles.dart';
import 'package:nexshop/widgets/inputWidget.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final _category = TextEditingController();
  final _imageUrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _price.dispose();
    _stock.dispose();
    _category.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    try {
      await context.read<ProductCubit>().addProduct(
        Product(
          id: '',
          title: _title.text.trim(),
          description: _description.text.trim(),
          price: double.parse(_price.text.trim()),
          stock: int.parse(_stock.text.trim()),
          category: _category.text.trim(),
          imageUrl: _imageUrl.text.trim(),
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e, st) {
      debugPrint('addProduct failed: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _validPrice(String? v) {
    final p = double.tryParse(v?.trim() ?? '');
    if (p == null || p <= 0) return 'Enter a price greater than 0';
    return null;
  }

  String? _validStock(String? v) {
    final s = int.tryParse(v?.trim() ?? '');
    if (s == null || s < 0) return 'Enter a stock number of 0 or more';
    return null;
  }

  String? _validImageUrl(String? v) {
    final text = v?.trim() ?? '';
    if (text.isEmpty) return null; // optional field
    final uri = Uri.tryParse(text);
    final ok = uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return ok ? null : 'Enter a valid http(s) URL';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ألوان الزرار حسب الوضع الحالي
    final buttonBg = isDark ? AppColors.darkInk : AppColors.ink;
    final buttonFg = isDark ? AppColors.darkPaper : AppColors.paper;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: AppButtonStyles.filled(isDark),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: buttonFg,
                ),
              )
                  : const Text('Save product'),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputWidgets(
                label: 'Title',
                controller: _title,
                prefixIcon: Icons.title,
                validator: _required,
              ),
              InputWidgets(
                label: 'Description',
                controller: _description,
                prefixIcon: Icons.description,
                maxLines: 3,
                validator: _required,
              ),
              InputWidgets(
                label: 'Price',
                controller: _price,
                prefixIcon: Icons.attach_money,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                validator: _validPrice,
              ),
              InputWidgets(
                label: 'Stock',
                controller: _stock,
                prefixIcon: Icons.inventory_2,
                keyboardType: TextInputType.number,
                validator: _validStock,
              ),
              InputWidgets(
                label: 'Category',
                controller: _category,
                prefixIcon: Icons.category,
                validator: _required,
              ),
              InputWidgets(
                label: 'Image URL (optional)',
                controller: _imageUrl,
                prefixIcon: Icons.image,
                keyboardType: TextInputType.url,
                validator: _validImageUrl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}