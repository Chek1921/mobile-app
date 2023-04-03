import 'dart:convert';

import 'package:mobileapp/models/news.dart';
import 'package:mobileapp/models/receipts.dart';
import 'package:mobileapp/models/reports.dart';
import 'package:mobileapp/services/status_code.dart';
import 'package:mobileapp/services/storage.dart';
import '../api/api_connect.dart';
import '../api/api_models.dart';

class HomeController {

  Future<UserStatusCode> loginUser(String username, String password) async {
    UserLogin userLogin = UserLogin(username: username, password: password);
    Map reply = await loginApi(userLogin);
    UserStatusCode statusCode = reply.values.first;
    if (statusCode.name == 200) {
      Token token = Token.fromJson(json.decode(reply.values.last));

      SecureStorage storage = SecureStorage();
      storage.addTokensToDb(token.token, token.refreshToken);
      storage.addUsernameToDb(username);
    }
    return statusCode;
  }

  
  Future<String> createReport(String title, String text) async {
    CreateReport report = CreateReport(title: title, text: text);
    String reply = await reportsCreateApi(report);
    return reply;
  }


  Future<List<News>> getNews() async{
    List<News> allNews = [];
    List<dynamic> result = await newsApi();
    result.forEach((element) {
      allNews.add(News(id: element['id'], title: element['title'], text: element['text'], timeCreate: element['time_create']));
    });
    return allNews;
  }

  Future<News> getNew(int page) async{
    dynamic result = await newApi(page);
    News news = News.fromJson(result);
    return news;
  }

  Future<Reports> getReport(int page) async{
    dynamic result = await reportApi(page);
    Reports report = Reports.fromJson(result);
    return report;
  }

  Future<List<Reports>> getReports() async{
    List<Reports> allReports = [];
    List<dynamic> result = await reportsListApi();
    result.forEach((element) {
      allReports.add(Reports.fromJson(element));
    });
    return allReports;
  }

  Future<List<Receipts>> getReceipts() async{
    List<Receipts> allReceipts = [];
    List<dynamic> result = await receiptsListApi();
    print(result);
    result.forEach((element) {
      allReceipts.add(Receipts.fromJson(element));
    });
    return allReceipts;
  }
}