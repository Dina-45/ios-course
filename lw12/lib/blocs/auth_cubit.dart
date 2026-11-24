import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  static const _validEmail = 'student@narxoz.kz';
  static const _validPassword = '123456';

  Future<void> login(String email, String password) async {
    // 1) Сообщаем экрану, что идёт проверка
    emit(const AuthLoading());

    // 2) Имитация запроса к серверу
    await Future.delayed(const Duration(seconds: 2));

    final cleanEmail = email.trim();

    // 3) Результат: либо ошибка, либо успех
    if (cleanEmail.isEmpty || password.isEmpty) {
      emit(const AuthError('Please enter email and password'));
    } else if (cleanEmail == _validEmail && password == _validPassword) {
      emit(AuthSuccess(
        username: cleanEmail.split('@').first,
        email: cleanEmail,
      ));
    } else {
      emit(const AuthError('Invalid email or password'));
    }
  }
}
