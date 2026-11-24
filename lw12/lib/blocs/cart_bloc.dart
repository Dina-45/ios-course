import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    // Добавить товар: создаём НОВЫЙ список, старый не меняем
    on<AddProductEvent>((event, emit) {
      emit(CartState(items: [...state.items, event.product]));
    });

    // Удалить одну штуку товара по id
    on<RemoveProductEvent>((event, emit) {
      final list = [...state.items];
      final index = list.indexWhere((p) => p.id == event.productId);
      if (index != -1) list.removeAt(index);
      emit(CartState(items: list));
    });

    // Очистить корзину
    on<ClearCartEvent>((event, emit) {
      emit(const CartState());
    });
  }
}
