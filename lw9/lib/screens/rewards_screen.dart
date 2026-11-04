import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reward.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import 'cart_screen.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
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
          ),
          const SizedBox(height: 16),
          ...rewards.map((r) => _RewardTile(reward: r)),
        ],
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  final Reward reward;
  const _RewardTile({required this.reward});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final inCart = cart.contains(reward);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: inCart ? Border.all(color: AppColors.navy, width: 2) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: reward.color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(reward.icon, color: AppColors.navy, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reward.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: AppColors.navy)),
                Text(reward.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 4),
                Text('${reward.cost} pts',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: AppColors.navy)),
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
    );
  }
}