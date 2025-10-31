part of 'note_cubit.dart';


@immutable
abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  const NoteLoaded(this.notes);

  @override
  List<Object?> get props => [notes];
}

class NoteError extends NoteState {
  final String message;
  const NoteError(this.message);

  @override
  List<Object?> get props => [message];
}

class NoteUpdated extends NoteState {
  final Note note;
  const NoteUpdated(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteDeleted extends NoteState {
  final String noteId;
  const NoteDeleted(this.noteId);

  @override
  List<Object?> get props => [noteId];
}
