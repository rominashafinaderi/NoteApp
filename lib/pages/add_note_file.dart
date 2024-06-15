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
                      } else {
                        SnackBar snackBar3 = SnackBar(
                          content: Text(
                            'لطفا تمامی فیلدها را پر کنید',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.orange,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar3);
                      }
                    } catch (e) {
                      print("Error: $e");
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
