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

  // НОВОЕ: бронирования. Ключ - имя собаки, значение - время прогулки.
  // Если имя собаки уже есть в Map, значит, она забронирована.
  final Map<String, String> _bookings = {};

  void _toggleFavorite(String name) {
    setState(() {
      if (!_favorites.remove(name)) _favorites.add(name);
    });
  }

  // НОВОЕ: вызывается из экрана деталей, когда нажали "Book a Walk"
  void _bookDog(String dogName, String slot) {
    setState(() => _bookings[dogName] = slot);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        bookings: _bookings,
        onBook: _bookDog,
      ),
      FavoritesScreen(
        favorites: _favorites,
        onToggleFavorite: _toggleFavorite,
        bookings: _bookings,
        onBook: _bookDog,
      ),
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