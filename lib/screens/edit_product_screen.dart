import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/product_cubit.dart';
import 'package:nexshop/model/product.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/inputWidget.dart';
import 'package:nexshop/widgets/product_image.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final Product product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.product.title);
  late final _description =
  TextEditingController(text: widget.product.description);
  late final _price =
  TextEditingController(text: widget.product.price.toStringAsFixed(2));
  late final _stock = TextEditingController(text: '${widget.product.stock}');
  late final _category = TextEditingController(text: widget.product.category);
  late final _imageUrl = TextEditingController(text: widget.product.imageUrl);
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
      await context.read<ProductCubit>().updateProduct(
        Product(
          id: widget.product.id,
          title: _title.text.trim(),
          description: _description.text.trim(),
          price: double.parse(_price.text.trim()),
          stock: int.parse(_stock.text.trim()),
          category: _category.text.trim(),
          imageUrl: _imageUrl.text.trim(),
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save changes: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live preview: rebuilds whenever the image URL changes
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _imageUrl,
                builder: (_, value, __) => AspectRatio(
                  aspectRatio: 4 / 3,
                  child: ProductImage(
                    url: value.text.trim(),
                    title: _title.text,
                    radius: 8,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              InputWidgets(
                label: 'Title',
                controller: _title,
                prefixIcon: Icons.title,
                validator: _required,
              ),
              InputWidgets(
                label: 'Description',
                controller: _description,
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
                validator: _required,
              ),
              InputWidgets(
                label: 'Price',
                controller: _price,
                prefixIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) => double.tryParse(v?.trim() ?? '') == null
                    ? 'Enter a valid price'
                    : null,
              ),
              InputWidgets(
                label: 'Stock',
                controller: _stock,
                prefixIcon: Icons.inventory_2_outlined,
                keyboardType: TextInputType.number,
                validator: (v) => int.tryParse(v?.trim() ?? '') == null
                    ? 'Enter a valid number'
                    : null,
              ),
              InputWidgets(
                label: 'Category',
                controller: _category,
                prefixIcon: Icons.category_outlined,
                validator: _required,
              ),
              InputWidgets(
                label: 'Image URL (optional)',
                controller: _imageUrl,
                prefixIcon: Icons.image_outlined,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.paper,
                    ),
                  )
                      : const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}