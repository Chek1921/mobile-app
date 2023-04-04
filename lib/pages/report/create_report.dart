import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/services/storage.dart';

class CreateReport extends StatefulWidget {
  final HomeController _homeController = HomeController();
  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textController = TextEditingController();
  
  final SecureStorage storage = SecureStorage();
  String buttonText = '';
  String? _username = '';

  Future<String?> getUsername() async {
    _username = await storage.getUsername();
    return _username;
  }

  void usernameUpdate() {
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
  void initState() {
    super.initState();
    usernameUpdate();
  }
  String IZI = '';

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
      body: SingleChildScrollView(
        child: Container(
          
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.yellow[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Text('Создать жалобу', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(top: 20),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Назвазание жалобы',
                      hintText: 'Сломался счетчик'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0
                    ),
                child: TextFormField(
                  controller: textController,
                  minLines: 5,
                  maxLines: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Жалоба',
                      hintText: 'Содержание'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(IZI, style: TextStyle(color: Colors.red),),
              ),
              Container(
                height: 50,
                width: 250,
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                      String title = titleController.text;
                      String text = textController.text;
                      if (text != '' && title != '') {
                        String reply = await widget._homeController.createReport(title, text);
                        setState(() {
                          IZI = reply;
                        });
                      } else {
                        setState(() {
                          IZI = 'ВЫ НЕ УКАЗАЛИ ЗНАЧЕНИЯ';
                        });
                      }
                      
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ReportsPage()));
                  },
                  child: Text(
                    'Отправить',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
