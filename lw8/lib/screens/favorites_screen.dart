import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../theme/app_colors.dart';
import '../widgets/dog_card.dart';
import 'dog_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<String> favorites;
  final void Function(String name) onToggleFavorite;
  final Map<String, String> bookings; // НОВОЕ
  final void Function(String dogName, String slot) onBook; // НОВОЕ

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.bookings,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    // allDogs вместо demoDogs: так находятся и новые собаки
    final saved = allDogs.where((d) => favorites.contains(d.name)).toList();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Favorites',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navy)),
          const SizedBox(height: 12),
          if (saved.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  Icon(Icons.favorite_border, size: 56, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('No favorites yet.\nTap ❤️ on a dog in the Feed.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            )
          else
            ...saved.map(
              (dog) => DogCard(
                dog: dog,
                isFavorite: true,
                onFavoriteToggle: () => onToggleFavorite(dog.name),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DogDetailsScreen(
                      dog: dog,
                      bookedSlot: bookings[dog.name],
                      onBook: onBook,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}