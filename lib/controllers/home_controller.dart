import 'dart:convert';
import 'dart:io';
import 'package:mobileapp/api/api_connect.dart';
import 'package:mobileapp/api/api_models.dart';
import 'package:mobileapp/models/bill_names.dart';
import 'package:mobileapp/models/bills.dart';
import 'package:mobileapp/models/districts.dart';
import 'package:mobileapp/models/news.dart';
import 'package:mobileapp/models/receipts.dart';
import 'package:mobileapp/models/reports.dart';
import 'package:mobileapp/services/status_code.dart';
import 'package:mobileapp/services/storage.dart';

class HomeController {

  Future<UserLoginStatusCode> loginUser(String username, String password) async {
    UserLogin userLogin = UserLogin(username: username, password: password);
    Map reply = await loginApi(userLogin);
    UserLoginStatusCode statusCode = reply.values.first;
    if (statusCode.name == 200) {
      Token token = Token.fromJson(json.decode(reply.values.last));

      SecureStorage storage = SecureStorage();
      storage.addTokensToDb(token.token, token.refreshToken);
      storage.addUsernameToDb(username);
    }
    return statusCode;
  }

  Future<String> registerUser(String username, String email, String password1, String password2, String address, int districtId) async {
    UserRegistration userRegistration = UserRegistration(username: username, email: email, password1: password1, password2: password2, address: address, districtId: districtId);
    dynamic result = await registrationApi(userRegistration);
    String reply = '';
    if (result[0] == 'YES') {
      loginUser(username, password1);
    }
    result.forEach((element){
      reply = reply+'${element}\n';
    });
    return reply;
  }

  Future<String> forgotUser(String email) async {
    UserForgot userForgot = UserForgot(email: email);
    String result = await forgotApi(userForgot);
    return result;
  }

  Future<List<News>> getNews() async{
    List<News> allNews = [];
    List<dynamic> result = await newsApi();
    result.forEach((element) {
      allNews.add(News.fromJson(element));
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

  Future<String> createReport(String title, String text, File? file) async {
    dynamic reply = '';
    if (file != null) {
      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      CreateReport report = CreateReport(title: title, text: text, photo: base64Image);
      String reply = await reportsCreateApi(report);
    }
    else {
      CreateReport report = CreateReport(title: title, text: text, photo: file);
      String reply = await reportsCreateApi(report);
    }
    return reply;
  }

  Future<List<Receipts>> getReceipts() async{
    List<Receipts> allReceipts = [];
    List<dynamic> result = await receiptsListApi();
    result.forEach((element) {
      allReceipts.add(Receipts.fromJson(element));
    });
    return allReceipts;
  }

  Future<Receipts> getReceipt(int page) async{
    dynamic result = await receiptApi(page);
    Receipts receipt = Receipts.fromJson(result);
    return receipt;
  }

  Future<List<Districts>> getDistricts() async{
    List<Districts> allDistricts = [];
    dynamic result = await districtApi();
    result.forEach((element) {
      allDistricts.add(Districts.fromJson(element));
    });
    return allDistricts;
  }

  Future<List<BillNames>> getBillName() async{
    List<BillNames> allBillnames = [];
    dynamic result = await billNameApi();
    result.forEach((element) {
      allBillnames.add(BillNames.fromJson(element));
    });
    return allBillnames;
  }

  Future<List<Bills>> getBills() async{
    List<Bills> allBills = [];
    List<dynamic> result = await billsListApi();
    result.forEach((element) {
      allBills.add(Bills.fromJson(element));
    });
    return allBills;
  }

  Future<String> createBill(int id, double count) async {
    CreateBill bill = CreateBill(name: id, currentCount: count);
    String reply = await billsCreateApi(bill);
    return reply;
  }

  Future<String> makePayment(id) async {
    String result = await paymentApi(id);
    return 'asd';
  }
}

