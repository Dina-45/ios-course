import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../theme/app_colors.dart';
import 'catalog_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: BlocConsumer<AuthCubit, AuthState>(
              // LISTENER: разовые действия (SnackBar и переход)
              listener: (context, state) {
                if (state is AuthError) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                } else if (state is AuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const CatalogScreen()),
                  );
                }
              },
              // BUILDER: только рисует виджеты
              builder: (context, state) {
                final loading = state is AuthLoading;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.lock_outline,
                        size: 64, color: AppColors.navy),
                    const SizedBox(height: 12),
                    const Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Test account: student@narxoz.kz / 123456',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      enabled: !loading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _decoration('Email', Icons.email),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _passwordController,
                      enabled: !loading,
                      obscureText: _hidePassword,
                      decoration: _decoration(
                        'Password',
                        Icons.lock,
                        suffix: IconButton(
                          icon: Icon(_hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Во время загрузки кнопка заменяется на индикатор
                    SizedBox(
                      height: 54,
                      child: loading
                          ? const Center(child: CircularProgressIndicator())
                          : FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.navy,
                                foregroundColor: AppColors.lime,
                              ),
                              onPressed: () => context.read<AuthCubit>().login(
                                    _emailController.text,
                                    _passwordController.text,
                                  ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 16),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
