import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

// ОБНВОЛЯТЬ USERNAME в РЕГИСТРАЦИИ
void main() {
  var token;
  test('Login', () async {
    final url = Uri.parse('http://13.50.176.175:8000/token/');
    final data = {'username': 'admin', 'password': 'Qwe123123'};
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));

    token = jsonDecode(response.body)['access'];
    print(token);
    expect(response.statusCode, 200);
    expect(jsonDecode(response.body), isA<dynamic>());
  });

  test('GetNews', () async {
    final url = Uri.parse('http://13.50.176.175:8000/api/news');
    final response = await http.get(url);
    expect(response.statusCode, 200);
    expect(jsonDecode(response.body), isA<dynamic>());
  });

  test('GetReports', () async {
    final url = Uri.parse('http://13.50.176.175:8000/api/reports/');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    expect(response.statusCode, 200);
    expect(jsonDecode(response.body), isA<dynamic>());
  });

  test('CreateReport', () async{
  final url = Uri.parse('http://13.50.176.175:8000/api/reports/');
  final data = {'title': 'Новая жалоба', 'text': 'варпировсввыа ваы в пвы п выап ывапвыа', 'photo': null,};
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(data)
  );
  expect(response.statusCode, 400);
  expect(jsonDecode(response.body), isA<dynamic>());   
  });
}