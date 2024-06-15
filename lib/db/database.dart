import 'package:first/models/note_models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbProvider {
  DbProvider._();

  static final DbProvider db = DbProvider._();
  static late Database _database;

  Future<Database> get database async {
    _database = await initDb();
    return _database;
  }

  initDb() async {
    return await openDatabase(join(await getDatabasesPath(), 'note.db'),
        onCreate: (db, version) async {
      var query = 'create table tbl_note(id Integer PRIMARY KEY AUTOINCREAMENT,'
          'title varchar(100),description Text,dateNote Text ,timeNote Text )';
      db.execute(query);
    }, version: 1);
  }

  addNote(NoteModel note) async {
    final db = await database;
    int result =  await db.rawInsert(
        'insert into tbl_note(title,description,dateNote,timeNote)values(?,?,?,?)',
        [note.title, note.description, note.date, note.time]);
    return result;
  }
}
