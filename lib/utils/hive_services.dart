import 'package:hive_flutter/hive_flutter.dart';

import '../models/note.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();
    if (Hive.isBoxOpen('notesBox')) {
      await Hive.box('notesBox').close();
    }
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>('notesBox');
  }
}
