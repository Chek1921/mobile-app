import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/models/news.dart';
import 'package:mobileapp/models/reports.dart';
import 'package:mobileapp/services/status_code.dart';
import '../services/storage.dart';
import 'api_models.dart';

final _base = "http://192.168.10.117:8000";
final _signInURL = "/token/";
final _refreshEndpoint = "/token/refresh/";
final _signUpEndpoint = "/api/register/";
final _reportsEndpoint = "/api/reports/";
final _receiptsEndpoint = "/api/receipts/";

final _refresh = _base + _refreshEndpoint;
final _login = _base + _signInURL;
final _reports = _base + _reportsEndpoint;
final _receipts = _base + _receiptsEndpoint;

Future<void> refreshToken() async{
  var token = await SecureStorage().getRefreshToken();
  if (token != null) {
    token = token;
  }
  Map<String, String> refreshTokenMap = {'refresh':'${token}'};
  http.Response response = await http.post(
    Uri.parse(_refresh),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(refreshTokenMap),
  );
  SecureStorage storage = SecureStorage();
  if (response.statusCode == 200) {
    Token token = Token.fromJson(json.decode(response.body));
    storage.addTokensToDb(token.token, token.refreshToken);
  } else {
    throw Exception(json.decode(response.body));
  }
}

Future<Map> loginApi(UserLogin userLogin) async {
  final http.Response response = await http.post(
    Uri.parse(_login),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  UserStatusCode statusCode = UserStatusCode.fromName(response.statusCode);
  Map<String, dynamic> reply = {'status': statusCode, 'resonse_body': response.body};
  return reply;
}

Future<List<dynamic>> newsApi() async {
  var asd = await SecureStorage().getUsername();
  String url = 'http://192.168.10.117:8000/api/news';
  if (asd != null) {
    url = url + '?username=' + asd;
  }
  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
  return result;
}

Future<dynamic> newApi(page) async {
  String url = 'http://192.168.10.117:8000/api/news/${page.toString()}/';
  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  var result = json.decode(utf8.decode(response.bodyBytes));
  return result;
}

Future<List<dynamic>> reportsListApi() async {
  var token = await SecureStorage().getToken();
  if (token != null) {
    token = 'Bearer ${token}';
  }
  http.Response response = await http.get(
    Uri.parse(_reports),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${token}',
    },
  );
  if (response.statusCode == 401) {
    refreshToken();
    await Future.delayed(const Duration(seconds: 1));
    return reportsListApi();
  }
  List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
  return result;
}

Future<String> reportsCreateApi(CreateReport report) async {
  var token = await SecureStorage().getToken();
  if (token != null) {
    token = 'Bearer ${token}';
  }
  http.Response response = await http.post(
    Uri.parse(_reports),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${token}',
    },
    body: jsonEncode(report.toDatabaseJson())
  );
  if (response.statusCode == 401) {
    refreshToken();
    await Future.delayed(const Duration(seconds: 1));
    return reportsCreateApi(report);
  }
  return 'Все случилось';
}

Future<dynamic> reportApi(page) async {
  String url = 'http://192.168.10.117:8000/api/reports/${page.toString()}/';
  var token = await SecureStorage().getToken();
  if (token != null) {
    token = 'Bearer ${token}';
  }
  http.Response response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${token}',
    },
  );
  if (response.statusCode == 401) {
    refreshToken();
    await Future.delayed(const Duration(seconds: 1));
    return reportApi(page);
  }
  var result = json.decode(utf8.decode(response.bodyBytes));
  return result;
}

Future<List<dynamic>> receiptsListApi() async {
  var token = await SecureStorage().getToken();
  if (token != null) {
    token = 'Bearer ${token}';
  }
  http.Response response = await http.get(
    Uri.parse(_receipts),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${token}',
    },
  );
  if (response.statusCode == 401) {
    refreshToken();
    await Future.delayed(const Duration(seconds: 1));
    return receiptsListApi();
  }
  List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
  return result;
}

