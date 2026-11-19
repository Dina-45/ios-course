import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';
import '../widgets/product_image.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  List<Product> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool fromPullToRefresh = false}) async {
    if (!fromPullToRefresh) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }

    try {
      final items = await ProductService.fetchProducts();
      if (!mounted) return;
      setState(() {
        _products = items;
        _loading = false;
        _error = null;
      });
    } on ProductException catch (e) {
      if (!mounted) return;
      if (fromPullToRefresh && _products.isNotEmpty) {
        // данные уже есть — не ломаем экран, просто сообщаем об ошибке
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      } else {
        setState(() {
          _loading = false;
          _error = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards shop',
            style: TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: AppColors.background,
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
            icon: Badge(
              isLabelVisible: cart.count > 0,
              label: Text('${cart.count}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 1) Loading
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) Error + Retry
    if (_error != null) {
      return _ErrorView(message: _error!, onRetry: _load);
    }

    // 3) Success
    return RefreshIndicator(
      onRefresh: () => _load(fromPullToRefresh: true),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _products.length + 1, // +1 — баннер с балансом
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == 0) return const _BalanceBanner();

          final product = _products[index - 1];
          return _RewardTile(
            product: product,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BalanceBanner extends StatelessWidget {
  const _BalanceBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lime,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.pets, color: AppColors.navy),
          const SizedBox(width: 8),
          const Text('Your balance',
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.navy)),
          const Spacer(),
          Text('${CartProvider.balance} pts',
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.navy)),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const _RewardTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final reward = product.toReward();
    final inCart = cart.contains(reward);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border:
                inCart ? Border.all(color: AppColors.navy, width: 2) : null,
          ),
          child: Row(
            children: [
              Hero(
                tag: 'product_image_${product.id}',
                child: ProductImage(
                  url: product.imageUrl,
                  width: 72,
                  height: 72,
                ),
              ),
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
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating.toStringAsFixed(1)} (${product.reviewCount})',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${product.pointsCost} pts',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              inCart
                  ? FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: AppColors.lime,
                      ),
                      onPressed: () => cart.toggle(reward),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('In cart'),
                    )
                  : OutlinedButton(
                      onPressed: () => cart.toggle(reward),
                      child: const Text('Add'),
                    ),
            ],
          ),
        ),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
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