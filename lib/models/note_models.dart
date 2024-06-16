class NoteModel {
  int? id;
  String title;
  String description;
  String date;
  String time;

  NoteModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
  });

  factory NoteModel.fromMap(Map<String, dynamic> json) => NoteModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    date: json["dateNote"],
    time: json["timeNote"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "description": description,
    "dateNote": date,
    "timeNote": time,
  };
}
