class NoteModel {
  int? id;
  String? title;
  String? description;
  String? date;
  String? time;

  NoteModel(
      {this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.time});
}
