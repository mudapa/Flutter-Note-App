import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

import '../models/note.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final Box<Note> notesBox;

  NoteBloc({required this.notesBox}) : super(NotesLoading()) {
    on<LoadNotes>((event, emit) async {
      final notes = notesBox.values.toList();
      emit(NotesLoaded(notes: notes));
    });

    on<AddNote>((event, emit) async {
      final newNote = Note(
        title: event.title,
        content: event.content,
      );
      await notesBox.add(newNote);
      emit(NotesLoaded(notes: notesBox.values.toList()));
    });

    on<UpdateNote>((event, emit) async {
      event.note.title = event.title;
      event.note.content = event.content;
      await event.note.save();
      emit(NotesLoaded(notes: notesBox.values.toList()));
    });

    on<DeleteNote>((event, emit) async {
      await event.note.delete();
      emit(NotesLoaded(notes: notesBox.values.toList()));
    });
  }
}
