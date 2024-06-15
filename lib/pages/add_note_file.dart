import 'package:first/db/database.dart';
import 'package:first/models/note_models.dart';
import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  String title = '';
  String description = '';
  String date = '';
  String time = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          'افزودن یادداشت',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity - 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  itemBoxWithTitle(
                      title: 'عنوان یادداشت',
                      onChanged: (value) {
                        setState(() {
                          title = value;
                        });
                      }),
                  itemBoxWithTitle(
                      title: 'توضیحات یادداشت',
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button(title: 'تاریخ', onPressed: () {}),
                      SizedBox(
                        width: 20,
                      ),
                      Button(title: 'زمان', onPressed: () {})
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.all(16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    NoteModel note = NoteModel(
                        title: title,
                        description: description,
                        date: date,
                        time: time);
                    int result = await DbProvider.db.addNote(note);
                    if (result > 0) {
                      print("erorrr");
                      SnackBar snackBar = SnackBar(
                        content: Text(
                          'یادداشت با موفقیت افزوده شد',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      SnackBar snackBar2 = SnackBar(
                        content: Text(
                          'یادداشت افزوده نشد!!',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                    }
                  },
                  child: Text(
                    'ذخیره یادداشت',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(100, 40),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget itemBoxWithTitle(
      {required String title, required ValueChanged<String>? onChanged}) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(fontSize: 14, color: Colors.black),
            )),
        Container(
          margin: EdgeInsets.all(20),
          child: TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget Button({required VoidCallback? onPressed, required String title}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        fixedSize: Size(100, 40),
      ),
    );
  }
}
