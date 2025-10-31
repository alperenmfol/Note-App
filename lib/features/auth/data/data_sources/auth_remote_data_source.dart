import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:note_app/core/dio.dart';
import 'package:note_app/features/auth/data/models/user_model.dart';
import 'package:note_app/features/auth/domain/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

class AuthRemoteDataSource {
  final Dio dio = DioSetup().dio;
  final SupabaseClient supaBase = Supabase.instance.client;

  Future<User> register(String email, String password, String fullName) async {
    try {
      // Supabase ile kayıt ol
      final response = await supaBase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Registration failed");
      }

      // Token al
      final token = supaBase.auth.currentSession?.accessToken;
      if (token == null) {
        throw Exception("Token alınamadı");
      }

      // api endpointine isim güncellemesi gönder
      final updateResponse = await dio.put(
        '/user/fullname',
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {"full_name": fullName},
      );

      if (updateResponse.statusCode == 200) {
        debugPrint("✅ Full name başarıyla kaydedildi");
      } else {
        debugPrint("⚠️ FastAPI fullname update hata: ${updateResponse.statusCode}");
      }

      return UserModel(
        userId: response.user!.id,
        email: response.user!.email!,
        fullName: fullName,
      );
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

  Future<User> login(String email, String password) async {
    try {
      // Supabase login işlemi
      final response = await supaBase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception("Login failed: user is null");
      }

      // Token al
      final token = supaBase.auth.currentSession?.accessToken;
      if (token == null) {
        throw Exception("Token alınamadı");
      }

      //Profil verisini çek
      try {
        final profileResponse = await dio.get(
          '/user/profile',
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );

        if (profileResponse.statusCode == 200 &&
            profileResponse.data != null &&
            profileResponse.data['full_name'] != null) {
          return UserModel(
            userId: response.user!.id,
            email: response.user!.email ?? "",
            fullName: profileResponse.data['full_name'] ?? "",
          );
        } else {
          debugPrint("⚠️ Profile isteği başarılı ama veri eksik.");
        }
      } on DioException catch (e) {
        debugPrint("⚠️ Profile isteği başarısız: ${e.message}");
      }

      return UserModel(
        userId: response.user!.id,
        email: response.user!.email ?? "",
        fullName: "",
      );
    } on AuthException catch (e) {
      debugPrint("❌ Supabase Auth hatası: ${e.message}");
      throw Exception("Giriş başarısız: ${e.message}");
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint("❌ Dio backend hatası: ${e.response?.data}");
        throw Exception(e.response?.data['detail'] ?? "Sunucu hatası");
      } else {
        debugPrint("⚠️ Dio ağ hatası: ${e.message}");
        throw Exception("Bağlantı hatası: ${e.message}");
      }
    } catch (e) {
      debugPrint("⚠️ Beklenmeyen hata: $e");
      throw Exception("Bir hata oluştu: $e");
    }
  }

  Future<void> logout() async {
    try {
      await supaBase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

}
