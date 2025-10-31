import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/core/dio.dart';
import 'package:note_app/features/notes/data/models/note_model.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NoteRemoteDataSource {
  final Dio dio = DioSetup().dio;
  final SupabaseClient supaBase = Supabase.instance.client;

  //not ekleme
  Future<Note> addNote(Note note) async {
    try {
      final token = supaBase.auth.currentSession?.accessToken;
      if (token == null) throw Exception("Token alınamadı");

      final created = DateTime.now().toUtc();
      final updated = DateTime.now().toUtc();

      final response = await dio.post(
        '/notes',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {
          "title": note.title,
          "content": note.content,
          "pinned": note.isPinned,
          "favorite": note.isFavorite,
          "created_at": created.toIso8601String(),
          "updated_at": updated.toIso8601String(),
        },
      );

      if (response.statusCode != 200) {
        debugPrint("⚠️ FastAPI note add status: ${response.statusCode}");
      } else {
        debugPrint("✅ Note eklendi");
      }


      return NoteModel.fromJson(response.data['note']);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("❌ Dio backend error: ${e.response?.data}");
        throw Exception(e.response?.data['detail'] ?? "Sunucu hatası");
      } else {
        debugPrint("⚠️ Dio network error: ${e.message}");
        throw Exception("Bağlantı hatası: ${e.message}");
      }
    } catch (e) {
      debugPrint("⚠️ Beklenmeyen hata: $e");
      throw Exception("Bir hata oluştu: $e");
    }
  }

  //bütün notlar
  Future<List<Note>> getNotes() async {
    try {
      final token = supaBase.auth.currentSession?.accessToken;
      if (token == null) throw Exception("Token alınamadı");

      final response = await dio.get(
        '/notes',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200) {
        debugPrint("⚠️ FastAPI get notes status: ${response.statusCode}");
      }

      final notesData = response.data['notes'] as List<dynamic>;
      return notesData.map((item) => NoteModel.fromJson(item)).toList();
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("❌ Dio backend error: ${e.response?.data}");
        throw Exception(e.response?.data['detail'] ?? "Sunucu hatası");
      } else {
        debugPrint("⚠️ Dio network error: ${e.message}");
        throw Exception("Bağlantı hatası: ${e.message}");
      }
    } catch (e) {
      debugPrint("⚠️ Beklenmeyen hata: $e");
      throw Exception("Bir hata oluştu: $e");
    }
  }

  //not güncelleme
  Future<Note> updateNote(Note note) async {
    try {
      if (note.id.isEmpty) {
        throw Exception("Güncelleme için note.id boş olamaz");
      }

      final token = supaBase.auth.currentSession?.accessToken;
      if (token == null) throw Exception("Token alınamadı");

      final updated = DateTime.now().toUtc();

      final response = await dio.put(
        '/notes/${note.id}',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {
          "title": note.title,
          "content": note.content,
          "pinned": note.isPinned,
          "favorite": note.isFavorite,
          "created_at":
              DateTime.now().toUtc().toIso8601String(),
          "updated_at": updated.toIso8601String(),
        },
      );

      if (response.statusCode != 200) {
        debugPrint("⚠️ FastAPI update note status: ${response.statusCode}");
      } else {
        debugPrint("✅ Note güncellendi");
      }

      return NoteModel.fromJson(response.data['note'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("❌ Dio backend error: ${e.response?.data}");
        throw Exception(e.response?.data['detail'] ?? "Sunucu hatası");
      } else {
        debugPrint("⚠️ Dio network error: ${e.message}");
        throw Exception("Bağlantı hatası: ${e.message}");
      }
    } catch (e) {
      debugPrint("⚠️ Beklenmeyen hata: $e");
      throw Exception("Bir hata oluştu: $e");
    }
  }

  //not silme
  Future<void> deleteNote(String noteId) async {
    try {
      final token = supaBase.auth.currentSession?.accessToken;
      if (token == null) throw Exception("Token alınamadı");

      final response = await dio.delete(
        '/notes/$noteId',
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200) {
        debugPrint("⚠️ FastAPI delete note status: ${response.statusCode}");
      } else {
        debugPrint("🗑️ Note silindi");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("❌ Dio backend error: ${e.response?.data}");
        throw Exception(e.response?.data['detail'] ?? "Sunucu hatası");
      } else {
        debugPrint("⚠️ Dio network error: ${e.message}");
        throw Exception("Bağlantı hatası: ${e.message}");
      }
    } catch (e) {
      debugPrint("⚠️ Beklenmeyen hata: $e");
      throw Exception("Bir hata oluştu: $e");
    }
  }
}
