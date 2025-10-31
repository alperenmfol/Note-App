import 'package:go_router/go_router.dart';
import 'package:note_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:note_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:note_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:note_app/features/notes/presentation/pages/notes_list_page.dart';

import '../features/auth/presentation/pages/splash_page.dart';
import '../features/main navigation/presentation/pages/main_navigation_page.dart';
import '../features/notes/presentation/pages/add_note_page.dart';

//GoRouter kütüphanesini kullanıyoruz
//Bu kütüphanede route isimlerini ve builder fonksiyonlarını tanımlıyoruz
final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      name: "splash-page",
      builder: (context, state) {
        return const SplashPage();
      },
    ),
    GoRoute(
      name: "welcome-page",
      path: "/welcome-page",
      builder: (context, state) {
        return const WelcomePage();
      },
    ),
    GoRoute(
      name: "sign-in-page",
      path: "/sign-in-page",
      builder: (context, state) {
        return SignInPage();
      },
    ),
    GoRoute(
      name: "sign-up-page",
      path: "/sign-up-page",
      builder: (context, state) {
        return SignUpPage();
      },
    ),
    GoRoute(
      path: "/main-navigation-page",
      name: "main-navigation-page",
      builder: (context, state) {
        return const MainNavigationPage();
      },
    ),
    GoRoute(
      name: "notes-list-page",
      path: "/notes-list-page",
      builder: (context, state) {
        return NotesListPage();
      },
    ),
    GoRoute(
      name: "add-note-page",
      path: "/add-note-page",
      builder: (context, state) {
        final values = state.extra as Map<String, dynamic>? ?? {};
        return AddNotePage(
          note: values["note"],
          userId: values["userId"] ?? "",
        );
      },
    ),
  ],
);
