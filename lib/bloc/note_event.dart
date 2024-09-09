part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final String title;
  final String content;

  const AddNote({required this.title, required this.content});

  @override
  List<Object?> get props => [title, content];
}

class UpdateNote extends NoteEvent {
  final Note note;
  final String title;
  final String content;

  const UpdateNote({
    required this.note,
    required this.title,
    required this.content,
  });

  @override
  List<Object?> get props => [
        note,
        title,
        content,
      ];
}

class DeleteNote extends NoteEvent {
  final Note note;

  const DeleteNote(this.note);

  @override
  List<Object?> get props => [note];
}
