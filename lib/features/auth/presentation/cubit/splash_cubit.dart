import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../domain/entities/user.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthLocalDataSource authLocalDataSource;

  SplashCubit({required this.authLocalDataSource}) : super(SplashInitial());

  Future<void> checkSession() async {
    emit(SplashLoading());

    try {
      final supaBase = Supabase.instance.client;
      final session = supaBase.auth.currentSession;

      if (session == null || session.expiresAt == null) {
        final user = await authLocalDataSource.getUser();
        if (user != null) {
          emit(SplashAuthenticated());
          return;
        }

        emit(SplashUnauthenticated());
        return;
      }

      final user = supaBase.auth.currentUser;
      if (user != null) {
        emit(SplashAuthenticated());
        return;
      }

      emit(SplashUnauthenticated());
    } catch (e) {
      final user = await authLocalDataSource.getUser();
      if (user != null) {
        emit(SplashAuthenticated());
      } else {
        emit(SplashError(e.toString()));
      }
    }
  }
}
