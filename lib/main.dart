import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'bloc/note_bloc.dart';
import 'models/note.dart';
import 'pages/note_page.dart';
import 'utils/hive_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              NoteBloc(notesBox: Hive.box<Note>('notesBox'))..add(LoadNotes()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Note',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const NotePage(),
      ),
    );
  }
}
