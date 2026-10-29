import 'dart:math';
import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../theme/app_colors.dart';
import '../widgets/dog_card.dart';
import '../widgets/dog_grid_card.dart';
import '../widgets/dog_image.dart';
import 'dog_details_screen.dart';

// Теперь HomeScreen - StatefulWidget: у него есть своё состояние
// (список собак, режим List/Grid, счётчик новых собак).
class HomeScreen extends StatefulWidget {
  final Set<String> favorites;
  final void Function(String name) onToggleFavorite;
  final Map<String, String> bookings; // имя собаки -> выбранное время
  final void Function(String dogName, String slot) onBook;

  const HomeScreen({
    super.key,
    required this.favorites,
    required this.onToggleFavorite,
    required this.bookings,
    required this.onBook,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Dog> _dogs; // список, который мы меняем (удаляем / добавляем)
  bool _isGrid = false; // false = List, true = Grid
  int _arrivalIndex = 0; // сколько новых собак уже добавили

  @override
  void initState() {
    super.initState();
    _dogs = List.of(demoDogs); // копия, чтобы demoDogs не менялся
  }

  void _openDetails(Dog dog) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DogDetailsScreen(
          dog: dog,
          bookedSlot: widget.bookings[dog.name], // null, если ещё не бронировали
          onBook: widget.onBook,
        ),
      ),
    );
  }

  void _showMessage(String text, {SnackBarAction? action}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(text), action: action));
  }

  // ---------- Pull-to-Refresh ----------
  Future<void> _refresh() async {
    // имитация запроса в сеть - 1.5 секунды
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    if (_arrivalIndex >= newArrivals.length) {
      _showMessage('No new dogs right now');
      return;
    }

    final newDog = newArrivals[_arrivalIndex];
    setState(() {
      _dogs.insert(0, newDog); // новая собака - в самое начало
      _arrivalIndex++;
    });
    _showMessage('New dog arrived: ${newDog.name}');
  }

  // ---------- Удаление + UNDO ----------
  void _removeDog(Dog dog) {
    final index = _dogs.indexOf(dog); // запоминаем место собаки
    setState(() => _dogs.removeAt(index));

    _showMessage(
      '${dog.name} removed',
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          // возвращаем на то же место (min защищает от выхода за список)
          setState(() => _dogs.insert(min(index, _dogs.length), dog));
        },
      ),
    );
  }

  // ---------- Reset Catalog ----------
  void _resetCatalog() {
    setState(() {
      _dogs = List.of(demoDogs);
      _arrivalIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PawTime',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.navy)),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
        actions: [
          // кнопка переключения List <-> Grid
          IconButton(
            tooltip: _isGrid ? 'Show list' : 'Show grid',
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _dogs.isEmpty
            ? _buildEmptyState()
            : (_isGrid ? _buildGrid() : _buildList()),
      ),
    );
  }

  // ---------- Режим 1: List ----------
  Widget _buildList() {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      itemCount: _dogs.length + 1, // +1 = шапка (элемент с индексом 0)
      separatorBuilder: (context, index) {
        if (index == 0) return const SizedBox.shrink(); // после шапки линии нет
        return const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Divider(height: 1, color: Colors.black12),
        );
      },
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader();

        final dog = _dogs[index - 1]; // -1, потому что 0 занят шапкой
        return Dismissible(
          key: ValueKey(dog.name), // обязательный уникальный ключ
          direction: DismissDirection.endToStart, // свайп справа налево
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.only(right: 24),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.delete, color: Colors.white, size: 28),
          ),
          onDismissed: (_) => _removeDog(dog),
          child: DogCard(
            dog: dog,
            isFavorite: widget.favorites.contains(dog.name),
            onFavoriteToggle: () => widget.onToggleFavorite(dog.name),
            onTap: () => _openDetails(dog),
          ),
        );
      },
    );
  }

  // ---------- Режим 2: Grid (2 колонки) ----------
  Widget _buildGrid() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      children: [
        _buildHeader(),
        GridView.builder(
          shrinkWrap: true, // сетка внутри ListView: занимает только нужную высоту
          physics: const NeverScrollableScrollPhysics(), // скроллит внешний ListView
          itemCount: _dogs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final dog = _dogs[index];
            return DogGridCard(
              dog: dog,
              isFavorite: widget.favorites.contains(dog.name),
              onFavoriteToggle: () => widget.onToggleFavorite(dog.name),
              onTap: () => _openDetails(dog),
              onDelete: () => _removeDog(dog),
            );
          },
        ),
      ],
    );
  }

  // ---------- Пустое состояние ----------
  Widget _buildEmptyState() {
    // ListView, чтобы pull-to-refresh работал и на пустом экране
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      children: [
        _buildHeader(),
        const SizedBox(height: 24),
        const Icon(Icons.pets, size: 72, color: Colors.grey),
        const SizedBox(height: 12),
        const Text('Catalog is Empty',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy)),
        const SizedBox(height: 4),
        const Text('Pull down for new dogs or reset the list',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 16),
        Center(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: AppColors.lime,
            ),
            onPressed: _resetCatalog,
            icon: const Icon(Icons.restore),
            label: const Text('Reset Catalog'),
          ),
        ),
      ],
    );
  }

  // ---------- Шапка: приветствие + Next walk + заголовок ----------
  // (твой прежний код, просто вынесен в отдельный метод)
  Widget _buildHeader() {
    final nextDog = demoDogs.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              text: '${widget.favorites.length}',
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
          width: double.infinity,
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
                  onPressed: () => _openDetails(nextDog),
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
      ],
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