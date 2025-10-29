import 'package:flutter/material.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Montserrat",
        useMaterial3: true,
        colorScheme: MaterialTheme.lightScheme(),
      ),
      darkTheme: ThemeData(
        fontFamily: "Montserrat",
        useMaterial3: true,
        colorScheme: MaterialTheme.darkScheme(),
      ),
      themeMode: ThemeMode.system,
      home: LoginPage(),
    );
  }
}