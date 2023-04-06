import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobileapp/controllers/home_controller.dart';
import 'package:mobileapp/models/bills.dart';
import 'package:mobileapp/pages/MainDrawer.dart';
import 'package:mobileapp/pages/auth/login.dart';
import 'package:mobileapp/pages/bills/bills.dart';
import 'package:mobileapp/services/storage.dart';
import 'package:select_form_field/select_form_field.dart';

class BillCreatePage extends StatefulWidget {
  final HomeController _homeController = HomeController();
  @override
  _BillCreatePageState createState() => _BillCreatePageState();
}

class _BillCreatePageState extends State<BillCreatePage> {
  List<Bills> _listBills = [];
  int _id = 0;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    UsernameUpdate();
    widget._homeController.getBillName().then((billNames) {
      setState(() {
        billNames.forEach((element) {
          _items.add(element.toDatabaseJson());
        });
      });
    });
  }

  final SecureStorage storage = SecureStorage();
  String buttonText = '';
  String? _username = '';
  String IZI = '';
  TextEditingController countController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Container(
          
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              Text('Создать счет', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),),
              Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0
                  ),
                  child: SelectFormField(
                    type: SelectFormFieldType.dropdown,
                    labelText: 'Shape',
                    icon: Icon(Icons.arrow_drop_down),
                    style: TextStyle(color: Colors.white,),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white60),
                      labelText: 'Тип счетчика',
                      hintText: 'Выберите тип счетчика',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      ),
                    items: _items,
                    onChanged: (val) => _id = int.parse(val),
                  )
            ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0
                    ),
                child: TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  controller: countController,
                  maxLines: null,
                  style: TextStyle(color: Colors.white,),
                  decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white60),
                      border: OutlineInputBorder(),
                      labelText: 'Показание',
                      hintText: 'Показание счетчика'),
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
                    color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                child: TextButton(
                  onPressed: () async {
                      double count = double.parse(countController.text);
                      if (count != '') {
                        String reply = await widget._homeController.createBill(_id, count);
                        setState(() {
                          IZI = reply;
                        });
                      } else {
                        setState(() {
                          IZI = 'ВЫ НЕ УКАЗАЛИ ЗНАЧЕНИЯ';
                        });
                      }
                      
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BillsPage()));
                  },
                  child: Text(
                    'Создать',
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
