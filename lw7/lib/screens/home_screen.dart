import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../theme/app_colors.dart';
import '../widgets/dog_card.dart';
import '../widgets/dog_image.dart';
import 'dog_details_screen.dart';

class HomeScreen extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String name) onToggleFavorite;

  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
  });

  void _openDetails(BuildContext context, Dog dog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DogDetailsScreen(dog: dog)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextDog = demoDogs.first;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi, Aliya',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navy)),
                    Text('Who will you walk today?',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black54)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _Pill(
                icon: Icons.favorite,
                iconColor: Colors.red,
                text: '${favorites.length}',
                color: Colors.white,
              ),
              const SizedBox(width: 6),
              const _Pill(
                icon: Icons.pets,
                iconColor: AppColors.navy,
                text: '240',
                color: AppColors.lime,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Next walk',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: DogImage(dog: nextDog, width: 52, height: 52),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nextDog.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800)),
                          const Text('Today, 17:00 · 45 min',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.lime,
                      foregroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => _openDetails(context, nextDog),
                    child: const Text('View details',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Dogs waiting for a walk',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy)),
          const SizedBox(height: 12),
          ...demoDogs.map(
            (dog) => DogCard(
              dog: dog,
              isFavorite: favorites.contains(dog.name),
              onFavoriteToggle: () => onToggleFavorite(dog.name),
              onTap: () => _openDetails(context, dog),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final Color color;

  const _Pill({
    required this.icon,
    required this.iconColor,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  fontWeight: FontWeight.w800, color: AppColors.navy)),
        ],
      ),
    );
  }
}