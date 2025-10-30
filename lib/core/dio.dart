import 'package:dio/dio.dart';

class DioSetup {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8080", // Android emulator için
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );
}