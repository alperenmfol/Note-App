import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/obscure_cubit.dart';
import 'navigation/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //GoRouter konfigürasyonu
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ObscureCubit())],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        //Karanlık ve aydınlık temaları tanımlama
        theme: ThemeData(
          //uygulama fontunu tanımlıyoruz
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
        //Routerı tanımlama
        routerConfig: router,
      ),
    );
  }
}
