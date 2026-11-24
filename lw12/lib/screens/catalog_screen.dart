import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_cubit.dart';
import '../blocs/auth_state.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';
import '../blocs/cart_state.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';
import '../widgets/product_image.dart';
import 'cart_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  List<Product> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final items = await ProductService.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = items;
        _loading = false;
      });
    } on ProductException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    }
  }

  void _addToCart(Product product) {
    // Отправляем СОБЫТИЕ в CartBloc
    context.read<CartBloc>().add(AddProductEvent(product));

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          backgroundColor: AppColors.navy,
          duration: const Duration(seconds: 1),
          content: Text('Added: ${product.title}',
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final name = auth is AuthSuccess ? auth.username : 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello, $name',
            style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: AppColors.background,
        actions: [
          // Живой счётчик корзины
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return IconButton(
                tooltip: 'Open cart',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
                icon: Badge(
                  isLabelVisible: state.count > 0,
                  label: Text('${state.count}'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _ErrorView(message: _error!, onRetry: _load);
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _products.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _ProductTile(
          product: _products[i],
          onAdd: () => _addToCart(_products[i]),
        ),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const _ProductTile({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          ProductImage(url: product.imageUrl, width: 72, height: 72),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: AppColors.navy),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: AppColors.lime,
            ),
            onPressed: onAdd,
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('Connection problem',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy)),
            const SizedBox(height: 6),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.lime,
              ),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
