import 'package:equatable/equatable.dart';

// Неизменяемые состояния авторизации.
// Equatable сравнивает состояния по значению (props), а не по ссылке.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String username;
  final String email;

  const AuthSuccess({required this.username, required this.email});

  @override
  List<Object?> get props => [username, email];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
