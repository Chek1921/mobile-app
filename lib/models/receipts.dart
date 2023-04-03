class Receipts {
  int id;
  String address;
  String district;
  String name;
  String rateName;
  double rateCost;
  double currentCount;
  double cost;
  String timeCreate;

  Receipts({required this.id, required this.address, required this.district, required this.name, required this.rateName, required this.rateCost, required this.currentCount, required this.cost, required this.timeCreate});

  factory Receipts.fromJson(Map<String, dynamic> json) {
    return Receipts(
        id: json['id'],
        address: json['address'],
        district: json['district'],
        name: json['name'],
        rateName: json['rate_name'],
        rateCost: json['rate_cost'],
        currentCount: json['current_count'],
        cost: json['cost'],
        timeCreate: json['time_create'],
    );
  }
}