class BillNames {
  int id;
  String name;

  BillNames({required this.id, required this.name});

  factory BillNames.fromJson(Map<String, dynamic> json) {
    return BillNames(
        id: json['id'],
        name: json['name'],
    );
  }

  Map<String, dynamic> toDatabaseJson() =>{
    "value": id,
    "label": name,
    };
}