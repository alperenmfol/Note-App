import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/splash_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().checkSession();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        if (state is SplashAuthenticated) {
          //widgetların tamamı build olduktan sonra çalışan bir fonksiyon
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed("notes-list-page");
          });
        } else if (state is SplashUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.goNamed("welcome-page");
          });
        }

        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_note_outlined, size: 100),
                Text(
                  "Note It",
                  style: TextStyle(fontSize: 50, fontFamily: "MontserratBold"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
