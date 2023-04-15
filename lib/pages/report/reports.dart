import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/models/reports.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/pages/report/report.dart';
import 'package:mobileapp/services/storage.dart';

class ReportsPage extends StatefulWidget {
  final HomeController _homeController = HomeController();
  @override
  _ReportsPageState createState() => _ReportsPageState();

  
}

class _ReportsPageState extends State<ReportsPage> {
  List<Reports> _listReports = [];

  List<dynamic> colorList = [Colors.yellow[300], Colors.cyan[100]];

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    widget._homeController.getReports().then((listReports) {
      setState(() {
        _listReports = listReports;
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
      body: ListView.builder(
        itemCount: _listReports.length,
        itemBuilder: (context, index) {
          final itemReports = _listReports[_listReports.length-index-1];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: colorList[itemReports.vision-1],
            child: Column(
              children: [
                Text(itemReports.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                Text(itemReports.text, overflow: TextOverflow.ellipsis, maxLines: 2, textAlign: TextAlign.left,),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: OutlinedButton(
                  onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportPage(page: itemReports.id)))
                    },
                  child: Text('Подробнее', style: TextStyle(color: Colors.black),),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                  '${itemReports.timeCreate.split('-')[2].split('T')[0]}.${itemReports.timeCreate.split('-')[1]}.${itemReports.timeCreate.split('-')[0]}г.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.right,
                    ),
                ),
              ],
              ),
          );
        },
      ),
    );
  }
}
