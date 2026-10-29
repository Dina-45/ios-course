import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const GroceryApp());

class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Grocery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const GroceryScreen(),
    );
  }
}

class GroceryItem {
  final int id; // уникальный id нужен для ValueKey в Dismissible
  final String name;
  final double price;
  const GroceryItem({required this.id, required this.name, required this.price});
}

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  static const _catalog = [
    ('Milk', 1.2), ('Bread', 0.8), ('Eggs', 2.5), ('Apples', 1.9),
    ('Bananas', 1.4), ('Cheese', 4.2), ('Tomatoes', 2.1), ('Rice', 1.7),
    ('Chicken', 5.6), ('Yogurt', 1.1), ('Butter', 3.0), ('Pasta', 1.3),
    ('Coffee', 6.5), ('Tea', 2.8), ('Cucumbers', 1.6), ('Oranges', 2.3),
  ];

  final _random = Random();
  int _nextId = 0;
  late final List<GroceryItem> _items;

  GroceryItem _item(int catalogIndex) {
    final p = _catalog[catalogIndex];
    return GroceryItem(id: _nextId++, name: p.$1, price: p.$2);
  }

  @override
  void initState() {
    super.initState();
    // Шаг 1: 10 начальных элементов
    _items = List.generate(10, (i) => _item(i));
  }

  // Шаг 2: pull-to-refresh с задержкой 1.5 сек
  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _items.insertAll(0, [
        _item(_random.nextInt(_catalog.length)),
        _item(_random.nextInt(_catalog.length)),
      ]);
    });
  }

  // Шаг 3 и 4: удаление и SnackBar с UNDO
  void _removeItem(int index) {
    final removed = _items[index];
    setState(() => _items.removeAt(index));

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('${removed.name} deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              setState(() => _items.insert(min(index, _items.length), removed));
            },
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Smart Grocery (${_items.length})')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _items.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('List is empty.\nPull down to add items.',
                      textAlign: TextAlign.center)),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _items.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, indent: 16, endIndent: 16),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _removeItem(index),
                    child: ListTile(
                      leading: const CircleAvatar(
                          child: Icon(Icons.shopping_basket)),
                      title: Text(item.name),
                      subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                      trailing: const Icon(Icons.chevron_left),
                    ),
                  );
                },
              ),
      ),
    );
  }
}