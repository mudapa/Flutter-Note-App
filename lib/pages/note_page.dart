import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/note_bloc.dart';
import '../models/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _showNoteDialog([Note? note]) {
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(note == null ? 'Create a new note' : 'Edit a note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (note != null) {
                  context.read<NoteBloc>().add(UpdateNote(
                        note: note,
                        title: _titleController.text,
                        content: _contentController.text,
                      ));
                  _titleController.clear();
                  _contentController.clear();
                  setState(() {});
                } else {
                  context.read<NoteBloc>().add(AddNote(
                        title: _titleController.text,
                        content: _contentController.text,
                      ));
                  _titleController.clear();
                  _contentController.clear();
                }
                Navigator.pop(context);
              },
              child: Text(note == null ? 'Create' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                _titleController.clear();
                _contentController.clear();
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showNoteDialog();
            },
          )
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NoteOperationFailure) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is NotesLoaded) {
            if (state.notes.isEmpty) {
              return const Center(child: Text('No notes found.'));
            }
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showNoteDialog(note);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<NoteBloc>().add(DeleteNote(note));
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
