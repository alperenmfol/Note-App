import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/core/theme/app_theme.dart';
import 'package:note_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:note_app/features/auth/domain/entities/user.dart';
import 'package:note_app/features/auth/presentation/cubit/splash_cubit.dart';
import 'package:note_app/features/main%20navigation/presentation/cubit/navigation_cubit.dart';
import 'package:note_app/features/main%20navigation/presentation/cubit/theme_cubit.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/data/data_sources/auth_local_data_source.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/cubit/obscure_cubit.dart';
import 'features/main navigation/presentation/cubit/profile_cubit.dart';
import 'features/notes/data/data_sources/note_local_data_source.dart';
import 'features/notes/data/data_sources/note_remote_data_source.dart';
import 'features/notes/presentation/cubit/note_cubit.dart';
import 'navigation/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Hive.initFlutter();

  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(NoteAdapter());

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //GoRouter konfigürasyonu
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ObscureCubit()),
        BlocProvider(
          create:
              (context) => AuthCubit(
                authRemoteDataSource: AuthRemoteDataSource(),
                authLocalDataSource: AuthLocalDataSource(),
              ),
        ),
        BlocProvider(
          create:
              (context) =>
                  SplashCubit(authLocalDataSource: AuthLocalDataSource()),
        ),
        BlocProvider(
          create:
              (context) => NoteCubit(
                remoteDataSource: NoteRemoteDataSource(),
                localDataSource: NoteLocalDataSource(),
                authLocalDataSource: AuthLocalDataSource(),
              )..getAllNotes(),
        ),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(
          create:
              (context) =>
                  ProfileCubit(authLocalDataSource: AuthLocalDataSource())
                    ..loadUser(),
        ),
        BlocProvider(create: (context) => ThemeCubit()..loadTheme()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, state) {
          return MaterialApp.router(
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
            themeMode: state ? ThemeMode.dark : ThemeMode.light,
            //Routerı tanımlama
            routerConfig: router,
          );
        },
      ),
    );
  }
}
