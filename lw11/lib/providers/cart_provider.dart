import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/reward.dart';

class CartProvider extends ChangeNotifier {

  static const int balance = 240;

  final List<Reward> _items = [];

  UnmodifiableListView<Reward> get items => UnmodifiableListView(_items);
  int get count => _items.length;
  int get total => _items.fold(0, (sum, r) => sum + r.cost);
  int get remaining => balance - total;
  bool get isOverBudget => remaining < 0;

  bool contains(Reward r) => _items.any((e) => e.id == r.id);

  void toggle(Reward r) {
    if (contains(r)) {
      _items.removeWhere((e) => e.id == r.id);
    } else {
      _items.add(r);
    }
    notifyListeners();
  }

  void remove(Reward r) {
    _items.removeWhere((e) => e.id == r.id);
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}