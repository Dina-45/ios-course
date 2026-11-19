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
    final ratingRaw = json['rating'];
    final ratingMap =
        ratingRaw is Map<String, dynamic> ? ratingRaw : <String, dynamic>{};

    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: (json['title'] as String?) ?? 'Untitled',
      price: ((json['price'] as num?) ?? 0).toDouble(),
      description: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? 'other',
      imageUrl: (json['image'] as String?) ?? '',
      rating: ((ratingMap['rate'] as num?) ?? 0).toDouble(),
      reviewCount: (ratingMap['count'] as num?)?.toInt() ?? 0,
    );
  }

  List<String> get gallery => [imageUrl, imageUrl, imageUrl];

  int get pointsCost => price.round();

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