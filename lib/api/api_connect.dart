import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobileapp/models/bills.dart';
import 'package:mobileapp/models/reports.dart';
import 'package:mobileapp/services/status_code.dart';
import 'package:mobileapp/services/storage.dart';
import 'api_models.dart';

const _base = "http://13.50.176.175:8000";
const _signInURL = "/token/";
const _refreshEndpoint = "/token/refresh/";
const _reportsEndpoint = "/api/reports/";
const _receiptsEndpoint = "/api/receipts/";
const _districtEndpoint = "/api/districts/";
const _billNameEndpoint = "/api/bill_names/";
const _registrationEndpoint = "/api/registration/";
const _billsEndpoint = "/api/bills/";
const _payEndpoint = "/api/pay/";
const _forgotEndpoint = "/api/forgot_password/";

const _refresh = _base + _refreshEndpoint;
const _login = _base + _signInURL;
const _reports = _base + _reportsEndpoint;
const _receipts = _base + _receiptsEndpoint;
const _district = _base + _districtEndpoint;
const _billName = _base + _billNameEndpoint;
const _registration = _base + _registrationEndpoint;
const _bills = _base + _billsEndpoint;
const _pay = _base + _payEndpoint;
const _forgot = _base + _forgotEndpoint;


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

Future<String> forgotApi(UserForgot userForgot) async {
  final http.Response response = await http.post(
    Uri.parse(_forgot),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userForgot.toDatabaseJson()),
  );
  Map<String, dynamic> result = json.decode(utf8.decode(response.bodyBytes));
  List<dynamic> reply = result['email'];
  String answer = reply[0];
  return answer;
}

Future<List<dynamic>> newsApi() async {
  var asd = await SecureStorage().getUsername();
  String url = 'http://13.50.176.175:8000/api/news';
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
  String url = 'http://13.50.176.175:8000/api/news/${page.toString()}/';
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

Future<String> billsCreateApi(CreateBill bill) async {
  var token = await SecureStorage().getToken();
  if (token != null) {
    token = 'Bearer ${token}';
  }
  http.Response response = await http.post(
    Uri.parse(_bills),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${token}',
    },
    body: jsonEncode(bill.toDatabaseJson())
  );
  if (response.statusCode == 401) {
    refreshToken();
    await Future.delayed(const Duration(seconds: 1));
    return billsCreateApi(bill);
  }
  return 'Все случилось';
}

Future<dynamic> reportApi(page) async {
  String url = '${_reports}${page.toString()}/';
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

Future<List<dynamic>> billNameApi() async {
  http.Response response = await http.get(
    Uri.parse(_billName),
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
  return 'asd';
}