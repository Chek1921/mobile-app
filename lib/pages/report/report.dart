import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/models/news.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/services/storage.dart';

class ReportPage extends StatefulWidget {
  int page;
  ReportPage({required this.page});

  final HomeController _homeController = HomeController();
  @override
  _ReportPageState createState() => _ReportPageState(page: page);
}

class _ReportPageState extends State<ReportPage> {
  int page;
  _ReportPageState({required this.page});

  dynamic _listItem;

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    widget._homeController.getReport(page).then((listItem) {
      setState(() {
        _listItem = listItem;
      });
    });
  }

  final SecureStorage storage = SecureStorage();
  String buttonText = '';
  String? _username = '';

  Future<String?> getUsername() async {
    _username = await storage.getUsername();
    return _username;
  }

  void UsernameUpdate() {
    getUsername().then((String? username) {
      setState(() {
        if (username == null) {
          buttonText = 'Вход';
        }
        else {
          _username = username.toString();
          buttonText = '(${_username})Выход';
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text('ЖКХ услуги'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                if (buttonText == '(${_username})Выход') {
                  storage.deleteData();
                  setState(() {
                    buttonText = 'Вход';
                  });
                }
                else {
                  Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Login()));
                }
              },
              child: Text(buttonText))
        ],
      ),
      drawer: Drawer(
        child: MainDrawer(),
      ),
      body: SingleChildScrollView (
        child: Column(
          children: [
            Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.yellow[300],
            child: Column(
              children: [
                Text(_listItem.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                Text(_listItem.text, textAlign: TextAlign.left,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                  '${_listItem.timeCreate.split('-')[2].split('T')[0]}.${_listItem.timeCreate.split('-')[1]}.${_listItem.timeCreate.split('-')[0]}г.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.right,
                    ),
                ),
              ],
              ),
            ),
            Container(
            width: 10000,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.cyan[100],
            child: Column(
              children: [
                Text(_listItem.aTitle, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                Text(_listItem.aText, textAlign: TextAlign.left,),
              ],
              ),
            )
          ],)
        )
    );
  }
}
