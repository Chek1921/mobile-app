class Reports {
  int id;
  String title;
  String text;
  String timeCreate;
  String aTitle;
  String aText;
  int vision;
  String photo;
  Reports({required this.id, required this.vision, required this.title, required this.text, required this.timeCreate, required this.aTitle, required this.aText, required this.photo});
  
  factory Reports.fromJson(Map<String, dynamic> json) {
    if (json['a_title'] == '') {
      json['a_title'] = 'Ответа еще нет';
    }
    return Reports(
        id: json['id'],
        vision: int.parse(json['vision']),
        title: json['title'],
        text: json['text'],
        aTitle: json['a_title'],
        aText: json['a_text'],
        photo: json['photo'],
        timeCreate: json['time_create']);
  }
}

class CreateReport {
  String title;
  String text;
  dynamic photo;
  CreateReport({required this.title, required this.text, required this.photo});

  Map<String, dynamic> toDatabaseJson() =>{
    "title": title,
    "text": text,
    "photo": photo,
    };
}