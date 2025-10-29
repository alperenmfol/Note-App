import 'package:go_router/go_router.dart';
import 'package:note_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:note_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:note_app/features/auth/presentation/pages/welcome_page.dart';

//GoRouter kütüphanesini kullanıyoruz
//Bu kütüphanede route isimlerini ve builder fonksiyonlarını tanımlıyoruz
final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      name: "welcome-page",
      path: "/",
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
  ],
);
