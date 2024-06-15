import 'package:first/models/note_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String path = join(await getDatabasesPath(), 'note.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      var query = 'CREATE TABLE tbl_note(id INTEGER PRIMARY KEY AUTOINCREMENT,'
          'title VARCHAR(100), description TEXT, dateNote TEXT, timeNote TEXT)';
      await db.execute(query);
    });
  }

  Future<int> addNote(NoteModel note) async {
    final db = await database;
    int result = await db.rawInsert(
        'INSERT INTO tbl_note (title, description, dateNote, timeNote) VALUES (?, ?, ?, ?)',
        [note.title, note.description, note.date, note.time]);
    return result;
  }
}