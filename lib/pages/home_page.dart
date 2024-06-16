import 'package:first/db/database.dart';
import 'package:first/models/note_models.dart';
import 'package:first/pages/add_note_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<NoteModel>> noteLists;

  @override
  void initState() {
    super.initState();
    noteLists = DbProvider.db.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          'لیست یادداشت',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.green,
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddNoteScreen()))
              .then((value) {
            setState(() {
              noteLists = DbProvider.db.getNotesList();
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: double.infinity - 60,
        child: FutureBuilder<List<NoteModel>>(
          future: noteLists,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text('هیچ یادداشتی وجود ندارد'),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 144,
                    margin: EdgeInsets.all(16),
                    child: Card(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${snapshot.data![index].title}:عنوان',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  textAlign: TextAlign.end,
                                  '${snapshot.data![index].date}:تاریخ ایجاد',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black)),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              int? id = snapshot.data![index].id;
                              if (id != null) {
                                int res = await DbProvider.db.deleteNote(id);
                                if (res > 0) {
                                  setState(() {
                                    noteLists = DbProvider.db.getNotesList();
                                  });
                                } else {
                                  SnackBar errorSnackBar = SnackBar(
                                    content: Text(
                                      'خطا در حذف یادداشت',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.red,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(errorSnackBar);
                                }
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('خطا در خواندن داده‌ها'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
