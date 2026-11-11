import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nexshop/model/userService.dart';
import 'package:nexshop/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _email = FirebaseAuth.instance.currentUser?.email ?? '';

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await UserService().getCurrentProfile();
      _name.text = data?['name'] as String? ?? '';
      _phone.text = data?['phone'] as String? ?? '';
      _address.text = data?['address'] as String? ?? '';
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await UserService().updateCurrentProfile(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
        address: _address.text.trim(),
      );

      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update profile')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // تحديث الديكور ليأخذ ألوان الثيم الحالي بمرونة (Dark / Light)
  InputDecoration _decoration(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? AppColors.darkMuted : AppColors.muted,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkFieldEdge : AppColors.fieldEdge,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkInk : AppColors.ink,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        borderSide: BorderSide(
          color: isDark ? AppColors.darkHairline : AppColors.hairline,
        ),
      ),
      filled: true,
      fillColor: isDark ? AppColors.darkImageWell : AppColors.imageWell,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkInk : AppColors.ink;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _email,
                  enabled: false,
                  style: TextStyle(color: textColor),
                  decoration: _decoration(context, 'Email'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _name,
                  style: TextStyle(color: textColor),
                  decoration: _decoration(context, 'Full Name'),
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter your name'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: textColor),
                  decoration: _decoration(context, 'Phone'),
                  validator: (v) => v == null || v.trim().length < 8
                      ? 'Enter a valid phone number'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _address,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.words,
                  minLines: 1,
                  maxLines: 3,
                  style: TextStyle(color: textColor),
                  decoration: _decoration(context, 'Address (delivery area)')
                      .copyWith(
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}