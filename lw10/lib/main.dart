import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'screens/main_screen.dart';
import 'theme/app_colors.dart';

void main() => runApp(const PawTimeApp());

class PawTimeApp extends StatelessWidget {
  const PawTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'PawTime',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.navy),
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}