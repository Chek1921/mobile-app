import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/models/reports.dart';
import 'package:mobileapp/services/status_code.dart';
import 'package:mobileapp/services/storage.dart';
import 'api_models.dart';

final _base = "http://192.168.10.117:8000";
final _signInURL = "/token/";
final _refreshEndpoint = "/token/refresh/";
final _signUpEndpoint = "/api/register/";
final _reportsEndpoint = "/api/reports/";
final _receiptsEndpoint = "/api/receipts/";
final _districtEndpoint = "/api/districts/";
final _registrationEndpoint = "/api/registration/";
final _billsEndpoint = "/api/bills/";
final _payEndpoint = "/api/pay/";

final _refresh = _base + _refreshEndpoint;
final _login = _base + _signInURL;
final _reports = _base + _reportsEndpoint;
final _receipts = _base + _receiptsEndpoint;
final _district = _base + _districtEndpoint;
final _registration = _base + _registrationEndpoint;
final _bills = _base + _billsEndpoint;
final _pay = _base + _payEndpoint;


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
  UserLoginStatusCode statusCode = UserLoginStatusCode.fromName(response.statusCode);
  Map<String, dynamic> reply = {'status': statusCode, 'resonse_body': response.body};
  return reply;
}

Future<List> registrationApi(UserRegistration userRegistration) async {
  final http.Response response = await http.post(
    Uri.parse(_registration),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userRegistration.toDatabaseJson()),
  );
  List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
  return result;
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

Future<dynamic> receiptApi(page) async {
  String url = _receipts+'${page.toString()}/';
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

Future<List<dynamic>> districtApi() async {
  http.Response response = await http.get(
    Uri.parse(_district),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
  return result;

}

Future<List<dynamic>> billsListApi() async {
  var token = await SecureStorage().getToken();
  if (token != null) {
    token = 'Bearer ${token}';
  }
  http.Response response = await http.get(
    Uri.parse(_bills),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${token}',
    },
  );
  if (response.statusCode == 401) {
    refreshToken();
    await Future.delayed(const Duration(seconds: 1));
    return billsListApi();
  }
  List<dynamic> result = json.decode(utf8.decode(response.bodyBytes));
  print(result);
  return result;
}

Future<String> paymentApi(id) async {
  var token = await SecureStorage().getToken();
  if (token != null) {
    token = 'Bearer ${token}';
  }
  http.Response response = await http.post(
    Uri.parse(_pay),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${token}',
    },
    body: jsonEncode({'id': id})
  );
  print(response.body);
  return 'asd';
}