import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_app/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:note_app/features/auth/domain/entities/user.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthLocalDataSource authLocalDataSource;

  ProfileCubit({required this.authLocalDataSource}) : super(ProfileInitial());

  Future<void> loadUser() async {
    emit(ProfileLoading());
    try {
      final user = await authLocalDataSource.getUser();


      if (user == null) {
        emit(ProfileError("Kullanıcı bulunamadı"));
        return;
      }

      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError("Kullanıcı bilgileri yüklenemedi: $e"));
    }
  }
}
