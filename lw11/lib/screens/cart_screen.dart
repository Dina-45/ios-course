import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart (${cart.count})',
            style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: AppColors.background,
      ),
      body: cart.items.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 64, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Your cart is empty',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy)),
                  Text('Go back and pick some rewards',
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.items.length,
                    itemBuilder: (context, i) {
                      final r = cart.items[i];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: r.color,
                              backgroundImage:
                                r.imageUrl != null ? NetworkImage(r.imageUrl!) : null,
                              onBackgroundImageError: r.imageUrl != null ? (_, __) {} : null,
                              child: r.imageUrl == null
                                ? Icon(r.icon, color: AppColors.navy)
                                : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(r.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.navy)),
                                  Text('${r.cost} pts',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54)),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Remove',
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () => cart.remove(r),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _Summary(cart: cart),
              ],
            ),
    );
  }
}

class _Summary extends StatelessWidget {
  final CartProvider cart;
  const _Summary({required this.cart});

  @override
  Widget build(BuildContext context) {
    final over = cart.isOverBudget;

    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            _row('Total', '${cart.total} pts', Colors.white),
            const SizedBox(height: 4),
            _row('Balance', '${CartProvider.balance} pts', Colors.white70),
            const SizedBox(height: 4),
            _row('Remaining', '${cart.remaining} pts',
                over ? Colors.redAccent : AppColors.lime),
            if (over)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Not enough Paw Points — remove something',
                    style: TextStyle(color: Colors.redAccent, fontSize: 12)),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                ),
                onPressed: cart.clear,
                icon: const Icon(Icons.delete_sweep),
                label: const Text('Clear All'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color)),
        Text(value,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 16)),
      ],
    );
  }
}