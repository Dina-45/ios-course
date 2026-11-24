import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';
import '../blocs/cart_state.dart';
import '../theme/app_colors.dart';
import '../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Cart (${state.count})',
                style: const TextStyle(fontWeight: FontWeight.w800)),
            backgroundColor: AppColors.background,
          ),
          body: state.items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Your cart is empty',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy)),
                      Text('Go back and add some products',
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.items.length,
                        itemBuilder: (context, i) {
                          final p = state.items[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                ProductImage(
                                    url: p.imageUrl, width: 56, height: 56),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.navy),
                                      ),
                                      Text(
                                        '\$${p.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Remove',
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.red),
                                  onPressed: () => context
                                      .read<CartBloc>()
                                      .add(RemoveProductEvent(p.id)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SafeArea(
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
                            _row('Items', '${state.count}', Colors.white70),
                            const SizedBox(height: 4),
                            _row(
                              'Total',
                              '\$${state.totalPrice.toStringAsFixed(2)}',
                              Colors.white,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.white54),
                                ),
                                onPressed: () => context
                                    .read<CartBloc>()
                                    .add(const ClearCartEvent()),
                                icon: const Icon(Icons.delete_sweep),
                                label: const Text('Clear All'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
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
