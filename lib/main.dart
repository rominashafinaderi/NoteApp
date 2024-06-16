import 'package:first/db/database.dart';
import 'package:first/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbProvider = DbProvider.db;
  String path = join(await getDatabasesPath(), 'note.db');
  await deleteDatabase(path);

  // Initialize the database and test the table
  await dbProvider.database;
  await dbProvider.testTable();

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

