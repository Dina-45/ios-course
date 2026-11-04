import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../theme/app_colors.dart';
import 'dog_image.dart';

// Карточка собаки для режима "Grid" (2 колонки).
// В сетке свайпа нет, поэтому удаление сделано кнопкой-корзиной.
class DogGridCard extends StatelessWidget {
  final Dog dog;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onDelete;

  const DogGridCard({
    super.key,
    required this.dog,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias, // обрезаем фото по скруглённым углам
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Expanded: фото занимает всё свободное место,
            // поэтому переполнения (overflow) не будет
            Expanded(child: DogImage(dog: dog)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dog.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy)),
                  Text('${dog.breed} · ${dog.age}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54)),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Energy: ${dog.energy}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy)),
                      ),
                      IconButton(
                        onPressed: onFavoriteToggle,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        iconSize: 20,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 32),
                        iconSize: 20,
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.redAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}