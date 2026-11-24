import 'package:equatable/equatable.dart';
import '../models/product.dart';

// Неизменяемое состояние корзины.
class CartState extends Equatable {
  final List<Product> items;

  const CartState({this.items = const []});

  double get totalPrice => items.fold<double>(0, (sum, p) => sum + p.price);

  int get count => items.length;

  @override
  List<Object?> get props => [items];
}
