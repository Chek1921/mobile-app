import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/models/news.dart';
import 'package:mobileapp/models/receipts.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/pages/news/news.dart';
import 'package:mobileapp/services/storage.dart';

class ReceiptsPage extends StatefulWidget {
  final HomeController _homeController = HomeController();
  @override
  _ReceiptsPageState createState() => _ReceiptsPageState();

  
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  List<Receipts> _listReceipts = [];

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    widget._homeController.getReceipts().then((listReceipts) {
      setState(() {
        _listReceipts = listReceipts;
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
        itemCount: _listReceipts.length,
        itemBuilder: (context, index) {
          final itemReceipt = _listReceipts[_listReceipts.length-index-1];
          return ListTile(
            tileColor: Colors.green[400],
            title: Text(itemReceipt.name),
            subtitle: Text(
              '${itemReceipt.timeCreate.split('-')[2].split('T')[0]}.${itemReceipt.timeCreate.split('-')[1]}.${itemReceipt.timeCreate.split('-')[0]}г.',
            ),
            trailing: const Icon(Icons.arrow_forward_rounded),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => NewsPage()));
            },
          );
        },
      ),
    );
  }
}
