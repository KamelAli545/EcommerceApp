import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/auth_cubit.dart';
import 'package:nexshop/screens/registerScreens.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/app_button_styles.dart';
import 'package:nexshop/widgets/inputWidget.dart';
import 'package:nexshop/widgets/theme_toggle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ألوان النص حسب الوضع الحالي
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.muted;
    final brandColor = isDark ? AppColors.darkInk : AppColors.ink;
    final buttonFg = isDark ? AppColors.darkPaper : AppColors.paper;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'nexshop',
                              style: AppText.brand().copyWith(color: brandColor),
                            ),
                          ),
                          const ThemeToggle(),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Text(
                        'Sign in',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Use the email you registered with.',
                        style: TextStyle(color: mutedColor),
                      ),
                      const SizedBox(height: 32),
                      InputWidgets(
                        label: 'Email',
                        prefixIcon: Icons.mail_outline,
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v == null || !v.contains('@'))
                            ? 'Enter a valid email'
                            : null,
                        autofillHints: const [AutofillHints.email],
                      ),
                      InputWidgets(
                        label: 'Password',
                        prefixIcon: Icons.lock_outline,
                        controller: _password,
                        obscureText: true,
                        validator: (v) => (v == null || v.length < 6)
                            ? 'Password must be at least 6 characters'
                            : null,
                        autofillHints: const [AutofillHints.password],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: AppButtonStyles.filled(isDark),
                          onPressed: loading
                              ? null
                              : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().login(
                                _email.text,
                                _password.text,
                              );
                            }
                          },
                          child: loading
                              ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: buttonFg,
                            ),
                          )
                              : const Text('Sign in'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GoogleSignInButton(
                        loadingIndicator: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: brandColor,
                          ),
                        ),
                        clientId:
                        "633426816486-0dskheoj4lbj3anjctsubovvkqr2bh92.apps.googleusercontent.com",
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        child: const Text('New here? Create an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}