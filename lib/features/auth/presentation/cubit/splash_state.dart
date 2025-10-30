part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  const SplashAuthenticated();

  @override
  List<Object?> get props => [];
}

class SplashUnauthenticated extends SplashState {}

class SplashError extends SplashState {
  final String message;
  const SplashError(this.message);

  @override
  List<Object?> get props => [message];
}
