import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 1)
class Note {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? content;
  @HiveField(4)
  final bool isPinned;
  @HiveField(5)
  final bool isFavorite;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime updatedAt;

  Note({
    required this.id,
    this.title,
    this.content,
    this.isPinned = false,
    this.isFavorite = false,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  Note copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    bool? isPinned,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
