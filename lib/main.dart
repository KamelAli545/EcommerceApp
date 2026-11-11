import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexshop/cubit/auth_cubit.dart';
import 'package:nexshop/cubit/cart_cubit.dart';
import 'package:nexshop/cubit/product_cubit.dart';
import 'package:nexshop/firebase_options.dart';
import 'package:nexshop/screens/loginScreen.dart';
import 'package:nexshop/theme/app_theme.dart';
import 'package:nexshop/widgets/adminShell.dart';
import 'package:nexshop/widgets/mainShell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(create: (_) => CartCubit()),
      ],
      // لما المستخدم يخرج، نفضّي الكارت عشان اليوزر الجديد ما يشوفش حاجة غيره
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, current) => current is AuthInitial,
        listener: (context, _) => context.read<CartCubit>().clear(),
        child: ThemeProvider(
          initTheme: AppTheme.light(),
          builder: (context,theme)=>
              MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theme,
                home: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    if (state is AuthChecking) {
                      return const Scaffold(body: SizedBox.shrink());
                    }
                    if (state is AuthAuthenticated) {
                      return state.role == 'admin'
                          ? const AdminShell()
                          : const MainShell();
                    }
                    return const LoginScreen();
                  },
                ),
              ),

        ),
      ),
    );
  }
}