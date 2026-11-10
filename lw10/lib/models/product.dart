import 'package:flutter/material.dart';
import 'reward.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // rating приходит вложенным объектом: {"rate": 3.9, "count": 120}
    final ratingRaw = json['rating'];
    final ratingMap =
        ratingRaw is Map<String, dynamic> ? ratingRaw : <String, dynamic>{};

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? 'Untitled',
      // API может вернуть int (109) или double (109.95) — as num защищает от краша
      price: ((json['price'] as num?) ?? 0).toDouble(),
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'other',
      imageUrl: (json['image'] as String?) ?? '',
      rating: ((ratingMap['rate'] as num?) ?? 0).toDouble(),
      reviewCount: (ratingMap['count'] as num?)?.toInt() ?? 0,
    );
  }

  /// FakeStore отдаёт одну картинку, поэтому для карусели
  /// используем её 3 раза (в реальном API тут был бы список фото).
  List<String> get gallery => [imageUrl, imageUrl, imageUrl];

  /// Цена в Paw Points: 1 $ = 1 point
  int get pointsCost => price.round();

  /// Превращаем товар из API в Reward, чтобы работала уже готовая
  /// глобальная корзина (CartProvider / CartScreen).
  Reward toReward() => Reward(
        id: 'product_$id',
        name: title,
        description: description,
        cost: pointsCost,
        icon: Icons.card_giftcard,
        color: _categoryColor(category),
        imageUrl: imageUrl,
      );

  static Color _categoryColor(String category) {
    switch (category) {
      case "men's clothing":
        return const Color(0xFFC9D8FA);
      case "women's clothing":
        return const Color(0xFFF7C6D9);
      case 'jewelery':
        return const Color(0xFFFFE3A3);
      case 'electronics':
        return const Color(0xFFC8EBD6);
      default:
        return const Color(0xFFDCF05A);
    }
  }
}