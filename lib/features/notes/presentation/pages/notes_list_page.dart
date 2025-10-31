import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/presentation/cubit/note_cubit.dart';
import '../widgets/note_card.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({super.key});

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  bool isGrid = false;
  bool isSearching = false;
  String searchQuery = '';
  String filter = "All";

  final List<String> filters = ["All", "Pinned", "Favorites"];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteCubit, NoteState>(
      listener: (context, state) {
        if (state is NoteError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is NoteUpdated) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Not güncellendi")));
        } else if (state is NoteDeleted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Not silindi")));
        }
      },
      builder: (context, state) {
        if (state is NoteLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is NoteLoaded) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title:
                  isSearching
                      ? TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Search notes...",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) async {
                      await context.read<NoteCubit>().searchNotes(value);
                    },
                  )
                      : const Text(
                        "NoteIt",
                        style: TextStyle(
                          fontFamily: "MontserratBold",
                          fontSize: 28,
                        ),
                      ),
              actions: [
                IconButton(
                  icon: Icon(isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      isSearching = !isSearching;
                      searchQuery = '';
                    });
                    context.read<NoteCubit>().searchNotes('');
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.pushNamed("add-note-page");
              },
              child: const Icon(Icons.add),
            ),
            body: Column(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      DropdownButton<String>(
                        value: filter,
                        items:
                            filters
                                .map(
                                  (f) => DropdownMenuItem(
                                    value: f,
                                    child: Text(f),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() => filter = value!);
                          context.read<NoteCubit>().filterNotes(filter);
                        },
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
                        onPressed: () {
                          setState(() => isGrid = !isGrid);
                        },
                      ),

                      SizedBox(width: 16),
                    ],
                  ),
                ),
                Expanded(
                  child:
                      state.notes.isEmpty
                          ? const Center(child: Text("Henüz not bulunmuyor"))
                          : isGrid
                          ? buildGridView(state.notes)
                          : buildListView(state.notes),
                ),
              ],
            ),
          );
        } else if (state is NoteError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title:
                isSearching
                    ? TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: "Search notes...",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() => searchQuery = value);
                      },
                    )
                    : const Text(
                      "NoteIt",
                      style: TextStyle(
                        fontFamily: "MontserratBold",
                        fontSize: 28,
                      ),
                    ),
            actions: [
              IconButton(
                icon: Icon(isSearching ? Icons.close : Icons.search),
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                    searchQuery = '';
                  });
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.pushNamed("add-note-page");
            },
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: filter,
                      items:
                          filters
                              .map(
                                (f) =>
                                    DropdownMenuItem(value: f, child: Text(f)),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() => filter = value!);
                      },
                    ),
                    IconButton(
                      icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
                      onPressed: () {
                        setState(() => isGrid = !isGrid);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: const Center(child: Text("Henüz not bulunmuyor")),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildListView(List<Note> notes) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder:
          (context, index) => NoteCard(note: notes[index], isListView: true),
    );
  }

  Widget buildGridView(List<Note> notes) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2,
      ),
      itemBuilder:
          (context, index) => NoteCard(note: notes[index], isListView: false),
    );
  }
}
