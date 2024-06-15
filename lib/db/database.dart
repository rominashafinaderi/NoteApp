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
    print("Initializing database...");
    String path = join(await getDatabasesPath(), 'note.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      print("Creating table...");
      var query = 'create table tbl_note(id Integer PRIMARY KEY AUTOINCREMENT,'
          'title varchar(100),description Text,dateNote Text ,timeNote Text )';
      await db.execute(query);
    });
  }

  Future<int> addNote(NoteModel note) async {
    final db = await database;
    int result = await db.rawInsert(
        'insert into tbl_note(title,description,dateNote,timeNote) values(?,?,?,?)',
        [note.title, note.description, note.date, note.time]);
    return result;
  }
}