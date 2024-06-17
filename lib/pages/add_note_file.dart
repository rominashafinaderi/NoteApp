import 'package:first/db/database.dart';
import 'package:first/models/note_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  String title = '';
  String description = '';
  String dateNote = '';
  String timeNote = '';

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
              margin: EdgeInsets.all(20),
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
                  SizedBox(
                    height: 30,
                  ),
                  itemBoxWithTitle(
                      title: 'توضیحات یادداشت',
                      onChanged: (value) {
                        setState(() {
                          description = value;
                        });
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Button(
                        title: 'تاریخ',
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2023, 6, 5),
                              maxTime: DateTime(2099, 6, 7), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              dateNote =
                                  '${date.year}/  ${date.month}/${date.day}';
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.fa);
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Button(
                          title: 'زمان',
                          onPressed: () {
                            DatePicker.showTimePicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              print('confirm $date');
                              setState(() {
                                timeNote = '${date.hour}:${date.minute}';
                              });
                            }, currentTime: DateTime.now());
                          })
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
                    print("Save button pressed");
                    try {
                      if (title.isNotEmpty &&
                          description.isNotEmpty &&
                          dateNote.isNotEmpty &&
                          timeNote.isNotEmpty) {
                        NoteModel note = NoteModel(
                            title: title,
                            description: description,
                            date: dateNote,
                            time: timeNote);
                        int result = await DbProvider.db.addNote(note);
                        if (result > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              ShowSnackBar(
                                  'یادداشت با موفقیت افزوده شد', Colors.green));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              ShowSnackBar('یادداشت افزوده نشد!!', Colors.orange));
                        }
                      }
                    } catch (e) {
                      print("Error: $e");

                      ScaffoldMessenger.of(context).showSnackBar(
                          ShowSnackBar('خطا در ذخیره یادداشت', Colors.red));
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
}

SnackBar ShowSnackBar(String text, Color color) {
  return SnackBar(
    content: Text(
      text,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
  );
}

Widget Button({required String title, required VoidCallback onPressed}) {
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

Widget itemBoxWithTitle(
    {required String title, required Function(String) onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Text(title),
      TextField(
        onChanged: onChanged,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    ],
  );
}
