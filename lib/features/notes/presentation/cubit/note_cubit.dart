import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/network.dart';
import 'package:note_app/features/notes/data/data_sources/note_local_data_source.dart';
import 'package:note_app/features/notes/data/data_sources/note_remote_data_source.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';

import '../../../auth/data/data_sources/auth_local_data_source.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRemoteDataSource remoteDataSource;
  final NoteLocalDataSource localDataSource;
  final AuthLocalDataSource authLocalDataSource;

  NoteCubit({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.authLocalDataSource,
  }) : super(NoteInitial());

  //notların hepsini getir
  Future<void> getAllNotes() async {
    emit(NoteLoading());
    try {
      List<Note> notes = [];

      try {
        if (await hasInternetConnection()) {
          notes = await remoteDataSource.getNotes();
        }

        // Başarılıysa locale kaydet
        await localDataSource.cacheNotes(notes);
      } catch (_) {
        // İnternet yoksa localden getir
        notes = await localDataSource.getAllNotes();
      }

      notes.sort((a, b) {
        if (a.isPinned == b.isPinned) {
          return b.updatedAt.compareTo(a.updatedAt);
        }
        return b.isPinned ? 1 : -1;
      });

      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError("Notlar yüklenemedi: $e"));
    }
  }

  //not ekleme
  Future<void> addNote(Note note) async {
    try {
      final user = await authLocalDataSource.getUser();
      final userId = user?.userId ?? '';

      final noteWithUser = note.copyWith(userId: userId);

      // local not ekleme
      await localDataSource.addNote(noteWithUser);

      // remote not ekleme
      if (await hasInternetConnection()) {
        await remoteDataSource.addNote(noteWithUser);
      }

      final notes = await remoteDataSource.getNotes();
      notes.sort((a, b) {
        if (a.isPinned == b.isPinned) {
          return b.updatedAt.compareTo(a.updatedAt);
        }
        return b.isPinned ? 1 : -1;
      });
      emit(NoteLoaded(notes));

    } catch (e) {
      emit(NoteError("Not eklenemedi: $e"));
    }
  }

  //nol güncelleme
  Future<void> updateNote(Note note) async {
    try {
      final user = await authLocalDataSource.getUser();
      final userId = user?.userId ?? '';

      final noteWithUser = note.copyWith(userId: userId);

      print("Note id:${note.id}");
      // local not güncelleme
      await localDataSource.updateNote(noteWithUser);

      final notes = await localDataSource.getAllNotes();

      notes.sort((a, b) {
        if (a.isPinned == b.isPinned) {
          return b.updatedAt.compareTo(a.updatedAt);
        }
        return b.isPinned ? 1 : -1;
      });
      emit(NoteUpdated(noteWithUser));
      emit(NoteLoaded(notes));

      // remote not güncelleme
      if (await hasInternetConnection()) {
        await remoteDataSource.updateNote(noteWithUser);
      }
    } catch (e) {
      emit(NoteError("Not güncellenemedi: $e"));
    }
  }

  //nol silme
  Future<void> deleteNote(String noteId) async {
    try {
      await localDataSource.deleteNote(noteId);

      final notes = await localDataSource.getAllNotes();

      notes.sort((a, b) {
        if (a.isPinned == b.isPinned) {
          return b.updatedAt.compareTo(a.updatedAt);
        }
        return b.isPinned ? 1 : -1;
      });

      emit(NoteDeleted(noteId));
      emit(NoteLoaded(notes));

      if (await hasInternetConnection()) {
        await remoteDataSource.deleteNote(noteId);
      }
    } catch (e) {
      emit(NoteError("Not silinemedi: $e"));
    }
  }

  //notlar içinde arama
  Future<void> searchNotes(String query) async {
    try {
      final notes = await localDataSource.getAllNotes();

      List<Note> filteredNotes;

      if (query.isEmpty) {
        filteredNotes = List.from(notes);
      } else {
        filteredNotes = notes.where((note) {
          final title = (note.title ?? '').toLowerCase();
          final content = (note.content ?? '').toLowerCase();
          final lowerQuery = query.toLowerCase();

          return title.contains(lowerQuery) || content.contains(lowerQuery);
        }).toList();
      }

      filteredNotes.sort((a, b) {
        if (a.isPinned == b.isPinned) {
          return b.updatedAt.compareTo(a.updatedAt);
        }
        return b.isPinned ? 1 : -1;
      });

      emit(NoteLoaded(filteredNotes));
    } catch (e) {
      emit(NoteError("Arama sırasında hata oluştu: $e"));
    }
  }

  //notları filtreleme
  Future<void> filterNotes(String filter) async {
    final notes = await localDataSource.getAllNotes();

    List<Note> filtered = [];

    switch (filter) {
      case "Pinned":
        filtered = notes.where((n) => n.isPinned).toList();
        break;
      case "Favorites":
        filtered = notes.where((n) => n.isFavorite).toList();
        break;
      default:
        filtered = notes;
    }

    filtered.sort((a, b) {
      if (a.isPinned == b.isPinned) {
        return b.updatedAt.compareTo(a.updatedAt);
      }
      return b.isPinned ? 1 : -1;
    });

    emit(NoteLoaded(filtered));
  }


}
