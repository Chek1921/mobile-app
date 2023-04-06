import 'dart:io';

class Bills {
  int id;
  String name;
  double lastCount;
  double currentCount;
  String address;
  double rate;
  double cost;
  String timePay;

  Bills({required this.id, required this.rate, required this.name, required this.lastCount, required this.currentCount, required this.address, required this.cost, required this.timePay});

  factory Bills.fromJson(Map<String, dynamic> json) {
    return Bills(
        id: json['id'],
        name: json['name'],
        lastCount: json['last_count'],
        currentCount: json['current_count'],
        address: json['address'],
        rate: json['rate'],
        cost: json['cost'],
        timePay: json['time_pay'],
    );
  }
}

class CreateBill {
  int name;
  double currentCount;
  CreateBill({required this.name, required this.currentCount});

  Map<String, dynamic> toDatabaseJson() =>{
    "name": name,
    "current_count": currentCount,
    };
}