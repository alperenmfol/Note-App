import 'package:hive/hive.dart';
import 'package:note_app/features/notes/domain/entities/note.dart';

class NoteLocalDataSource {
  static const String _boxName = "notesBox";

  Future<Box<Note>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Note>(_boxName);
    }
    return Hive.box<Note>(_boxName);
  }

  // Tüm notları ekleme
  Future<void> cacheNotes(List<Note> notes) async {
    final box = await _openBox();

    await box.clear();

    for (final note in notes) {
      await box.put(note.id, note);
    }
  }

  //Not ekleme
  Future<void> addNote(Note note) async {
    final box = await _openBox();
    await box.put(note.id, note);
  }

  //Tüm notları getir
  Future<List<Note>> getAllNotes() async {
    final box = await _openBox();
    return box.values.toList();
  }

  //Not güncelle
  Future<void> updateNote(Note note) async {
    final box = await _openBox();
    if (box.containsKey(note.id)) {
      await box.put(note.id, note);
    } else {
      throw Exception("Not bulunamadı: ${note.id}");
    }
  }

  //Not sil
  Future<void> deleteNote(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  //Tüm notları temizle
  Future<void> clearNotes() async {
    final box = await _openBox();
    await box.clear();
  }

  Future<bool> hasNote(String id) async {
    final box = await _openBox();
    return box.containsKey(id);
  }
}
