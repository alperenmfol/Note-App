import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:note_app/features/auth/data/data_sources/auth_local_data_source.dart';

import '../../data/data_sources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRemoteDataSource authRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  AuthCubit({
    required this.authRemoteDataSource,
    required this.authLocalDataSource,
  }) : super(AuthInitial());

  Future<void> register(String email, String password, String fullName) async {
    emit(AuthLoading());

    try {
      final user = await authRemoteDataSource.register(
        email,
        password,
        fullName,
      );
      await authLocalDataSource.saveUser(user);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    try {
      final response = await authRemoteDataSource.login(email, password);

      await authLocalDataSource.saveUser(response);
      emit(AuthSuccess(user: response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await authRemoteDataSource.logout();
      await authLocalDataSource.clearUser();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure("Çıkış yapılamadı: $e"));
    }
  }
}
