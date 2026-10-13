import 'package:flutter/material.dart';
import '../widgets/paw_bottom_nav.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;
  final Set<String> _favorites = {};

  void _toggleFavorite(String name) {
    setState(() {
      if (!_favorites.remove(name)) _favorites.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(favorites: _favorites, onToggleFavorite: _toggleFavorite),
      FavoritesScreen(favorites: _favorites, onToggleFavorite: _toggleFavorite),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: PawBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}