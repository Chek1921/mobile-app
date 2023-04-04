import 'package:flutter/material.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/models/bills.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/pages/news/new.dart';
import 'package:mobileapp/pages/receipts/receipt.dart';
import 'package:mobileapp/pages/receipts/receipts.dart';
import 'package:mobileapp/services/storage.dart';

class BillsPage extends StatefulWidget {
  final HomeController _homeController = HomeController();
  @override
  _BillsPageState createState() => _BillsPageState();

  
}

class _BillsPageState extends State<BillsPage> {
  List<Bills> _listBills = [];

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    widget._homeController.getBills().then((listBills) {
      setState(() {
        _listBills = listBills;
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
        itemCount: _listBills.length,
        itemBuilder: (context, index) {
          final itemBills = _listBills[index];
          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.grey[700],
            child: Column(
              children: [
                Text(itemBills.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Показание счетчика: ${itemBills.currentCount.toString()} у.е.', style: TextStyle(color: Colors.white)),
                      Text('Текущий тариф: за 1 у.е. к оплате ${itemBills.rate.toString()} тенге', style: TextStyle(color: Colors.white)),
                      Text('К оплате: ${itemBills.cost.toString()} тенге', style: TextStyle(color: Colors.white)),
                      Text('Послденяя оплата: ${itemBills.timePay.split('-')[2].split('T')[0]}.${itemBills.timePay.split('-')[1]}.${itemBills.timePay.split('-')[0]}г.', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: OutlinedButton(
                  onPressed: () async {
                    String result = await widget._homeController.makePayment(itemBills.id);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiptsPage()));
                    },
                  child: Text('Оплатить', style: TextStyle(color: Colors.white),),
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
