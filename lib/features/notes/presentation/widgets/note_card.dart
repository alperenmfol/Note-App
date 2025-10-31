import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';
import 'package:note_app/features/notes/presentation/cubit/note_cubit.dart';

class NoteCard extends StatelessWidget {
  final bool isListView;
  final Note note;

  const NoteCard({super.key, required this.note, required this.isListView});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 1,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
              onPressed: (_) async {
                final updated = note.copyWith(
                  isPinned: !note.isPinned,
                  updatedAt: DateTime.now(),
                );
                await context.read<NoteCubit>().updateNote(updated);
              },
              backgroundColor: Colors.amber,
              foregroundColor: Colors.white,
              icon: note.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
            ),
            SlidableAction(
              onPressed: (_) async {
                final updated = note.copyWith(
                  isFavorite: !note.isFavorite,
                  updatedAt: DateTime.now(),
                );
                await context.read<NoteCubit>().updateNote(updated);
              },
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              icon: note.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            SlidableAction(
              borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
              onPressed: (_) {
                _confirmDelete(context);
              },
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    (note.title ?? "").isEmpty ? "(Başlıksız)" : note.title!,
                    style: TextStyle(fontFamily: "MontserratSemiBold"),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (note.isFavorite)
                      const Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                    if (note.isPinned) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.push_pin, color: Colors.amber, size: 18),
                    ],
                  ],
                ),
              ],
            ),
            subtitle: Text(
              (note.content ?? "").isEmpty ? "(Boş not)" : note.content!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              context.pushNamed("add-note-page", extra: {"note": note});
            },
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Notu sil"),
            content: const Text("Bu notu silmek istediğinizden emin misiniz?"),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: Text("İptal", style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
              ),
              ElevatedButton(
                onPressed: () async {
                  context.pop();
                  await context.read<NoteCubit>().deleteNote(note.id);

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Sil"),
              ),
            ],
          ),
    );
  }
}
