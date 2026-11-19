import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/cart_provider.dart';
import 'providers/vault_provider.dart';
import 'screens/main_screen.dart';
import 'theme/app_colors.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(PawTimeApp(prefs: prefs));
}

class PawTimeApp extends StatelessWidget {
  final SharedPreferences prefs;

  const PawTimeApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => VaultProvider(prefs)),
      ],
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