import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/features/main%20navigation/presentation/cubit/navigation_cubit.dart';

import 'profile_page.dart';
import '../../../notes/presentation/pages/notes_list_page.dart';

class MainNavigationPage extends StatelessWidget {
  const MainNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor:
        Theme.of(context).colorScheme.secondary,
        currentIndex: context.watch<NavigationCubit>().state,
        onTap: (value) {
          context.read<NavigationCubit>().setIndex(value);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            activeIcon: Icon(Icons.note_alt),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          if (state == 0) {
            return const NotesListPage();
          } else {
            return const ProfilePage();
          }
        },
      ),
    );
  }
}
