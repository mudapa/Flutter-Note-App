part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NotesLoading extends NoteState {}

class NotesLoaded extends NoteState {
  final List<Note> notes;

  const NotesLoaded({
    required this.notes,
  });

  @override
  List<Object?> get props => [notes];
}

class NoteOperationFailure extends NoteState {
  final String error;

  const NoteOperationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
