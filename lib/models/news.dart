class News {
  int id;
  String title;
  String text;
  String timeCreate;
  News({required this.id, required this.title, required this.text, required this.timeCreate});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        id: json['id'],
        title: json['title'],
        text: json['text'],
        timeCreate: json['time_create']);
  }
}