import 'package:flutter/material.dart';

class Dog {
  final String name;
  final String breed;
  final String age;
  final String energy;
  final String description;
  final String imageAsset;
  final Color color;
  final List<String> tags;

  const Dog({
    required this.name,
    required this.breed,
    required this.age,
    required this.energy,
    required this.description,
    required this.imageAsset,
    required this.color,
    required this.tags,
  });
}

const List<Dog> demoDogs = [
  Dog(
    name: 'Max',
    breed: 'Labrador',
    age: '3 years',
    energy: 'High',
    description:
        'Max loves people and long walks. He walks well on a leash and is a great first dog for new walkers.',
    imageAsset: 'assets/images/max.png',
    color: Color(0xFFC8EBD6),
    tags: ['Friendly', 'Active', 'Beginner-friendly'],
  ),
  Dog(
    name: 'Luna',
    breed: 'Mixed breed',
    age: '2 years',
    energy: 'Medium',
    description:
        'Luna is a quiet girl who enjoys slow walks and being petted. She is a bit shy with strangers at first.',
    imageAsset: 'assets/images/luna.png',
    color: Color(0xFFC9D8FA),
    tags: ['Calm', 'Gentle', 'Beginner-friendly'],
  ),
  Dog(
    name: 'Rocky',
    breed: 'Beagle',
    age: '5 years',
    energy: 'Very high',
    description:
        'Rocky has lots of energy and needs an active walker. He loves sniffing around and exploring.',
    imageAsset: 'assets/images/rocky.png',
    color: Color(0xFFF9D2BE),
    tags: ['Energetic', 'Curious', 'Experienced walkers'],
  ),
  Dog(
    name: 'Bella',
    breed: 'Husky',
    age: '4 years',
    energy: 'High',
    description:
        'Bella is a smart and playful husky. She loves running and needs a confident walker.',
    imageAsset: 'assets/images/bella.png',
    color: Color(0xFFDCF05A),
    tags: ['Playful', 'Smart', 'Experienced walkers'],
  ),
];

// НОВОЕ: "новые собаки приюта". При pull-to-refresh мы берём
// по одной собаке из этого списка и добавляем её в начало ленты.
// Картинок для них нет -> DogImage сам покажет значок лапки (errorBuilder).
const List<Dog> newArrivals = [
  Dog(
    name: 'Charlie',
    breed: 'Corgi',
    age: '1 year',
    energy: 'High',
    description:
        'Charlie just arrived at the shelter. He is funny, friendly and loves short, quick walks.',
    imageAsset: 'assets/images/charlie.png',
    color: Color(0xFFFFE3A3),
    tags: ['New', 'Funny', 'Beginner-friendly'],
  ),
  Dog(
    name: 'Daisy',
    breed: 'Spaniel',
    age: '6 years',
    energy: 'Low',
    description:
        'Daisy is a calm older girl. She likes slow walks and sitting in the sun.',
    imageAsset: 'assets/images/daisy.png',
    color: Color(0xFFF7C6D9),
    tags: ['New', 'Calm', 'Gentle'],
  ),
  Dog(
    name: 'Milo',
    breed: 'Shepherd',
    age: '3 years',
    energy: 'Very high',
    description:
        'Milo is strong and smart. He needs an experienced walker who can keep up with him.',
    imageAsset: 'assets/images/milo.png',
    color: Color(0xFFBFE3F5),
    tags: ['New', 'Smart', 'Experienced walkers'],
  ),
  Dog(
    name: 'Coco',
    breed: 'Poodle',
    age: '2 years',
    energy: 'Medium',
    description:
        'Coco is a clever little poodle. She loves attention and learning new tricks.',
    imageAsset: 'assets/images/coco.png',
    color: Color(0xFFD9CCF5),
    tags: ['New', 'Clever', 'Beginner-friendly'],
  ),
];

// НОВОЕ: все собаки вместе. Нужен экрану Favorites,
// чтобы он находил и новых собак тоже.
final List<Dog> allDogs = [...demoDogs, ...newArrivals];