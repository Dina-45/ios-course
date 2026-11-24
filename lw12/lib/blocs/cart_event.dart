import 'package:equatable/equatable.dart';
import '../models/product.dart';

// События корзины: что произошло в интерфейсе.
abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddProductEvent extends CartEvent {
  final Product product;

  const AddProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class RemoveProductEvent extends CartEvent {
  final int productId;

  const RemoveProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
