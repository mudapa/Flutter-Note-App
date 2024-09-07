import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _notesBox = Hive.box<Note>('notesBox');

  void _createOrUpdateNote([Note? note]) {
    String title = _titleController.text;
    String content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty) {
      if (note != null) {
        note.title = title;
        note.content = content;
        note.save();
      } else {
        final newNote = Note(
          title: title,
          content: content,
        );
        _notesBox.add(newNote);
      }

      _clearTextFields();
      setState(() {});
    }
  }

  void _clearTextFields() {
    _titleController.clear();
    _contentController.clear();
  }

  void _deleteNote(Note note) {
    note.delete();
    setState(() {});
  }

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
                _createOrUpdateNote(note);
                Navigator.pop(context);
              },
              child: Text(note == null ? 'Create' : 'Update'),
            ),
            TextButton(
              onPressed: () {
                _clearTextFields();
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
    _notesBox.close();
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
      body: ValueListenableBuilder(
        valueListenable: _notesBox.listenable(),
        builder: (context, Box<Note> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('No notes found.'),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Note note = box.getAt(index)!;

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
                        _deleteNote(note);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
