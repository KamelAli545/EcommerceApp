import 'package:flutter/material.dart';
import 'package:nexshop/theme/app_theme.dart';

class InputWidgets extends StatefulWidget {
  const InputWidgets({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType,
    this.validator,
    this.readOnly = false,
    this.obscureText = false,
    this.prefixIcon,
    this.maxLines = 1,
    this.helperText,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onSubmitted,
    this.isSearch = false,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool readOnly;
  final bool obscureText;
  final bool isSearch;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final int maxLines;
  final String? helperText;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onSubmitted;

  @override
  State<InputWidgets> createState() => _InputWidgetsState();
}

class _InputWidgetsState extends State<InputWidgets> {
  final _focus = FocusNode();
  late bool _hidden = widget.obscureText;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.label.toLowerCase();
    final multiline = widget.maxLines > 1 && !widget.obscureText;

    // التحقق من حالة الثيم الحالي لتحديد الألوان بدقة
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkInk : AppColors.ink;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.muted;

    return Padding(
      padding: EdgeInsets.only(bottom: widget.isSearch ? 0 : 20),
      child: TextFormField(
        focusNode: _focus,
        controller: widget.controller,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        autofillHints: widget.autofillHints,
        textInputAction: widget.textInputAction ??
            (multiline ? TextInputAction.newline : TextInputAction.next),
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        readOnly: widget.readOnly,
        obscureText: _hidden,
        maxLines: multiline ? widget.maxLines : 1,
        cursorColor: textColor,
        style: TextStyle(color: textColor, fontSize: 16),
        decoration: InputDecoration(
          // البحث مالوش label، بس hint
          labelText: widget.isSearch ? null : widget.label,
          hintText: widget.isSearch ? widget.label : null,
          helperText: widget.helperText,
          prefixIcon: widget.prefixIcon == null
              ? null
              : Icon(
            widget.prefixIcon,
            color: _focused ? textColor : mutedColor,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
            tooltip: _hidden ? 'Show $name' : 'Hide $name',
            icon: Icon(
              _hidden ? Icons.visibility_off : Icons.visibility,
              color: mutedColor,
            ),
            onPressed: () => setState(() => _hidden = !_hidden),
          )
              : null,
          border: widget.isSearch
              ? OutlineInputBorder(borderRadius: BorderRadius.circular(30))
              : null,
        ),
      ),
    );
  }
}