import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../theme/app_colors.dart';

class DogImage extends StatelessWidget {
  final Dog dog;
  final double? width;
  final double? height;
  final double iconSize;

  const DogImage({
    super.key,
    required this.dog,
    this.width,
    this.height,
    this.iconSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      dog.imageAsset,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: dog.color,
        child: Center(
          child: Icon(Icons.pets, size: iconSize, color: AppColors.navy),
        ),
      ),
    );
  }
}