class Districts {
  int id;
  String district;

  Districts({required this.id, required this.district});

  factory Districts.fromJson(Map<String, dynamic> json) {
    return Districts(
        id: json['id'],
        district: json['district'],
    );
  }

  Map<String, dynamic> toDatabaseJson() =>{
    "value": id,
    "label": district,
    };
}