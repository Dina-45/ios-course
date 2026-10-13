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