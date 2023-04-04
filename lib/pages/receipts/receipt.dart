import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/services/storage.dart';

class ReceiptPage extends StatefulWidget {
  int page;
  ReceiptPage({required this.page});

  final HomeController _homeController = HomeController();
  @override
  _ReceiptPageState createState() => _ReceiptPageState(page: page);
}

class _ReceiptPageState extends State<ReceiptPage> {
  int page;
  _ReceiptPageState({required this.page});

  dynamic _listItem;

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    widget._homeController.getReceipt(page).then((listItem) {
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
        child: 
            Column(
            children: [
              Container(
              margin: EdgeInsets.only(top: 50, left: 30, right: 30),
              padding: EdgeInsets.all(10),
              color: Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Счет №${_listItem.id.toString()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                  Divider(
                      thickness: 1,
                      height: 20.0,
                      color: Colors.grey,
                  ),
                  Text('Оплата: ${_listItem.name}', textAlign: TextAlign.left,),
                  Text('Адрес: ${_listItem.address}', textAlign: TextAlign.left,),
                  Text('Тариф: ${_listItem.rateName}-${_listItem.rateCost}', textAlign: TextAlign.left,),
                  Text('Счетчик: ${_listItem.currentCount.toString()}', textAlign: TextAlign.left,),
                  Text('Стоимость: ${_listItem.cost.toString()} тенге', textAlign: TextAlign.left,),
                  Divider(
                      thickness: 1,
                      height: 20.0,
                      color: Colors.grey,
                  ),
                  Icon(Icons.add_task, color: Colors.green, size: 60,),
                ],
                ),
              ),
            ],)
          
        
      )
    );
  }
}
