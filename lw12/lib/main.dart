import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_cubit.dart';
import 'blocs/cart_bloc.dart';
import 'screens/login_screen.dart';
import 'theme/app_colors.dart';

void main() => runApp(const ShopApp());

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Провайдеры стоят НАД MaterialApp, поэтому видны на всех экранах
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'Enterprise Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
