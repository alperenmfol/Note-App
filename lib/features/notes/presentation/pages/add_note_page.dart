import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../cubit/note_cubit.dart';

class AddNotePage extends StatefulWidget {
  final String userId;
  final Note? note;

  const AddNotePage({super.key, this.note, required this.userId});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? "");
    contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async{
    final title = titleController.text.trim();
    final content = contentController.text.trim();
    if (title.isEmpty && content.isEmpty) return;

    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id ?? "",
      userId: widget.userId,
      // localden alınıyor
      title: title,
      content: content,
      isPinned: widget.note?.isPinned ?? false,
      isFavorite: widget.note?.isFavorite ?? false,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
    );

    if (widget.note == null) {
      await context.read<NoteCubit>().addNote(note);
    } else {
      await context.read<NoteCubit>().updateNote(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        await context.read<NoteCubit>().getAllNotes();

      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextField(
            controller: titleController,
            style: const TextStyle(fontSize: 24, fontFamily: "MontserratBold"),
            decoration: const InputDecoration(
              hintText: "Title",
              border: InputBorder.none,
            ),
            onTapOutside: (_) async => await saveNote(),
            onSubmitted: (_) async => await saveNote(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Divider(),
              Expanded(
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  style: const TextStyle(fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: "Notunuzu buraya yazın...",
                    border: InputBorder.none,
                  ),
                  onTapOutside: (_) async => await saveNote(),
                  onSubmitted: (_) async => await saveNote(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
