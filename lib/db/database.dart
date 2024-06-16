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
      print('Database and tbl_note table created');
    });
  }

  Future<void> testTable() async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='tbl_note'");
    if (res.isNotEmpty) {
      print('Table tbl_note exists');
    } else {
      print('Table tbl_note does not exist');
    }
  }

  Future<int> addNote(NoteModel note) async {
    final db = await database;
    int result = await db.rawInsert(
        'INSERT INTO tbl_note (title, description, dateNote, timeNote) VALUES (?, ?, ?, ?)',
        [note.title, note.description, note.date, note.time]);
    return result;
  }

  Future<List<NoteModel>> getNotesList() async {
    final db = await database;
    var response = await db.rawQuery('select * from tbl_note');
    List<NoteModel> noteList = [];
    response.forEach((element) {
      Map map = element;
      int id = map['id'];
      String title = map['title'];
      String description = map['description'];
      String dateNote = map['dateNote'];
      String timeNote = map['timeNote'];
      noteList.add(NoteModel(
          id: id,
          title: title,
          description: description,
          date: dateNote,
          time: timeNote));
    });
    return noteList;
  }

  Future<int> deleteNote(int noteId) async {
    final db = await database;
    return await db.delete('tbl_note', where: 'id = ?', whereArgs: [noteId]);
  }
}
